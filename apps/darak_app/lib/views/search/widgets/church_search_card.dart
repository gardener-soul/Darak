import 'package:flutter/material.dart';

import '../../../models/church.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/core/clay_avatar.dart';

/// 검색 탭의 교회 목록 카드 위젯 (ClayCard 기반)
///
/// 교회 로고/이름/교단/담임목사/주소/교인 수를 표시합니다.
class ChurchSearchCard extends StatelessWidget {
  final Church church;
  final VoidCallback? onTap;

  const ChurchSearchCard({
    super.key,
    required this.church,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClayCard(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── 교회 아이콘/이미지 ───────────────────────────────
            ClayAvatar(
              imageUrl: church.imageUrl,
              size: AvatarSize.small,
              backgroundColor: AppColors.softCoral.withValues(alpha: 0.2),
              fallbackIcon: const Icon(
                Icons.church_rounded,
                color: AppColors.softCoral,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            // ─── 교회 정보 ─────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 교회 이름
                  Text(
                    church.name,
                    style: AppTextStyles.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // 교단 · 담임목사
                  Text(
                    '${church.denomination} · ${church.seniorPastor} 목사',
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // 주소
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
                          church.address,
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // 교인 수
                  Row(
                    children: [
                      const Icon(
                        Icons.people_rounded,
                        size: 13,
                        color: AppColors.textGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${church.memberCount}명의 교인',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ─── 화살표 아이콘 ─────────────────────────────────────
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textGrey,
            ),
          ],
        ),
      ),
    );
  }
}
