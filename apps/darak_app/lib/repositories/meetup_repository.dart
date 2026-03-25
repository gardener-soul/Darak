import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/firestore_paths.dart';
import '../core/providers/firebase_providers.dart';
import '../models/meetup.dart';

part 'meetup_repository.g.dart';

@riverpod
MeetupRepository meetupRepository(Ref ref) {
  return MeetupRepository(firestore: ref.watch(firestoreProvider));
}

/// `churches/{churchId}/meetups` 서브컬렉션 전담 Repository
class MeetupRepository {
  final FirebaseFirestore _firestore;

  MeetupRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // ─── 월별 번개 실시간 스트림 ────────────────────────────────────
  /// 특정 월의 번개 모임 목록을 실시간으로 구독합니다 (캘린더 마커용).
  Stream<List<MeetUp>> watchMeetupsByMonth({
    required String churchId,
    required int year,
    required int month,
  }) {
    final from = DateTime(year, month, 1);
    // month + 1이 13이 되는 경우 Dart가 자동으로 다음 해 1월로 처리
    final to = DateTime(year, month + 1);

    return _firestore
        .collection(FirestorePaths.churchMeetups(churchId))
        .where('scheduledAt', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('scheduledAt', isLessThan: Timestamp.fromDate(to))
        .orderBy('scheduledAt')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => MeetUp.fromJson(
                  _fromFirestore({...doc.data(), 'id': doc.id}),
                ),
              )
              .where((m) => m.deletedAt == null)
              .toList(),
        )
        .handleError((_) => <MeetUp>[]);
  }

  // ─── 번개 생성 ──────────────────────────────────────────────────
  Future<void> createMeetup({
    required String churchId,
    required MeetUp meetup,
  }) async {
    try {
      final col = _firestore.collection(FirestorePaths.churchMeetups(churchId));
      final doc = col.doc();
      final data = meetup.toJson();
      data['id'] = doc.id;
      if (meetup.scheduledAt != null) {
        data['scheduledAt'] = Timestamp.fromDate(meetup.scheduledAt!);
      }
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();
      data.remove('deletedAt');
      await doc.set(data);
    } catch (e) {
      throw Exception('번개 모임 생성에 실패했습니다: $e');
    }
  }

  // ─── 번개 참여 (트랜잭션: maxParticipants 초과 Race Condition 방어) ─────────
  Future<void> joinMeetup({
    required String churchId,
    required String meetupId,
    required String userId,
  }) async {
    try {
      final docRef = _firestore
          .collection(FirestorePaths.churchMeetups(churchId))
          .doc(meetupId);

      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(docRef);
        if (!snap.exists) throw Exception('존재하지 않는 모임입니다.');

        final data = _fromFirestore({...snap.data()!, 'id': snap.id});
        final meetup = MeetUp.fromJson(data);

        if (meetup.maxParticipants != null &&
            meetup.participantIds.length >= meetup.maxParticipants!) {
          throw Exception('이미 정원이 마감된 모임이에요.');
        }
        if (meetup.participantIds.contains(userId)) return; // 중복 참여 방지

        tx.update(docRef, {
          'participantIds': FieldValue.arrayUnion([userId]),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('번개 모임 참여에 실패했습니다: $e');
    }
  }

  // ─── 번개 참여 취소 ─────────────────────────────────────────────
  Future<void> leaveMeetup({
    required String churchId,
    required String meetupId,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection(FirestorePaths.churchMeetups(churchId))
          .doc(meetupId)
          .update({
        'participantIds': FieldValue.arrayRemove([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('번개 모임 참여 취소에 실패했습니다: $e');
    }
  }

  // ─── 번개 신고 ──────────────────────────────────────────────────
  Future<void> reportMeetup({
    required String churchId,
    required String meetupId,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection(FirestorePaths.churchMeetups(churchId))
          .doc(meetupId)
          .update({
        'reportedBy': FieldValue.arrayUnion([userId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('번개 모임 신고에 실패했습니다: $e');
    }
  }

  // ─── 번개 삭제 (Soft Delete) ────────────────────────────────────
  Future<void> deleteMeetup({
    required String churchId,
    required String meetupId,
  }) async {
    try {
      await _firestore
          .collection(FirestorePaths.churchMeetups(churchId))
          .doc(meetupId)
          .update({
        'deletedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('번개 모임 삭제에 실패했습니다: $e');
    }
  }

  // ─── Firestore 날짜 타입 변환 헬퍼 ─────────────────────────────
  Map<String, dynamic> _fromFirestore(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }
}
