import 'package:flutter/material.dart';

import '../../../models/prayer.dart';
import '../../../models/prayer_status.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';

/// 피드 카드에 연결된 기도제목 축약 카드
class PrayerLinkCard extends StatelessWidget {
  final Prayer prayer;
  final VoidCallback? onTap;

  const PrayerLinkCard({
    super.key,
    required this.prayer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAnswered = prayer.status == PrayerStatus.answered;
    return BouncyTapWrapper(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isAnswered
              ? AppColors.sageGreen.withValues(alpha: 0.15)
              : AppColors.softLavender.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isAnswered
                ? AppColors.sageGreen.withValues(alpha: 0.5)
                : AppColors.softLavender.withValues(alpha: 0.6),
          ),
        ),
        child: Row(
          children: [
            Text(
              isAnswered ? '🙌' : '🙏',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                prayer.content,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isAnswered
                    ? AppColors.sageGreen.withValues(alpha: 0.3)
                    : AppColors.softCoral.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isAnswered ? '응답됨' : '기도 중',
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 10,
                  color: isAnswered
                      ? AppColors.sageGreen
                      : AppColors.softCoral,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
