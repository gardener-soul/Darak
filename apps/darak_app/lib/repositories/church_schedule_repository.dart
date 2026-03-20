import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/constants/firestore_paths.dart';
import '../core/providers/firebase_providers.dart';
import '../models/church_schedule.dart';

part 'church_schedule_repository.g.dart';

/// Firestore `churches/{churchId}/schedules` 서브컬렉션 전담 Repository
@riverpod
ChurchScheduleRepository churchScheduleRepository(Ref ref) {
  return ChurchScheduleRepository(firestore: ref.watch(firestoreProvider));
}

class ChurchScheduleRepository {
  final FirebaseFirestore _firestore;

  ChurchScheduleRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // ─── 기간별 일정 조회 ────────────────────────────────────────
  /// [from] 이상 [to] 미만의 startAt을 가진 일정을 조회합니다.
  /// 삭제된 일정(deletedAt != null)은 제외합니다.
  Future<List<ChurchSchedule>> getSchedules({
    required String churchId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.churchSchedules(churchId))
          .where('deletedAt', isNull: true)
          .where('startAt', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
          .where('startAt', isLessThan: Timestamp.fromDate(to))
          .orderBy('startAt')
          .get();
      return snap.docs
          .map(
            (doc) => ChurchSchedule.fromJson(
              _fromFirestore({...doc.data(), 'id': doc.id}),
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('일정 조회에 실패했습니다: $e');
    }
  }

  // ─── 월별 일정 실시간 스트림 ──────────────────────────────────
  /// [year]년 [month]월의 일정을 실시간으로 구독합니다.
  /// 캘린더 이벤트 마커 표시에 사용합니다.
  ///
  /// [수정] deletedAt isNull + 범위 쿼리 복합 인덱스 에러 회피:
  /// Firestore에서 .where('deletedAt', isNull: true) + startAt 범위 쿼리 + orderBy
  /// 조합은 복합 인덱스가 배포되지 않으면 failed-precondition 에러를 발생시킨다.
  /// startAt 범위 쿼리만 Firestore에 위임하고, deletedAt 필터링은 클라이언트에서 수행한다.
  Stream<List<ChurchSchedule>> watchSchedulesByMonth({
    required String churchId,
    required int year,
    required int month,
  }) {
    final from = DateTime(year, month, 1);
    // 12월의 경우 다음 해 1월로 넘어가야 하므로 분기 처리
    final to = month == 12
        ? DateTime(year + 1, 1, 1)
        : DateTime(year, month + 1, 1);

    return _firestore
        .collection(FirestorePaths.churchSchedules(churchId))
        .where('startAt', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .where('startAt', isLessThan: Timestamp.fromDate(to))
        .orderBy('startAt')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => ChurchSchedule.fromJson(
                  _fromFirestore({...doc.data(), 'id': doc.id}),
                ),
              )
              .where((s) => s.deletedAt == null) // 클라이언트 사이드 deletedAt 필터
              .toList(),
        )
        .handleError((_) => <ChurchSchedule>[]); // 쿼리 오류 시 빈 목록으로 폴백
  }

  // ─── 일정 생성 ────────────────────────────────────────────────
  /// 새 일정 문서를 Firestore에 생성합니다.
  Future<void> createSchedule({
    required String churchId,
    required ChurchSchedule schedule,
  }) async {
    try {
      final col = _firestore.collection(FirestorePaths.churchSchedules(churchId));
      final doc = col.doc();
      final data = schedule.toJson();
      data['id'] = doc.id;
      data['startAt'] = Timestamp.fromDate(schedule.startAt);
      if (schedule.endAt != null) {
        data['endAt'] = Timestamp.fromDate(schedule.endAt!);
      }
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();
      // deletedAt은 null이므로 제거 후 저장
      data.remove('deletedAt');
      await doc.set(data);
    } catch (e) {
      throw Exception('일정 생성에 실패했습니다: $e');
    }
  }

  // ─── 일정 수정 ────────────────────────────────────────────────
  /// 기존 일정 문서를 수정합니다.
  Future<void> updateSchedule({
    required String churchId,
    required String scheduleId,
    required Map<String, dynamic> data,
  }) async {
    try {
      data['updatedAt'] = FieldValue.serverTimestamp();
      // DateTime 필드 Timestamp 변환
      if (data['startAt'] is DateTime) {
        data['startAt'] = Timestamp.fromDate(data['startAt'] as DateTime);
      }
      if (data['endAt'] is DateTime) {
        data['endAt'] = Timestamp.fromDate(data['endAt'] as DateTime);
      }
      await _firestore
          .collection(FirestorePaths.churchSchedules(churchId))
          .doc(scheduleId)
          .update(data);
    } catch (e) {
      throw Exception('일정 수정에 실패했습니다: $e');
    }
  }

  // ─── 일정 Soft Delete ─────────────────────────────────────────
  /// 일정 문서에 deletedAt을 설정합니다 (물리 삭제 X).
  Future<void> deleteSchedule({
    required String churchId,
    required String scheduleId,
  }) async {
    try {
      await _firestore
          .collection(FirestorePaths.churchSchedules(churchId))
          .doc(scheduleId)
          .update({
        'deletedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('일정 삭제에 실패했습니다: $e');
    }
  }

  // ─── Firestore 날짜 타입 변환 헬퍼 ─────────────────────────
  /// Timestamp → ISO 8601 문자열로 변환하여 Freezed 모델과의 호환성 확보
  Map<String, dynamic> _fromFirestore(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }
}
