import 'package:flutter/material.dart';

import '../../../models/follow/follow.dart';
import '../../../models/user.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/core/clay_avatar.dart';

/// 팔로우 요청 목록에서 사용하는 수락/거절 버튼 포함 카드 위젯
class FollowRequestCard extends StatelessWidget {
  final Follow follow;

  /// 팔로우 요청자 User 정보 (null = 로딩 중)
  final User? requester;

  final VoidCallback onAccept;
  final VoidCallback onReject;

  const FollowRequestCard({
    super.key,
    required this.follow,
    required this.requester,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final name = requester?.name ?? '로딩 중...';
    final photoUrl = requester?.profileImageUrl;
    final groupName = requester?.groupName;

    return ClayCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // ─── 아바타 ────────────────────────────────────────────
          ClayAvatar(imageUrl: photoUrl, size: AvatarSize.small),
          const SizedBox(width: 12),

          // ─── 이름 + 다락방 ──────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (groupName != null && groupName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    groupName,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),

          // ─── 수락 / 거절 버튼 ───────────────────────────────────
          _AcceptRejectButtons(onAccept: onAccept, onReject: onReject),
        ],
      ),
    );
  }
}

class _AcceptRejectButtons extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _AcceptRejectButtons({
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BouncyButton(
          text: '수락',
          isFullWidth: false,
          color: AppColors.sageGreen,
          onPressed: onAccept,
        ),
        const SizedBox(width: 8),
        BouncyButton(
          text: '거절',
          isFullWidth: false,
          color: AppColors.softCoral,
          onPressed: onReject,
        ),
      ],
    );
  }
}
