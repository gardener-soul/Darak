import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/firestore_paths.dart';
import '../core/providers/firebase_providers.dart';
import '../models/follow/follow.dart';
import '../models/follow/follow_status.dart';

part 'follow_repository.g.dart';

@riverpod
FollowRepository followRepository(Ref ref) {
  return FollowRepository(firestore: ref.watch(firestoreProvider));
}

/// follows 컬렉션 CRUD + 스트림 쿼리 전담 Repository
class FollowRepository {
  final FirebaseFirestore _firestore;

  FollowRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestorePaths.follows);

  // ─── 문서 ID 헬퍼 ─────────────────────────────────────────────────────────

  /// 팔로우 문서 ID: `{followerId}_{followeeId}` 패턴으로 중복 방지
  String _docId(String followerId, String followeeId) =>
      '${followerId}_$followeeId';

  // ─── 팔로우 요청 보내기 ────────────────────────────────────────────────────

  /// 팔로우 요청을 pending 상태로 생성. 이미 요청 또는 팔로우 중이면 무시.
  Future<void> sendFollowRequest({
    required String followerId,
    required String followeeId,
    required String churchId,
  }) async {
    try {
      final docId = _docId(followerId, followeeId);
      final existing = await _col.doc(docId).get();
      if (existing.exists) {
        // 이미 팔로우 요청 또는 팔로잉 상태 — 중복 방지
        return;
      }
      final now = DateTime.now();
      final follow = Follow(
        id: docId,
        followerId: followerId,
        followeeId: followeeId,
        churchId: churchId,
        status: FollowStatus.pending,
        createdAt: now,
        updatedAt: now,
      );
      final payload = _toFirestore(follow.toJson());
      payload['createdAt'] = FieldValue.serverTimestamp();
      payload['updatedAt'] = FieldValue.serverTimestamp();
      await _col.doc(docId).set(payload);
    } catch (e) {
      debugPrint('팔로우 요청 실패: $e');
      rethrow;
    }
  }

  // ─── 팔로우 요청 수락 ─────────────────────────────────────────────────────

  /// 팔로우 요청을 accepted 상태로 업데이트
  Future<void> acceptFollowRequest({required String followId}) async {
    try {
      await _col.doc(followId).update({
        'status': FollowStatus.accepted.toJson(),
        'acceptedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('팔로우 수락 실패: $e');
      rethrow;
    }
  }

  // ─── 팔로우 요청 거절 (Hard Delete) ──────────────────────────────────────

  /// 팔로우 요청을 거절하고 문서를 삭제
  Future<void> rejectFollowRequest({required String followId}) async {
    try {
      await _col.doc(followId).delete();
    } catch (e) {
      debugPrint('팔로우 거절 실패: $e');
      rethrow;
    }
  }

  // ─── 팔로우 취소 (Hard Delete) ────────────────────────────────────────────

  /// 내가 팔로우 중인 상대를 언팔로우
  Future<void> cancelFollow({
    required String followerId,
    required String followeeId,
  }) async {
    try {
      await _col.doc(_docId(followerId, followeeId)).delete();
    } catch (e) {
      debugPrint('팔로우 취소 실패: $e');
      rethrow;
    }
  }

  // ─── 팔로워 삭제 (Hard Delete) ────────────────────────────────────────────

  /// 나를 팔로우하는 사람을 팔로워 목록에서 제거
  Future<void> removeFollower({
    required String followerId,
    required String followeeId,
  }) async {
    try {
      await _col.doc(_docId(followerId, followeeId)).delete();
    } catch (e) {
      debugPrint('팔로워 삭제 실패: $e');
      rethrow;
    }
  }

  // ─── 팔로잉 목록 실시간 스트림 ────────────────────────────────────────────

  /// 내가 팔로우 중인(accepted) 목록 실시간 구독
  Stream<List<Follow>> watchFollowingList({required String userId}) {
    return _col
        .where('followerId', isEqualTo: userId)
        .where('status', isEqualTo: FollowStatus.accepted.toJson())
        .snapshots()
        .map(_snapToFollowList)
        .transform(_errorHandler('팔로잉 목록'));
  }

  // ─── 팔로워 목록 실시간 스트림 ────────────────────────────────────────────

  /// 나를 팔로우하는(accepted) 목록 실시간 구독
  Stream<List<Follow>> watchFollowerList({required String userId}) {
    return _col
        .where('followeeId', isEqualTo: userId)
        .where('status', isEqualTo: FollowStatus.accepted.toJson())
        .snapshots()
        .map(_snapToFollowList)
        .transform(_errorHandler('팔로워 목록'));
  }

  // ─── 팔로우 요청(나에게 온) 실시간 스트림 ─────────────────────────────────

  /// 나에게 온 pending 상태 팔로우 요청 실시간 구독
  Stream<List<Follow>> watchPendingRequests({required String userId}) {
    return _col
        .where('followeeId', isEqualTo: userId)
        .where('status', isEqualTo: FollowStatus.pending.toJson())
        .snapshots()
        .map(_snapToFollowList)
        .transform(_errorHandler('팔로우 요청 목록'));
  }

  // ─── 팔로우 상태 확인 ─────────────────────────────────────────────────────

  /// 두 사용자 간의 팔로우 상태 조회 (null = 팔로우 관계 없음)
  Future<FollowStatus?> getFollowStatus({
    required String followerId,
    required String followeeId,
  }) async {
    try {
      final doc = await _col.doc(_docId(followerId, followeeId)).get();
      if (!doc.exists) return null;
      final rawData = doc.data();
      if (rawData == null) return null;
      final data = _fromFirestore(
        Map<String, dynamic>.from(rawData)..['id'] = doc.id,
      );
      final follow = Follow.fromJson(data);
      return follow.status;
    } catch (e) {
      debugPrint('팔로우 상태 조회 실패: $e');
      return null;
    }
  }

  // ─── 팔로잉/팔로워 수 집계 ──────────────────────────────────────────────────

  /// 팔로잉 수 (accepted 상태만 카운트)
  Future<int> getFollowingCount({required String userId}) async {
    try {
      final agg = await _col
          .where('followerId', isEqualTo: userId)
          .where('status', isEqualTo: FollowStatus.accepted.toJson())
          .count()
          .get();
      return agg.count ?? 0;
    } catch (e) {
      debugPrint('팔로잉 수 조회 실패: $e');
      return 0;
    }
  }

  /// 팔로워 수 (accepted 상태만 카운트)
  Future<int> getFollowerCount({required String userId}) async {
    try {
      final agg = await _col
          .where('followeeId', isEqualTo: userId)
          .where('status', isEqualTo: FollowStatus.accepted.toJson())
          .count()
          .get();
      return agg.count ?? 0;
    } catch (e) {
      debugPrint('팔로워 수 조회 실패: $e');
      return 0;
    }
  }

  // ─── 팔로잉 ID 목록 스트림 ────────────────────────────────────────────────

  /// 내가 팔로우 중인 사용자 ID 목록 실시간 구독
  Stream<List<String>> watchFollowingIds({required String userId}) {
    return watchFollowingList(userId: userId).map(
      (follows) => follows.map((f) => f.followeeId).toList(),
    );
  }

  /// 내가 팔로우 중인 사용자 ID 목록 일회성 조회 (피드 타임라인 쿼리용)
  Future<List<String>> getFolloweeIds({required String userId}) async {
    try {
      final snap = await _col
          .where('followerId', isEqualTo: userId)
          .where('status', isEqualTo: FollowStatus.accepted.toJson())
          .get();
      return snap.docs
          .map((doc) => doc.data()['followeeId'] as String)
          .toList();
    } catch (e) {
      debugPrint('팔로잉 ID 목록 조회 실패: $e');
      return [];
    }
  }

  // ─── 내부 헬퍼 ───────────────────────────────────────────────────────────

  static const _dateTimeFields = {'createdAt', 'acceptedAt', 'updatedAt'};

  List<Follow> _snapToFollowList(QuerySnapshot<Map<String, dynamic>> snap) {
    return snap.docs.map((doc) {
      final data = Map<String, dynamic>.from(doc.data())..['id'] = doc.id;
      return Follow.fromJson(_fromFirestore(data));
    }).toList();
  }

  /// Firestore Timestamp → ISO 8601 문자열 변환
  Map<String, dynamic> _fromFirestore(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }

  /// DateTime(ISO 8601 문자열) → Firestore Timestamp 변환
  Map<String, dynamic> _toFirestore(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is String && _dateTimeFields.contains(key)) {
        final dt = DateTime.tryParse(value);
        if (dt != null) return MapEntry(key, Timestamp.fromDate(dt));
      }
      return MapEntry(key, value);
    });
  }

  StreamTransformer<List<Follow>, List<Follow>> _errorHandler(String label) {
    return StreamTransformer.fromHandlers(
      handleData: (data, sink) => sink.add(data),
      handleError: (error, stackTrace, sink) {
        debugPrint('$label 로드 실패: $error');
        sink.add(<Follow>[]);
      },
    );
  }
}
