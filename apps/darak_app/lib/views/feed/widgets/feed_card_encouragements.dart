import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/feed/encouragement.dart';
import '../../../repositories/user_repository.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/feed/feed_encouragement_viewmodel.dart';
import '../../../widgets/common/core/soft_chip.dart';

/// 피드 카드 격려 메시지 영역 — 최근 2개 미리보기 + 입력 필드
class FeedCardEncouragements extends ConsumerStatefulWidget {
  final String feedId;
  final int encouragementCount;
  final String currentUserId;

  const FeedCardEncouragements({
    super.key,
    required this.feedId,
    required this.encouragementCount,
    required this.currentUserId,
  });

  @override
  ConsumerState<FeedCardEncouragements> createState() =>
      _FeedCardEncouragementsState();
}

class _FeedCardEncouragementsState
    extends ConsumerState<FeedCardEncouragements> {
  bool _expanded = false;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final encAsync = ref.watch(feedEncouragementsProvider(widget.feedId));
    final vmState =
        ref.watch(feedEncouragementViewModelProvider(widget.feedId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 격려 메시지 수 / 접기 버튼
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              Icon(
                Icons.favorite_border_rounded,
                size: 16,
                color: AppColors.softCoral,
              ),
              const SizedBox(width: 4),
              Text(
                widget.encouragementCount > 0
                    ? '격려 ${widget.encouragementCount}개'
                    : '격려하기',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.softCoral,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.encouragementCount > 0) ...[
                const SizedBox(width: 4),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: AppColors.textGrey,
                ),
              ],
            ],
          ),
        ),

        // 격려 메시지 목록 (확장 시)
        if (_expanded) ...[
          const SizedBox(height: 8),
          encAsync.when(
            loading: () => const SizedBox(
              height: 24,
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            error: (_, _) => const SizedBox.shrink(),
            data: (encs) {
              if (encs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '아직 격려 메시지가 없어요.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                );
              }
              return Column(
                children: encs
                    .map((enc) => _EncouragementItem(
                          encouragement: enc,
                          currentUserId: widget.currentUserId,
                          onDelete: () => ref
                              .read(feedEncouragementViewModelProvider(
                                      widget.feedId)
                                  .notifier)
                              .delete(encouragementId: enc.id),
                        ))
                    .toList(),
              );
            },
          ),
        ],

        // 격려 메시지 입력 필드
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLength: 100,
                maxLines: 1,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textDark),
                decoration: InputDecoration(
                  hintText: '따뜻한 한 마디를 남겨보세요',
                  hintStyle: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textGrey),
                  counterText: '',
                  filled: true,
                  fillColor: AppColors.creamWhite,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        BorderSide(color: AppColors.softCoral, width: 1.5),
                  ),
                ),
                onChanged: (v) => ref
                    .read(feedEncouragementViewModelProvider(widget.feedId)
                        .notifier)
                    .updateText(v),
              ),
            ),
            const SizedBox(width: 8),
            SoftChip(
              label: '보내기',
              onTap: vmState.isLoading
                  ? null
                  : () async {
                      final success = await ref
                          .read(feedEncouragementViewModelProvider(
                                  widget.feedId)
                              .notifier)
                          .submit(userId: widget.currentUserId);
                      if (success) {
                        _controller.clear();
                        _focusNode.unfocus();
                        if (mounted) {
                          setState(() => _expanded = true);
                        }
                      }
                    },
              isSelected: false,
            ),
          ],
        ),

        // 오류 메시지
        if (vmState.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              vmState.errorMessage!,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.red.shade400,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── 격려 메시지 아이템 ────────────────────────────────────────────────────────

class _EncouragementItem extends ConsumerWidget {
  final Encouragement encouragement;
  final String currentUserId;
  final VoidCallback? onDelete;

  const _EncouragementItem({
    required this.encouragement,
    required this.currentUserId,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final author = ref.watch(userByIdProvider(encouragement.userId)).valueOrNull;
    final isOwner = encouragement.userId == currentUserId;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            author?.name ?? '...',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              encouragement.text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textDark,
              ),
            ),
          ),
          if (isOwner)
            GestureDetector(
              onTap: onDelete,
              child: Icon(
                Icons.close_rounded,
                size: 14,
                color: AppColors.textGrey,
              ),
            ),
        ],
      ),
    );
  }
}
