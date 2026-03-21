import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/attendance.dart';
import '../../../models/attendance_status.dart';
import '../../../models/attendance_type.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/attendance/attendance_viewmodel.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';
import '../../../widgets/common/core/bouncy_icon_btn.dart';

/// 다락방 월별 출석 기록 조회 시트 (순장/관리자)
/// - 월 네비게이션 (← 현재 달까지)
/// - 날짜별 출석 요약 카드 (ClayCard + 상태 뱃지)
/// - AnimatedSwitcher로 월 변경 시 페이드 전환
class AttendanceHistorySheet extends ConsumerStatefulWidget {
  final String groupId;
  final String churchId;
  final String groupName;

  const AttendanceHistorySheet({
    super.key,
    required this.groupId,
    required this.churchId,
    required this.groupName,
  });

  static Future<void> show(
    BuildContext context, {
    required String groupId,
    required String churchId,
    required String groupName,
  }) {
    return AppBottomSheet.show(
      context: context,
      child: AttendanceHistorySheet(
        groupId: groupId,
        churchId: churchId,
        groupName: groupName,
      ),
    );
  }

  @override
  ConsumerState<AttendanceHistorySheet> createState() =>
      _AttendanceHistorySheetState();
}

class _AttendanceHistorySheetState
    extends ConsumerState<AttendanceHistorySheet> {
  late DateTime _viewMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _viewMonth = DateTime(now.year, now.month);
  }

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _viewMonth.year == now.year && _viewMonth.month == now.month;
  }

  void _prevMonth() =>
      setState(() => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1));

  void _nextMonth() {
    if (_isCurrentMonth) return;
    setState(() => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── 헤더 ───────────────────────────────────────────────────
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.softLavender.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.history_rounded,
                color: AppColors.textDark,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.groupName, style: AppTextStyles.headlineMedium),
                  const Text('출석 기록', style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ── 월 네비게이션 ─────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BouncyIconBtn(
                icon: Icons.chevron_left_rounded,
                color: AppColors.textGrey,
                size: IconBtnSize.small,
                onTap: _prevMonth,
              ),
              Text(
                '${_viewMonth.year}년 ${_viewMonth.month}월',
                style: AppTextStyles.bodyLarge,
              ),
              BouncyIconBtn(
                icon: Icons.chevron_right_rounded,
                color: _isCurrentMonth ? AppColors.disabled : AppColors.textGrey,
                size: IconBtnSize.small,
                onTap: _isCurrentMonth ? null : _nextMonth,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Divider(color: AppColors.divider, height: 1),
        const SizedBox(height: 12),

        // ── 날짜별 기록 카드 (월 변경 시 AnimatedSwitcher) ─────────
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _DateRecordList(
            key: ValueKey('${_viewMonth.year}-${_viewMonth.month}'),
            groupId: widget.groupId,
            viewMonth: _viewMonth,
          ),
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// 날짜별 기록 리스트 (월별 스트림 구독)
// ───────────────────────────────────────────────────────────────────────────────

class _DateRecordList extends ConsumerWidget {
  final String groupId;
  final DateTime viewMonth;

  const _DateRecordList({
    super.key,
    required this.groupId,
    required this.viewMonth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendancesAsync = ref.watch(
      groupAttendanceByMonthProvider(groupId, viewMonth.year, viewMonth.month),
    );

    return attendancesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: CircularProgressIndicator(color: AttendanceColors.present),
        ),
      ),
      error: (err, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            '출석 기록을 불러오지 못했어요.',
            style: AppTextStyles.bodySmall,
          ),
        ),
      ),
      data: (attendances) {
        if (attendances.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.event_busy_rounded,
                    size: 48,
                    color: AppColors.disabled,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${viewMonth.month}월 출석 기록이 없어요.',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }

        // 날짜+유형 기준으로 그룹핑
        final groupedMap = _groupByDateAndType(attendances);
        final sortedKeys = groupedMap.keys.toList()
          ..sort((a, b) => b.$1.compareTo(a.$1)); // 최신 날짜 먼저

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedKeys.length,
          itemBuilder: (ctx, i) {
            final key = sortedKeys[i];
            final records = groupedMap[key]!;
            final date = key.$1;
            final type = key.$2;

            var present = 0, late = 0, absent = 0, excused = 0;
            for (final a in records) {
              switch (a.status) {
                case AttendanceStatus.present: present++; break;
                case AttendanceStatus.late:    late++;    break;
                case AttendanceStatus.absent:  absent++;  break;
                case AttendanceStatus.excused: excused++; break;
                default: break;
              }
            }

            return _DateRecordCard(
              dateLabel: _formatDate(date),
              typeLabel: type.label,
              presentCount: present,
              lateCount: late,
              absentCount: absent,
              excusedCount: excused,
              onTap: () {
                // TODO: 멤버별 상세 바텀시트 (v2)
              },
            );
          },
        );
      },
    );
  }

  /// 날짜 + 유형 조합으로 그룹핑
  Map<(DateTime, AttendanceType), List<Attendance>> _groupByDateAndType(
    List<Attendance> attendances,
  ) {
    final map = <(DateTime, AttendanceType), List<Attendance>>{};
    for (final a in attendances) {
      final dayKey = DateTime(a.date.year, a.date.month, a.date.day);
      map.putIfAbsent((dayKey, a.type), () => []).add(a);
    }
    return map;
  }

  String _formatDate(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[date.weekday - 1];
    return '${date.month}월 ${date.day}일 ($weekday)';
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// 날짜별 요약 카드
// ───────────────────────────────────────────────────────────────────────────────

class _DateRecordCard extends StatelessWidget {
  final String dateLabel;
  final String typeLabel;
  final int presentCount;
  final int lateCount;
  final int absentCount;
  final int excusedCount;
  final VoidCallback onTap;

  const _DateRecordCard({
    required this.dateLabel,
    required this.typeLabel,
    required this.presentCount,
    required this.lateCount,
    required this.absentCount,
    required this.excusedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyTapWrapper(
      onTap: onTap,
      child: ClayCard(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dateLabel, style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 4),
                  Text(typeLabel, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            // ── 상태별 수 뱃지 ────────────────────────────────────
            _AttendanceStatusBadge(
              status: AttendanceStatus.present,
              count: presentCount,
            ),
            const SizedBox(width: 4),
            _AttendanceStatusBadge(
              status: AttendanceStatus.late,
              count: lateCount,
            ),
            const SizedBox(width: 4),
            _AttendanceStatusBadge(
              status: AttendanceStatus.absent,
              count: absentCount,
            ),
            if (excusedCount > 0) ...[
              const SizedBox(width: 4),
              _AttendanceStatusBadge(
                status: AttendanceStatus.excused,
                count: excusedCount,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// 상태 수 뱃지 (Pill 형태) — 앱 전역 공유용으로 분리
// ───────────────────────────────────────────────────────────────────────────────

class _AttendanceStatusBadge extends StatelessWidget {
  final AttendanceStatus status;
  final int count;

  static const _colors = {
    AttendanceStatus.present: AttendanceColors.present,
    AttendanceStatus.late: AttendanceColors.late,
    AttendanceStatus.absent: AttendanceColors.absent,
    AttendanceStatus.excused: AttendanceColors.excused,
  };

  static const _labels = {
    AttendanceStatus.present: '출석',
    AttendanceStatus.late: '지각',
    AttendanceStatus.absent: '결석',
    AttendanceStatus.excused: '사유',
  };

  const _AttendanceStatusBadge({required this.status, required this.count});

  @override
  Widget build(BuildContext context) {
    final color = _colors[status] ?? AppColors.textGrey;
    final label = _labels[status] ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        '$label $count',
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}
