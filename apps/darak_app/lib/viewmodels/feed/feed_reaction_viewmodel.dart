import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/feed/feed.dart';
import '../../models/feed/reaction_type.dart';
import '../../repositories/feed_repository.dart';

part 'feed_reaction_viewmodel.g.dart';

// ─── 반응 상태 관리 ────────────────────────────────────────────────────────────

/// 특정 피드의 반응을 낙관적 UI로 관리하는 Notifier
/// familyKey: feedId
@riverpod
class FeedReactionViewModel extends _$FeedReactionViewModel {
  @override
  // 초기 상태 없음 — 각 피드 카드가 Feed 모델의 reactions를 직접 사용
  void build(String feedId) {}

  /// 반응 토글 (낙관적 UI: 로컬 즉시 반영 → 서버 요청 → 실패 시 롤백)
  Future<void> toggleReaction({
    required Feed feed,
    required String userId,
    required ReactionType reactionType,
    required void Function(Feed) onLocalUpdate,
  }) async {
    final currentReaction = _getCurrentReaction(feed.reactions, userId);
    final optimisticFeed = _applyOptimisticReaction(
      feed: feed,
      userId: userId,
      reactionType: reactionType,
      currentReaction: currentReaction,
    );

    // 낙관적 UI: 즉시 반영
    onLocalUpdate(optimisticFeed);

    try {
      await ref.read(feedRepositoryProvider).toggleReaction(
            feedId: feed.id,
            userId: userId,
            reactionType: reactionType,
            currentReactionType: currentReaction,
          );
    } catch (e) {
      debugPrint('반응 토글 실패 — 롤백: $e');
      // 실패 시 원래 상태로 롤백
      onLocalUpdate(feed);
    }
  }

  // ─── 내부 헬퍼 ─────────────────────────────────────────────────────────────

  /// 현재 사용자의 반응 타입 조회 (없으면 null)
  ReactionType? _getCurrentReaction(
    Map<String, List<String>> reactions,
    String userId,
  ) {
    for (final entry in reactions.entries) {
      if (entry.value.contains(userId)) {
        return ReactionTypeX.fromJson(entry.key);
      }
    }
    return null;
  }

  /// 낙관적 반응 적용: 로컬 Feed 객체를 즉시 업데이트
  Feed _applyOptimisticReaction({
    required Feed feed,
    required String userId,
    required ReactionType reactionType,
    required ReactionType? currentReaction,
  }) {
    final reactions = Map<String, List<String>>.from(
      feed.reactions.map((k, v) => MapEntry(k, List<String>.from(v))),
    );

    // 기존 반응 제거
    if (currentReaction != null) {
      final oldKey = currentReaction.toJson();
      reactions[oldKey]?.remove(userId);
      if (reactions[oldKey]?.isEmpty ?? false) reactions.remove(oldKey);
    }

    // 같은 반응 재선택이면 취소 (제거만)
    if (currentReaction != reactionType) {
      final newKey = reactionType.toJson();
      reactions[newKey] = [...(reactions[newKey] ?? []), userId];
    }

    return feed.copyWith(reactions: reactions);
  }
}
