import 'dart:async';
import 'dart:math' show min;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/firestore_paths.dart';
import '../core/providers/firebase_providers.dart';
import '../models/prayer.dart';
import '../models/prayer_period_type.dart';
import '../models/prayer_status.dart';
import '../models/prayer_visibility.dart';

part 'prayer_repository.g.dart';

@riverpod
PrayerRepository prayerRepository(Ref ref) {
  return PrayerRepository(firestore: ref.watch(firestoreProvider));
}

/// prayers 컬렉션 CRUD + 스트림 쿼리 전담 Repository
class PrayerRepository {
  final FirebaseFirestore _firestore;

  PrayerRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestorePaths.prayers);

  // ─── 내 기도 목록 실시간 스트림 ────────────────────────────────────────────

  /// 본인 기도 제목 전체를 실시간 구독 (삭제된 항목 제외, 최신순)
  Stream<List<Prayer>> watchMyPrayers({required String userId}) {
    return _col
        .where('userId', isEqualTo: userId)
        .where('deletedAt', isNull: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_snapToPrayerList)
        .transform(_errorHandler('내 기도 목록'));
  }

  // ─── 공동체 기도 목록 실시간 스트림 ──────────────────────────────────────

  /// 같은 다락방의 공개(group) 기도 제목을 실시간 구독 (삭제된 항목 제외, 최신순)
  Stream<List<Prayer>> watchCommunityPrayers({required String groupId}) {
    return _col
        .where('groupId', isEqualTo: groupId)
        .where('visibility', isEqualTo: PrayerVisibility.group.toJson())
        .where('deletedAt', isNull: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_snapToPrayerList)
        .transform(_errorHandler('공동체 기도 목록'));
  }

  // ─── 기도 등록 ────────────────────────────────────────────────────────────

  /// 새 기도 제목을 Firestore에 저장
  Future<void> createPrayer({
    required String userId,
    required String churchId,
    String? groupId,
    required String content,
    required PrayerVisibility visibility,
    required PrayerPeriodType periodType,
    required DateTime startDate,
    DateTime? endDate,
  }) async {
    try {
      final docRef = _col.doc();
      final now = DateTime.now();
      final prayer = Prayer(
        id: docRef.id,
        userId: userId,
        churchId: churchId,
        groupId: groupId,
        content: content,
        visibility: visibility,
        status: PrayerStatus.active,
        periodType: periodType,
        startDate: startDate,
        endDate: endDate,
        createdAt: now,
        updatedAt: now,
      );
      // createdAt/updatedAt은 서버 타임스탬프로 덮어써 클라이언트 시각 위조를 방지
      final payload = _toFirestore(prayer.toJson())
        ..['createdAt'] = FieldValue.serverTimestamp()
        ..['updatedAt'] = FieldValue.serverTimestamp();
      await docRef.set(payload);
    } catch (e) {
      debugPrint('기도 등록 실패: $e');
      rethrow;
    }
  }

  // ─── 기도 수정 ────────────────────────────────────────────────────────────

  /// 기도 제목, 기간, 공개 범위 수정
  Future<void> updatePrayer({
    required String prayerId,
    String? content,
    PrayerVisibility? visibility,
    PrayerPeriodType? periodType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (content != null) updates['content'] = content;
      if (visibility != null) updates['visibility'] = visibility.toJson();
      if (periodType != null) updates['periodType'] = periodType.toJson();
      if (startDate != null) {
        updates['startDate'] = Timestamp.fromDate(startDate);
      }
      // endDate: null 허용 (indefinite 설정 가능)
      if (endDate != null) {
        updates['endDate'] = Timestamp.fromDate(endDate);
      } else if (periodType == PrayerPeriodType.indefinite) {
        updates['endDate'] = null;
      }
      await _col.doc(prayerId).update(updates);
    } catch (e) {
      debugPrint('기도 수정 실패: $e');
      rethrow;
    }
  }

  // ─── 상태 변경 (응답됨) ───────────────────────────────────────────────────

  /// 기도 상태를 answered로 변경
  Future<void> markAsAnswered({required String prayerId}) async {
    try {
      await _col.doc(prayerId).update({
        'status': PrayerStatus.answered.toJson(),
        'answeredAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('기도 응답 처리 실패: $e');
      rethrow;
    }
  }

  // ─── 기도 삭제 (Soft Delete) ─────────────────────────────────────────────

  /// deletedAt을 설정하여 Soft Delete 처리
  Future<void> deletePrayer({required String prayerId}) async {
    try {
      await _col.doc(prayerId).update({
        'deletedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('기도 삭제 실패: $e');
      rethrow;
    }
  }

  // ─── 팔로잉 기도 목록 스트림 ──────────────────────────────────────────────

  /// 팔로잉 중인 사용자들의 followers 공개 기도 제목 실시간 구독
  /// Firestore whereIn 30개 제한을 처리하기 위해 30개씩 chunk 분할 후 병합
  Stream<List<Prayer>> watchFollowersPrayers({
    required List<String> followeeIds,
  }) {
    if (followeeIds.isEmpty) {
      return Stream.value([]);
    }

    // 30개씩 chunk 분할 (Firestore whereIn 제한)
    final chunks = <List<String>>[];
    for (var i = 0; i < followeeIds.length; i += 30) {
      chunks.add(followeeIds.sublist(i, min(i + 30, followeeIds.length)));
    }

    // 각 chunk 스트림을 병합 후 최신순 정렬
    final streams = chunks.map(
      (chunk) => _col
          .where('userId', whereIn: chunk)
          .where('visibility', isEqualTo: PrayerVisibility.followers.toJson())
          .where('deletedAt', isNull: true)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(_snapToPrayerList),
    );

    if (streams.length == 1) {
      return streams.first.transform(_errorHandler('팔로잉 기도 목록'));
    }

    // 여러 스트림을 combineLatest 방식으로 병합
    return streams
        .reduce(
          (combined, stream) => combined.asyncExpand(
            (a) => stream.map(
              (b) => [...a, ...b]
                ..sort((x, y) => y.createdAt.compareTo(x.createdAt)),
            ),
          ),
        )
        .transform(_errorHandler('팔로잉 기도 목록'));
  }

  // ─── 내부 헬퍼 ───────────────────────────────────────────────────────────

  static const _dateTimeFields = {
    'startDate',
    'endDate',
    'createdAt',
    'updatedAt',
    'answeredAt',
    'deletedAt',
  };

  List<Prayer> _snapToPrayerList(QuerySnapshot<Map<String, dynamic>> snap) {
    return snap.docs.map((doc) {
      // SDK 내부 캐시 오염 방지를 위해 방어적 복사 후 id 주입
      final data = Map<String, dynamic>.from(doc.data())..['id'] = doc.id;
      return Prayer.fromJson(_fromFirestore(data));
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

  StreamTransformer<List<Prayer>, List<Prayer>> _errorHandler(String label) {
    return StreamTransformer.fromHandlers(
      handleData: (data, sink) => sink.add(data),
      handleError: (error, stackTrace, sink) {
        debugPrint('$label 로드 실패: $error');
        sink.add(<Prayer>[]);
      },
    );
  }
}
