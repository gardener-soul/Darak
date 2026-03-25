import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/prayer.dart';
import '../../../models/prayer_visibility.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/core/soft_chip.dart';

/// 공동체 기도 탭용 카드 — 작성자 정보 + 출처 라벨 포함
class CommunityPrayerCard extends StatelessWidget {
  final Prayer prayer;
  final String authorName;
  final String? authorImageUrl;

  const CommunityPrayerCard({
    super.key,
    required this.prayer,
    required this.authorName,
    this.authorImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyTapWrapper(
      onTap: () {}, // 공동체 기도는 상세 없음 (v1)
      child: ClayCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 작성자 정보 + 출처 라벨
            Row(
              children: [
                Expanded(
                  child: _AuthorRow(
                    name: authorName,
                    imageUrl: authorImageUrl,
                  ),
                ),
                const SizedBox(width: 8),
                // 출처 라벨: 다락방 / 팔로잉
                SoftChip(
                  label: prayer.visibility == PrayerVisibility.followers
                      ? '팔로잉'
                      : '다락방',
                  color: prayer.visibility == PrayerVisibility.followers
                      ? AppColors.softLavender
                      : AppColors.sageGreen,
                  isSelected: true,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 기도 제목
            Text(
              prayer.content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textDark,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // 기간
            _PeriodRow(prayer: prayer),
          ],
        ),
      ),
    );
  }
}

class _AuthorRow extends StatelessWidget {
  final String name;
  final String? imageUrl;

  const _AuthorRow({required this.name, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.softCoral.withValues(alpha: 0.2),
          backgroundImage:
              imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl == null
              ? Text(
                  name.isNotEmpty ? name[0] : '?',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.softCoral,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 10),
        Text(
          name,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.volunteer_activism_rounded,
          size: 18,
          color: AppColors.softCoral,
        ),
      ],
    );
  }
}

class _PeriodRow extends StatelessWidget {
  final Prayer prayer;

  const _PeriodRow({required this.prayer});

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
          size: 13,
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
