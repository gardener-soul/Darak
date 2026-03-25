import 'package:flutter/material.dart';

import '../../../models/follow/follow_status.dart';
import '../../../models/user.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/core/clay_avatar.dart';

/// 팔로우 검색 결과 / 목록에서 공통으로 사용하는 사용자 카드 위젯
class FollowUserCard extends StatelessWidget {
  final User user;

  /// null = 팔로우 관계 없음
  final FollowStatus? followStatus;

  /// 팔로우 요청 버튼 탭 콜백 (null이면 버튼 미표시)
  final VoidCallback? onFollowTap;

  /// 팔로우 취소 버튼 탭 콜백 (null이면 버튼 미표시)
  final VoidCallback? onCancelTap;

  const FollowUserCard({
    super.key,
    required this.user,
    this.followStatus,
    this.onFollowTap,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // ─── 아바타 ────────────────────────────────────────────
          ClayAvatar(imageUrl: user.profileImageUrl, size: AvatarSize.small),
          const SizedBox(width: 12),

          // ─── 이름 + 다락방 ──────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (user.groupName != null && user.groupName!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    user.groupName!,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),

          // ─── 팔로우 상태 버튼 ───────────────────────────────────
          _FollowStatusButton(
            followStatus: followStatus,
            onFollowTap: onFollowTap,
            onCancelTap: onCancelTap,
          ),
        ],
      ),
    );
  }
}

/// 팔로우 상태에 따른 버튼 위젯
class _FollowStatusButton extends StatelessWidget {
  final FollowStatus? followStatus;
  final VoidCallback? onFollowTap;
  final VoidCallback? onCancelTap;

  const _FollowStatusButton({
    required this.followStatus,
    this.onFollowTap,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    switch (followStatus) {
      case null:
        // 팔로우 관계 없음 → 팔로우 요청 버튼
        return BouncyButton(
          text: '팔로우',
          isFullWidth: false,
          onPressed: onFollowTap,
        );

      case FollowStatus.pending:
        // 요청 보낸 상태 → 비활성 버튼
        return BouncyButton(
          text: '요청됨',
          isFullWidth: false,
          color: AppColors.disabled,
          onPressed: null,
        );

      case FollowStatus.accepted:
        // 팔로잉 중 → 취소 버튼
        return BouncyButton(
          text: '팔로잉',
          isFullWidth: false,
          color: AppColors.sageGreen,
          onPressed: onCancelTap,
        );

      case FollowStatus.rejected:
        // 거절됨 → 다시 요청 가능
        return BouncyButton(
          text: '팔로우',
          isFullWidth: false,
          onPressed: onFollowTap,
        );
    }
  }
}
