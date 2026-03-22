import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/prayer.dart';
import '../../../models/prayer_status.dart';
import '../../../models/prayer_visibility.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import '../../../widgets/common/clay_card.dart';

/// 내 기도 탭용 기도 제목 카드
class PrayerCard extends StatelessWidget {
  final Prayer prayer;
  final VoidCallback onTap;

  const PrayerCard({
    super.key,
    required this.prayer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAnswered = prayer.status == PrayerStatus.answered;

    return BouncyTapWrapper(
      onTap: onTap,
      child: ClayCard(
        padding: EdgeInsets.zero,
        child: IntrinsicHeight(
          child: Row(
            children: [
              // 좌측 컬러 바 (응답됨: sageGreen, 진행중: softCoral)
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: isAnswered
                      ? AppColors.sageGreen
                      : AppColors.softCoral,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    bottomLeft: Radius.circular(32),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 상태 뱃지 + 공개 범위 아이콘
                      Row(
                        children: [
                          _StatusBadge(isAnswered: isAnswered),
                          const Spacer(),
                          _VisibilityIcon(visibility: prayer.visibility),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // 기도 제목
                      Text(
                        prayer.content,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textDark,
                          decoration: isAnswered
                              ? TextDecoration.none
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // 기간 표시
                      _PeriodLabel(prayer: prayer),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isAnswered;

  const _StatusBadge({required this.isAnswered});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAnswered
            ? AppColors.sageGreen.withValues(alpha: 0.2)
            : AppColors.softCoral.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isAnswered ? '응답됨' : '기도 중',
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 12,
          color: isAnswered ? AppColors.sageGreen : AppColors.softCoral,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _VisibilityIcon extends StatelessWidget {
  final PrayerVisibility visibility;

  const _VisibilityIcon({required this.visibility});

  @override
  Widget build(BuildContext context) {
    final isPrivate = visibility == PrayerVisibility.private;
    return Icon(
      isPrivate ? Icons.lock_rounded : Icons.group_rounded,
      size: 18,
      color: AppColors.textGrey,
    );
  }
}

class _PeriodLabel extends StatelessWidget {
  final Prayer prayer;

  const _PeriodLabel({required this.prayer});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MM.dd');
    final start = fmt.format(prayer.startDate);
    final end = prayer.endDate != null ? fmt.format(prayer.endDate!) : null;

    final label = end != null ? '$start ~ $end' : '$start ~';

    return Row(
      children: [
        const Icon(
          Icons.calendar_today_rounded,
          size: 14,
          color: AppColors.textGrey,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}
