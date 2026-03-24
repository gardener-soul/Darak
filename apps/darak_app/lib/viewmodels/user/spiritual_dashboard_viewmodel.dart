import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/attendance.dart';
import '../../models/attendance_status.dart';
import '../../models/attendance_type.dart';
import '../../repositories/attendance_repository.dart';
import '../../repositories/group_repository.dart';
import 'prayer_archive_viewmodel.dart';

// ═══════════════════════════════════════════════════════════════
// 영적 여정 대시보드 집계 데이터 모델
// ═══════════════════════════════════════════════════════════════

/// 마이페이지 상단 2x2 요약 카드에서 사용할 집계 데이터
class SpiritualDashboardData {
  /// 연속 출석 주수 (주일예배 기준)
  final int consecutiveWeeks;

  /// 이번 달 출석률 (0~100)
  final int monthlyRatePercent;

  /// 이번 달 출석 횟수
  final int monthlyAttended;

  /// 이번 달 전체 예배/모임 횟수
  final int monthlyTotal;

  /// 응답된 기도 건수
  final int answeredPrayerCount;

  /// 소속 다락방 이름 (없으면 null)
  final String? groupName;

  const SpiritualDashboardData({
    required this.consecutiveWeeks,
    required this.monthlyRatePercent,
    required this.monthlyAttended,
    required this.monthlyTotal,
    required this.answeredPrayerCount,
    this.groupName,
  });
}

// ═══════════════════════════════════════════════════════════════
// Provider 정의 (수동 — build_runner 불필요)
// ═══════════════════════════════════════════════════════════════

/// 영적 여정 대시보드 집계 데이터 Provider
final spiritualDashboardProvider =
    FutureProvider.family<SpiritualDashboardData, ({String userId, String? groupId})>(
  (ref, args) async {
    final attendanceRepo = ref.watch(attendanceRepositoryProvider);

    // ─── 모든 데이터 병렬 조회 (Riverpod 캐시 공유로 중복 Firestore 호출 방지) ──
    final streakFuture = attendanceRepo.getAttendancesForStreak(
      userId: args.userId,
    );
    final answeredFuture = ref.read(
      answeredPrayerCountProvider(args.userId).future,
    );
    final groupFuture = _fetchGroupName(ref, args.groupId);
    final monthlyFuture = ref.read(
      monthlyAttendanceProvider(args.userId).future,
    );

    final streakAttendances = await streakFuture;
    final answeredCount = await answeredFuture;
    final groupName = await groupFuture;
    final monthlyStats = await monthlyFuture;

    // ─── 연속 출석 주수 계산 ──────────────────────────────────────
    final consecutiveWeeks = _calculateConsecutiveWeeks(streakAttendances);

    // ─── 이번 달 출석률 계산 (monthlyAttendanceProvider 캐시 재사용) ────────
    final rate = monthlyStats.total > 0
        ? (monthlyStats.attended / monthlyStats.total * 100).round()
        : 0;

    return SpiritualDashboardData(
      consecutiveWeeks: consecutiveWeeks,
      monthlyRatePercent: rate,
      monthlyAttended: monthlyStats.attended,
      monthlyTotal: monthlyStats.total,
      answeredPrayerCount: answeredCount,
      groupName: groupName,
    );
  },
);

/// 이번 달 출석 상세 Provider (MonthlyAttendanceBar용)
final monthlyAttendanceProvider =
    FutureProvider.family<({int attended, int total}), String>(
  (ref, userId) async {
    final repo = ref.watch(attendanceRepositoryProvider);
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);

    try {
      final attendances = await repo.getHeatmapAttendances(
        userId: userId,
        from: monthStart,
      );
      final attended = attendances
          .where((a) =>
              a.status == AttendanceStatus.present ||
              a.status == AttendanceStatus.late)
          .length;
      return (attended: attended, total: attendances.length);
    } catch (e) {
      debugPrint('이번 달 출석 통계 조회 실패: $e');
      return (attended: 0, total: 0);
    }
  },
);

