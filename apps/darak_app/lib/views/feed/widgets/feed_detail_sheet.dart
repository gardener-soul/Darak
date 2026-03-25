import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/feed/feed.dart';
import '../../../theme/app_theme.dart';
import '../../../repositories/user_repository.dart';
import '../../../viewmodels/feed/feed_reaction_viewmodel.dart';
import '../../../viewmodels/feed/feed_timeline_viewmodel.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';
import 'feed_card_content.dart';
import 'feed_card_encouragements.dart';
import 'feed_card_header.dart';
import 'feed_card_reactions.dart';

/// 게시물 상세 바텀시트 — 전체 본문 + 전체 격려 메시지 목록
class FeedDetailSheet extends ConsumerWidget {
  final Feed feed;
  final String currentUserId;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;

  const FeedDetailSheet({
    super.key,
    required this.feed,
    required this.currentUserId,
    this.onEdit,
    this.onDelete,
    this.onReport,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final author = ref.watch(userByIdProvider(feed.userId)).valueOrNull;

    return AppBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          FeedCardHeader(
            feed: feed,
            author: author,
            currentUserId: currentUserId,
            onEdit: onEdit,
            onDelete: onDelete,
            onReport: onReport,
          ),
          const SizedBox(height: 12),

          // 전체 본문 (expanded: true)
          FeedCardContent(feed: feed, expanded: true),
          const SizedBox(height: 12),

          Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 10),

          // 반응 영역
          FeedCardReactions(
            feed: feed,
            currentUserId: currentUserId,
            onReactionTap: (type) {
              ref
                  .read(feedReactionViewModelProvider(feed.id).notifier)
                  .toggleReaction(
                    feed: feed,
                    userId: currentUserId,
                    reactionType: type,
                    onLocalUpdate: (updated) => ref
                        .read(feedTimelineViewModelProvider.notifier)
                        .updateLocalFeed(updated),
                  );
            },
          ),
          const SizedBox(height: 12),

          // 격려 메시지 전체 목록
          FeedCardEncouragements(
            feedId: feed.id,
            encouragementCount: feed.encouragementCount,
            currentUserId: currentUserId,
          ),
        ],
      ),
    );
  }
}
