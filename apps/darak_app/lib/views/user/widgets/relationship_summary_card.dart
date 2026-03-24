import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/bouncy_button.dart';

class RelationshipSummaryCard extends StatelessWidget {
  final int followingCount;
  final int followerCount;
  final int clubCount;
  final VoidCallback? onFollowingTap;
  final VoidCallback? onFollowerTap;
  final VoidCallback? onClubTap;
  final VoidCallback? onFindMembers;

  const RelationshipSummaryCard({
    super.key,
    required this.followingCount,
    required this.followerCount,
    required this.clubCount,
    this.onFollowingTap,
    this.onFollowerTap,
    this.onClubTap,
    this.onFindMembers,
  });

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('나의 관계', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          if (followingCount == 0 && followerCount == 0 && clubCount == 0)
            _buildEmptyState()
          else
            Row(
              children: [
                Expanded(
                  child: _RelationStat(
                    label: '팔로잉',
                    count: followingCount,
                    onTap: onFollowingTap,
                  ),
                ),
                Container(
                  height: 24,
                  width: 1,
                  color: AppColors.divider.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: _RelationStat(
                    label: '팔로워',
                    count: followerCount,
                    onTap: onFollowerTap,
                  ),
                ),
                Container(
                  height: 24,
                  width: 1,
                  color: AppColors.divider.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: _RelationStat(
                    label: '동아리',
                    count: clubCount,
                    onTap: onClubTap,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        Text(
          '교인을 찾아 팔로우해보세요',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
        ),
        const SizedBox(height: 12),
        BouncyButton(
          onPressed: onFindMembers,
          text: '교인 찾기',
          color: AppColors.softCoral,
        ),
      ],
    );
  }
}

class _RelationStat extends StatelessWidget {
  final String label;
  final int count;
  final VoidCallback? onTap;

  const _RelationStat({required this.label, required this.count, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$count',
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
