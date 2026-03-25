import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/attendance.dart';
import '../../../models/attendance_status.dart';
import '../../../models/group.dart';
import '../../../models/village_with_groups.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/attendance/attendance_viewmodel.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';
import '../../../widgets/common/core/soft_chip.dart';
import 'attendance_history_sheet.dart';

/// 마을장이 마을 전체 출석 현황을 한눈에 파악하는 시트
/// - 이번 주 / 이번 달 탭 (SoftChip 2개)
/// - 마을 전체 출석률 요약 카드 (그라디언트 배경)
/// - 다락방별 출석 타일 (낮은 출석률 강조색)
class VillageAttendanceSheet extends ConsumerStatefulWidget {
  final VillageWithGroups villageWithGroups;
  final String churchId;

  const VillageAttendanceSheet({
    super.key,
    required this.villageWithGroups,
    required this.churchId,
  });

  static Future<void> show(
    BuildContext context, {
    required VillageWithGroups villageWithGroups,
    required String churchId,
  }) {
    return AppBottomSheet.show(
      context: context,
      child: VillageAttendanceSheet(
        villageWithGroups: villageWithGroups,
        churchId: churchId,
      ),
    );
  }

  @override
  ConsumerState<VillageAttendanceSheet> createState() =>
      _VillageAttendanceSheetState();
}

class _VillageAttendanceSheetState
    extends ConsumerState<VillageAttendanceSheet> {
  // true: 이번 주, false: 이번 달
  bool _isWeeklyTab = true;

  // build()마다 새 List 생성 시 Provider 캐시키가 깨지므로 initState에서 캐싱
  late final List<String> _groupIds;

  @override
  void initState() {
    super.initState();
    _groupIds = widget.villageWithGroups.groups.map((g) => g.id).toList();
  }

  (DateTime from, DateTime to) get _dateRange {
    final now = DateTime.now();
    if (_isWeeklyTab) {
      // 이번 주 월요일 ~ 오늘
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final from = DateTime(monday.year, monday.month, monday.day);
      final to = DateTime(now.year, now.month, now.day + 1);
      return (from, to);
    } else {
      // 이번 달 1일 ~ 오늘
      final from = DateTime(now.year, now.month, 1);
      final to = DateTime(now.year, now.month, now.day + 1);
      return (from, to);
    }
  }

  @override
  Widget build(BuildContext context) {
    final village = widget.villageWithGroups.village;
    final groups = widget.villageWithGroups.groups;
    final range = _dateRange;

    final attendancesAsync = ref.watch(
      villageAttendanceSummaryProvider(_groupIds, range.$1, range.$2),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── 헤더 ────────────────────────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.sageGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: AttendanceColors.present,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(village.name, style: AppTextStyles.headlineMedium),
                    const Text('출석 현황', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── 이번 주 / 이번 달 탭 ────────────────────────────────
          Row(
            children: [
              SoftChip(
                label: '이번 주',
                icon: Icons.calendar_view_week_rounded,
                color: AppColors.softCoral,
                isSelected: _isWeeklyTab,
                onTap: () => setState(() => _isWeeklyTab = true),
              ),
              const SizedBox(width: 8),
              SoftChip(
                label: '이번 달',
                icon: Icons.calendar_month_rounded,
                color: AppColors.softCoral,
                isSelected: !_isWeeklyTab,
                onTap: () => setState(() => _isWeeklyTab = false),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── 마을 전체 요약 카드 ────────────────────────────────
          attendancesAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: CircularProgressIndicator(
                  color: AttendanceColors.present,
                ),
              ),
            ),
            error: (_, __) => ClayCard(
              padding: const EdgeInsets.all(20),
              child: Text(
                '출석 현황을 불러오지 못했어요.',
                style: AppTextStyles.bodySmall,
              ),
            ),
            data: (attendances) {
              // ── 마을 전체 집계 ───────────────────────────────────
              final totalMembers = groups.fold<int>(
                0,
                (sum, g) => sum + (g.memberIds?.length ?? 0),
              );
              final presentCount = attendances
                  .where((a) => a.status == AttendanceStatus.present)
                  .length;
              final totalRate =
                  totalMembers > 0 ? presentCount / totalMembers : 0.0;

              // 다락방별 집계 맵
              final groupAttMap = <String, List<Attendance>>{};
              for (final a in attendances) {
                if (a.groupId != null) {
                  groupAttMap.putIfAbsent(a.groupId!, () => []).add(a);
                }
              }

              return Column(
                children: [
                  // 마을 전체 요약 카드
                  _VillageSummaryCard(
                    totalRate: totalRate,
                    present: presentCount,
                    total: totalMembers,
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('다락방별 현황', style: AppTextStyles.bodyLarge),
                      const Spacer(),
                      Text(
                        '${groups.length}개 다락방',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 다락방별 타일
                  ...groups.map((group) {
                    final gAtts = groupAttMap[group.id] ?? [];
                    final gMembers = group.memberIds?.length ?? 0;
                    final gPresent = gAtts
                        .where((a) => a.status == AttendanceStatus.present)
                        .length;
                    final gRate =
                        gMembers > 0 ? gPresent / gMembers : 0.0;

                    return _GroupAttendanceTile(
                      group: group,
                      rate: gRate,
                      present: gPresent,
                      total: gMembers,
                      onTap: () => AttendanceHistorySheet.show(
                        context,
                        groupId: group.id,
                        churchId: widget.churchId,
                        groupName: group.name,
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// 마을 전체 요약 카드 (그라디언트 배경)
// ───────────────────────────────────────────────────────────────────────────────

class _VillageSummaryCard extends StatelessWidget {
  final double totalRate; // 0.0 ~ 1.0
  final int present;
  final int total;

  const _VillageSummaryCard({
    required this.totalRate,
    required this.present,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = AttendanceColors.progressColor(totalRate);
    final percentLabel = '${(totalRate * 100).round()}%';

    return ClayCard(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.sageGreen.withValues(alpha: 0.15),
              AppColors.skyBlue.withValues(alpha: 0.10),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppDecorations.cardRadius,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('마을 전체 출석률', style: AppTextStyles.bodySmall),
                Text(
                  percentLabel,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: progressColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: totalRate,
                minHeight: 12,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$present / $total 명 출석',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// 다락방별 출석 타일
// ───────────────────────────────────────────────────────────────────────────────

class _GroupAttendanceTile extends StatelessWidget {
  final Group group;
  final double rate;
  final int present;
  final int total;
  final VoidCallback onTap;

  const _GroupAttendanceTile({
    required this.group,
    required this.rate,
    required this.present,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = AttendanceColors.progressColor(rate);
    final isLowRate = rate < 0.5;

    return BouncyTapWrapper(
      onTap: onTap,
      child: ClayCard(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        // 낮은 출석률 타일: 배경을 약하게 강조
        color: isLowRate
            ? AppColors.softCoral.withValues(alpha: 0.06)
            : AppColors.pureWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: AppTextStyles.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // 낮은 출석률 경고 아이콘
                if (isLowRate)
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AttendanceColors.absent,
                    size: 18,
                  ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textGrey,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(
                value: total > 0 ? rate : 0,
                minHeight: 10,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$present/$total 명',
                  style: AppTextStyles.bodySmall,
                ),
                Text(
                  '${(rate * 100).round()}%',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
