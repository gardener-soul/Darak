import 'package:flutter/material.dart';

import '../../../models/feed/feed.dart';
import '../../../models/user.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/core/clay_avatar.dart';

/// 피드 카드 헤더 — 작성자 프로필 + 시간 + 더보기 메뉴
class FeedCardHeader extends StatelessWidget {
  final Feed feed;
  final User? author; // 작성자 정보 (null이면 로딩)
  final String currentUserId;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;

  const FeedCardHeader({
    super.key,
    required this.feed,
    required this.author,
    required this.currentUserId,
    this.onEdit,
    this.onDelete,
    this.onReport,
  });

  bool get _isOwner => feed.userId == currentUserId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClayAvatar(
          imageUrl: author?.profileImageUrl,
          size: AvatarSize.small,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                author?.name ?? '...',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                _relativeTime(feed.createdAt),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ),
        _MoreMenu(
          isOwner: _isOwner,
          onEdit: onEdit,
          onDelete: onDelete,
          onReport: onReport,
        ),
      ],
    );
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    return '${dt.month}월 ${dt.day}일';
  }
}

// ─── 더보기 메뉴 ──────────────────────────────────────────────────────────────

class _MoreMenu extends StatelessWidget {
  final bool isOwner;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;

  const _MoreMenu({
    required this.isOwner,
    this.onEdit,
    this.onDelete,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz_rounded, color: AppColors.textGrey, size: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (_) => [
        if (isOwner) ...[
          const PopupMenuItem(value: 'edit', child: Text('수정하기')),
          PopupMenuItem(
            value: 'delete',
            child: Text('삭제하기',
                style: TextStyle(color: Colors.red.shade400)),
          ),
        ] else
          const PopupMenuItem(value: 'report', child: Text('신고하기')),
      ],
      onSelected: (value) {
        if (value == 'edit') onEdit?.call();
        if (value == 'delete') onDelete?.call();
        if (value == 'report') onReport?.call();
      },
    );
  }
}
