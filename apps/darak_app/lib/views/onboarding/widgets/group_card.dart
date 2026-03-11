import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../models/group.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';

/// 그룹 선택 카드 위젯 (클레이모피즘)
/// 온보딩 화면에서 사용자가 가입할 그룹을 선택할 때 사용합니다.
class GroupCard extends StatelessWidget {
  final Group group;
  final bool isSelected;
  final VoidCallback onTap;

  const GroupCard({
    super.key,
    required this.group,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyTapWrapper(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: AppDecorations.cardRadius,
          border: isSelected
              ? Border.all(
                  color: AppColors.softCoral,
                  width: 3,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.softCoral.withValues(alpha: 0.3),
                    offset: const Offset(0, 8),
                    blurRadius: 16,
                  ),
                ]
              : AppDecorations.clayShadow,
        ),
        child: Row(
          children: [
            // 그룹 이미지
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.creamWhite,
                borderRadius: BorderRadius.circular(16),
                image: group.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(group.imageUrl ?? ''),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: group.imageUrl == null
                  ? const Icon(
                      Icons.people_rounded,
                      size: 32,
                      color: AppColors.textGrey,
                    )
                  : null,
            ),

            const SizedBox(width: 16),

            // 그룹 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (group.description?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 4),
                    Text(
                      group.description ?? '',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textGrey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 16,
                        color: AppColors.textGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${group.memberIds?.length ?? 0}명',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 선택 인디케이터
            if (isSelected)
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppColors.softCoral,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
