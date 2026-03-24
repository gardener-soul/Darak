import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/attendance.dart';
import '../../models/attendance_status.dart';
import '../../repositories/attendance_repository.dart';
import '../../theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════════
// 출석 히트맵 데이터 모델
// ═══════════════════════════════════════════════════════════════

/// 히트맵 셀 하나에 해당하는 날짜별 출석 정보
class HeatmapDayData {
  /// 해당 날짜 (시간은 0으로 정규화)
  final DateTime date;

  /// 해당 날짜의 출석 기록 목록
  final List<Attendance> attendances;

  const HeatmapDayData({required this.date, required this.attendances});

  /// 출석 횟수 (present/late만 카운트)
  int get attendedCount => attendances
      .where((a) =>
          a.status == AttendanceStatus.present ||
          a.status == AttendanceStatus.late)
      .length;

  /// 출석 기록이 있는지 여부
  bool get hasAttendance => attendances.isNotEmpty;
}

// ═══════════════════════════════════════════════════════════════
// 출석 뱃지 시스템 (§3-2-3, Phase 2)
// ═══════════════════════════════════════════════════════════════

/// 출석 달성 뱃지 데이터 모델
///
/// DB 저장 없이 순수 클라이언트 계산으로 동작합니다.
class AttendanceBadge {
  /// 뱃지 이름
  final String name;

  /// 달성 조건 설명 (다이얼로그에서 표시)
  final String condition;

  /// 뱃지 아이콘
  final IconData icon;

  /// 뱃지 색상 (획득 시 사용)
  final Color color;

  /// 획득 여부
  final bool isEarned;

  const AttendanceBadge({
    required this.name,
    required this.condition,
    required this.icon,
    required this.color,
    required this.isEarned,
  });
}

/// 히트맵 데이터와 연속 주수를 기반으로 뱃지 목록을 계산합니다.
///
/// 클라이언트 계산 전용 — DB 저장 불필요.
List<AttendanceBadge> calculateBadges({
  required List<HeatmapDayData> cells,
  required int consecutiveWeeks,
}) {
  // "첫 걸음": 히트맵 셀 기준 출석 기록이 1회 이상 존재
  final hasAnyAttendance = cells.any((c) => c.hasAttendance);

  return [
    AttendanceBadge(
      name: '첫 걸음',
      condition: '총 출석 1회 이상',
      icon: Icons.directions_walk_rounded,
      color: AppColors.skyBlue,
      isEarned: hasAnyAttendance,
    ),
    AttendanceBadge(
      name: '불꽃의 시작',
      condition: '4주 연속 출석',
      icon: Icons.local_fire_department_rounded,
      color: AppColors.warmTangerine,
      isEarned: consecutiveWeeks >= 4,
    ),
    AttendanceBadge(
      name: '꾸준한 발걸음',
      condition: '8주 연속 출석',
      icon: Icons.star_rounded,
      color: AppColors.softLavender,
      isEarned: consecutiveWeeks >= 8,
    ),
    AttendanceBadge(
      name: '한결같은 믿음',
      condition: '12주 연속 출석',
      icon: Icons.workspace_premium_rounded,
      color: AppColors.softCoral,
      isEarned: consecutiveWeeks >= 12,
    ),
    AttendanceBadge(
      name: '반년의 동행',
      condition: '24주 연속 출석',
      icon: Icons.emoji_events_rounded,
      color: AppColors.sageGreen,
      isEarned: consecutiveWeeks >= 24,
    ),
  ];
}

// ═══════════════════════════════════════════════════════════════
// Provider 정의
// ═══════════════════════════════════════════════════════════════

/// 최근 12주 히트맵 데이터 Provider
///
/// 반환값: `List<HeatmapDayData>` (84개 셀, 최신순)
final attendanceHeatmapProvider =
    FutureProvider.family<List<HeatmapDayData>, String>(
  (ref, userId) async {
    final repo = ref.watch(attendanceRepositoryProvider);

    final now = DateTime.now();
    // 오늘 기준 12주 전 일요일(주 시작) 계산
    final todayNormalized = DateTime(now.year, now.month, now.day);
    final weeksAgo12 = todayNormalized.subtract(const Duration(days: 84));

    final attendances = await repo.getHeatmapAttendances(
      userId: userId,
      from: weeksAgo12,
    );

    // 날짜별 맵으로 그룹핑
    final Map<String, List<Attendance>> byDate = {};
    for (final a in attendances) {
      final key = _dateKey(a.date);
      byDate.putIfAbsent(key, () => []).add(a);
    }

    // 84일 (12주) 셀 생성: 오늘부터 역순 84일
    final cells = <HeatmapDayData>[];
    for (var i = 83; i >= 0; i--) {
      final date = todayNormalized.subtract(Duration(days: i));
      final key = _dateKey(date);
      cells.add(HeatmapDayData(
        date: date,
        attendances: byDate[key] ?? [],
      ));
    }

    return cells;
  },
);

/// 날짜를 문자열 키로 변환 (yyyy-MM-dd)
final _dateKeyFmt = DateFormat('yyyy-MM-dd');
String _dateKey(DateTime date) => _dateKeyFmt.format(date);
