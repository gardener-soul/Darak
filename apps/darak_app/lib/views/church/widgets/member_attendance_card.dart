import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/attendance.dart';
import '../../../models/attendance_status.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/empty_state_view.dart';
import '../../../widgets/common/skeleton_card.dart';

/// 순원 상세 화면 - 출석 현황 섹션
class MemberAttendanceCard extends StatelessWidget {
  final AsyncValue<List<Attendance>> attendanceAsync;
  final Map<String, dynamic>? attendanceStats; // user.attendanceStats 캐시

  const MemberAttendanceCard({
    super.key,
    required this.attendanceAsync,
    this.attendanceStats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        Row(
          children: [
            const Icon(
              Icons.calendar_month_rounded,
              color: AppColors.warmTangerine,
              size: 22,
            ),
            const SizedBox(width: 8),
            const Text('출석 현황', style: AppTextStyles.bodyLarge),
          ],
        ),
        const SizedBox(height: 12),

        ClayCard(
          padding: const EdgeInsets.all(20),
          child: attendanceAsync.when(
            loading: () => Column(
              children: [
                const SkeletonCard(height: 20, borderRadius: 8),
                const SizedBox(height: 12),
                const SkeletonCard(height: 16, borderRadius: 8),
                const SizedBox(height: 8),
                const SkeletonCard(height: 16, borderRadius: 8),
              ],
            ),
            error: (err, st) => const Text('출석 기록을 불러오지 못했어요.'),
            data: (attendances) {
              if (attendances.isEmpty) {
                return const EmptyStateView(
                  icon: Icons.calendar_today_rounded,
                  message: '아직 출석 기록이 없어요',
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 출석률 바
                  _buildRateBar(attendances),
                  const SizedBox(height: 20),
                  const Divider(color: AppColors.divider, height: 1),
                  const SizedBox(height: 16),
                  // 최근 출석 기록 목록
                  ...attendances.take(6).map((a) => _AttendanceRow(attendance: a)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRateBar(List<Attendance> attendances) {
    // attendanceStats 캐시 우선 사용
    int total = attendanceStats?['total'] as int? ?? attendances.length;
    int attended = attendanceStats?['attended'] as int? ??
        attendances.where((a) => a.status == AttendanceStatus.present).length;

    final rate = total > 0 ? (attended / total).clamp(0.0, 1.0) : 0.0;
    final progressColor = _progressColor(rate);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: rate),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (ctx, value, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('출석률', style: AppTextStyles.bodySmall),
              Text(
                '${(value * 100).round()}%',
                style: AppTextStyles.bodyLarge.copyWith(color: progressColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              FractionallySizedBox(
                widthFactor: value,
                child: Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(99),
                    boxShadow: [
                      BoxShadow(
                        color: progressColor.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          child!,
        ],
      ),
      child: Text(
        '$attended / $total 회 출석',
        style: AppTextStyles.bodySmall,
      ),
    );
  }

  Color _progressColor(double rate) {
    if (rate >= 0.75) return AttendanceColors.present;
    if (rate >= 0.5) return AppColors.warmTangerine;
    return AppColors.softCoral;
  }
}

class _AttendanceRow extends StatelessWidget {
  final Attendance attendance;

  const _AttendanceRow({required this.attendance});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(attendance.status);
    final icon = _statusIcon(attendance.status);
    final label = _statusLabel(attendance.status);
    final dayLabel = _dayLabel(attendance.date);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('M월 d일 ($dayLabel)').format(attendance.date),
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return AttendanceColors.present;
      case AttendanceStatus.late:
        return AttendanceColors.late;
      case AttendanceStatus.absent:
        return AttendanceColors.absent;
      case AttendanceStatus.excused:
        return AttendanceColors.excused;
      default:
        return AppColors.textGrey;
    }
  }

  IconData _statusIcon(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Icons.check_rounded;
      case AttendanceStatus.late:
        return Icons.schedule_rounded;
      case AttendanceStatus.absent:
        return Icons.close_rounded;
      case AttendanceStatus.excused:
        return Icons.info_outline_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _statusLabel(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return '출석';
      case AttendanceStatus.late:
        return '지각';
      case AttendanceStatus.absent:
        return '결석';
      case AttendanceStatus.excused:
        return '공결';
      default:
        return '기타';
    }
  }

  String _dayLabel(DateTime date) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return days[date.weekday - 1];
  }
}
