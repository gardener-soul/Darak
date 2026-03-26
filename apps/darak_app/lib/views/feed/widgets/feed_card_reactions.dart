import 'package:flutter/material.dart';

import '../../../models/feed/feed.dart';
import '../../../models/feed/reaction_type.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import 'reaction_picker.dart';

/// 피드 카드 반응 영역 — 반응 유형별 카운트 버튼 + 반응 선택 팝오버
class FeedCardReactions extends StatefulWidget {
  final Feed feed;
  final String currentUserId;
  final void Function(ReactionType) onReactionTap;

  const FeedCardReactions({
    super.key,
    required this.feed,
    required this.currentUserId,
    required this.onReactionTap,
  });

  @override
  State<FeedCardReactions> createState() => _FeedCardReactionsState();
}

class _FeedCardReactionsState extends State<FeedCardReactions> {
  bool _showPicker = false;

  ReactionType? get _myReaction {
    for (final entry in widget.feed.reactions.entries) {
      if (entry.value.contains(widget.currentUserId)) {
        return ReactionTypeX.fromJson(entry.key);
      }
    }
    return null;
  }

  // 반응 있는 타입만 필터링
  List<MapEntry<ReactionType, int>> get _reactionCounts {
    return ReactionType.values
        .map((type) {
          final count = widget.feed.reactions[type.toJson()]?.length ?? 0;
          return MapEntry(type, count);
        })
        .where((e) => e.value > 0)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 반응 선택 팝오버 (가로 스크롤로 overflow 방지)
        if (_showPicker) ...[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ReactionPicker(
              currentReaction: _myReaction,
              onSelect: (type) {
                setState(() => _showPicker = false);
                widget.onReactionTap(type);
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
        // 반응 버튼 행
        Row(
          children: [
            // 반응 추가 버튼
            BouncyTapWrapper(
              onTap: () => setState(() => _showPicker = !_showPicker),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _showPicker
                      ? AppColors.softLavender.withValues(alpha: 0.3)
                      : AppColors.creamWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_reaction_outlined,
                      size: 16,
                      color: _myReaction != null
                          ? AppColors.softCoral
                          : AppColors.textGrey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '반응',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _myReaction != null
                            ? AppColors.softCoral
                            : AppColors.textGrey,
                        fontWeight: _myReaction != null
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 반응 현황 칩들
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _reactionCounts.map((entry) {
                    final isMyType = entry.key == _myReaction;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: BouncyTapWrapper(
                        onTap: () => widget.onReactionTap(entry.key),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isMyType
                                ? AppColors.softCoral.withValues(alpha: 0.15)
                                : AppColors.creamWhite,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isMyType
                                  ? AppColors.softCoral.withValues(alpha: 0.5)
                                  : AppColors.divider,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                entry.key.emoji,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${entry.key.label} ${entry.value}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isMyType
                                      ? AppColors.softCoral
                                      : AppColors.textGrey,
                                  fontWeight: isMyType
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