// ─── 헬퍼 함수 ────────────────────────────────────────────────

/// 그룹 이름 조회 (groupId가 없으면 null 반환)
Future<String?> _fetchGroupName(Ref ref, String? groupId) async {
  if (groupId == null || groupId.isEmpty) return null;
  try {
    final group = await ref
        .read(groupRepositoryProvider)
        .getGroupById(groupId);
    return group?.name;
  } catch (e) {
    debugPrint('그룹 이름 조회 실패: $e');
    return null;
  }
}

/// 주일예배(onlySundayService) 기준 연속 출석 주수 계산
///
/// 출석 기록을 주 단위로 그룹핑하여, 가장 최근 주부터 역순으로
/// 연속 출석 주수를 계산합니다.
int _calculateConsecutiveWeeks(List<Attendance> attendances) {
  if (attendances.isEmpty) return 0;

  // 주일예배 출석만 필터링
  final sundayServices = attendances
      .where((a) => a.type == AttendanceType.onlySundayService)
      .toList();

  if (sundayServices.isEmpty) {
    // 주일예배 기록이 없으면 전체 출석 중 가장 많은 유형 사용
    // 전체 출석의 주 단위로 계산
    return _calcWeeks(attendances);
  }

  // 주일예배 기록이 있으면 주일예배 기준만 사용
  return _calcWeeks(sundayServices);
}

/// 출석 목록을 주 단위로 계산하여 연속 주수를 반환합니다.
int _calcWeeks(List<Attendance> attendances) {
  if (attendances.isEmpty) return 0;

  // 날짜를 ISO 주 번호로 변환 (year * 100 + weekNumber)
  final attendedWeeks = <int>{};
  for (final a in attendances) {
    attendedWeeks.add(_isoWeekKey(a.date));
  }

  if (attendedWeeks.isEmpty) return 0;

  // 현재 주부터 역순으로 연속 체크
  final now = DateTime.now();
  var weekKey = _isoWeekKey(now);
  var count = 0;

  for (var i = 0; i < 200; i++) {
    if (attendedWeeks.contains(weekKey)) {
      count++;
    } else if (count > 0) {
      // 현재 주에 아직 출석이 없을 경우 1주 여유 허용
      if (i == 0) {
        weekKey = _prevWeekKey(weekKey);
        continue;
      }
      break;
    }
    weekKey = _prevWeekKey(weekKey);
  }

  return count;
}

/// DateTime을 주 고유 키로 변환 (year * 100 + weekOfYear)
int _isoWeekKey(DateTime date) {
  // ISO 8601 주 번호 계산
  final jan4 = DateTime(date.year, 1, 4);
  final startOfWeek1 = jan4.subtract(Duration(days: jan4.weekday - 1));
  final diff = date.difference(startOfWeek1).inDays;
  if (diff < 0) {
    // 작년 마지막 주에 속함
    return _isoWeekKey(DateTime(date.year - 1, 12, 28));
  }
  final weekNum = diff ~/ 7 + 1;
  if (weekNum > 52) {
    final nextJan4 = DateTime(date.year + 1, 1, 4);
    final nextStart = nextJan4.subtract(Duration(days: nextJan4.weekday - 1));
    if (date.isAfter(nextStart) || date.isAtSameMomentAs(nextStart)) {
      return (date.year + 1) * 100 + 1; // 다음 해 1주차
    }
  }
  return date.year * 100 + weekNum;
}

/// 이전 주 키 반환
int _prevWeekKey(int weekKey) {
  final year = weekKey ~/ 100;
  final week = weekKey % 100;
  if (week <= 1) {
    // 작년 마지막 주
    return _isoWeekKey(DateTime(year - 1, 12, 28));
  }
  return year * 100 + (week - 1);
}
