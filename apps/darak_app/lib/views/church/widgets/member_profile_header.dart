import 'package:flutter/material.dart';

import '../../../models/user.dart';
import '../../../models/user_role.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/core/clay_avatar.dart';
import '../../../widgets/common/role_badge.dart';

/// 순원 상세 화면 - 프로필 헤더 섹션
/// SliverAppBar의 FlexibleSpaceBar 내부에 배치됩니다.
class MemberProfileHeader extends StatelessWidget {
  final User user;

  const MemberProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.creamWhite, AppColors.pureWhite],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ClayAvatar(imageUrl: user.profileImageUrl, size: AvatarSize.large),
            const SizedBox(height: 12),
            Text(
              user.name,
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            RoleBadge(
              roleLevel: user.role.level,
              roleName: user.role.displayName,
            ),
            if (user.bio != null && user.bio!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  user.bio!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textGrey,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

}
