import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/feed/feed.dart';
import '../../../models/feed/reaction_type.dart';
import '../../../repositories/user_repository.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/feed/feed_reaction_viewmodel.dart';
import '../../../viewmodels/feed/feed_timeline_viewmodel.dart';
import '../../../widgets/common/clay_card.dart';
import '../../church/member_detail_screen.dart';
import 'feed_card_content.dart';
import 'feed_card_encouragements.dart';
import 'feed_card_header.dart';
import 'feed_card_reactions.dart';

/// 피드 타임라인 카드 — 헤더/본문/반응/격려 영역 통합
class FeedCard extends ConsumerWidget {
  final Feed feed;
  final String currentUserId;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;

  const FeedCard({
    super.key,
    required this.feed,
    required this.currentUserId,
    this.onEdit,
    this.onDelete,
    this.onReport,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 작성자 정보를 userByIdProvider로 조회 (캐시됨)
    final authorAsync = ref.watch(userByIdProvider(feed.userId));
    final author = authorAsync.valueOrNull;

    return ClayCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
              // 본인 피드가 아닌 경우 작성자 프로필 화면으로 이동
              onAuthorTap: feed.userId != currentUserId
                  ? () => Navigator.of(context).push(
                        MemberDetailScreen.route(feed.userId),
                      )
                  : null,
            ),
            const SizedBox(height: 12),

            // 본문
            FeedCardContent(feed: feed),
            const SizedBox(height: 12),

            // 구분선
            Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: 10),

            // 반응 영역
            FeedCardReactions(
              feed: feed,
              currentUserId: currentUserId,
              onReactionTap: (type) => _handleReaction(ref, type),
            ),
            const SizedBox(height: 10),

            // 격려 메시지 영역
            FeedCardEncouragements(
              feedId: feed.id,
              encouragementCount: feed.encouragementCount,
              currentUserId: currentUserId,
            ),
          ],
        ),
      ),
    );
  }

  void _handleReaction(WidgetRef ref, ReactionType type) {
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
  }
}
