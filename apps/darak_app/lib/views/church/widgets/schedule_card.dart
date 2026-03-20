import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/church_schedule.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';

/// 교회 일정 카드 위젯
/// 카테고리 배지 + 일정 제목/날짜/장소 정보 표시
class ScheduleCard extends StatelessWidget {
  final ChurchSchedule schedule;

  const ScheduleCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CategoryBadge(category: schedule.category),
          const SizedBox(width: 12),
          Expanded(child: _ScheduleInfo(schedule: schedule)),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _CategoryBadge extends StatelessWidget {
  final ScheduleCategory category;

  const _CategoryBadge({required this.category});

  Color get _badgeColor {
    switch (category) {
      case ScheduleCategory.worship:
        return AppColors.softCoral;
      case ScheduleCategory.event:
        return AppColors.warmTangerine;
      case ScheduleCategory.meeting:
        return AppColors.sageGreen;
    }
  }

  String get _badgeLabel {
    switch (category) {
      case ScheduleCategory.worship:
        return '예배';
      case ScheduleCategory.event:
        return '행사';
      case ScheduleCategory.meeting:
        return '모임';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        _badgeLabel,
        style: AppTextStyles.bodySmall.copyWith(
          color: _badgeColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _ScheduleInfo extends StatelessWidget {
  final ChurchSchedule schedule;

  const _ScheduleInfo({required this.schedule});

  String _formatDate(DateTime dt) {
    return DateFormat('M월 d일 (E)', 'ko_KR').format(dt);
  }

  String _formatTime(DateTime dt) {
    return DateFormat('HH:mm', 'ko_KR').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          schedule.title,
          style: AppTextStyles.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 13,
              color: AppColors.textGrey,
            ),
            const SizedBox(width: 4),
            Text(
              '${_formatDate(schedule.startAt)} ${_formatTime(schedule.startAt)}',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        if (schedule.location != null && schedule.location!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 13,
                color: AppColors.textGrey,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  schedule.location!,
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
