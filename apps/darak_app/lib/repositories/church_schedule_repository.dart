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
