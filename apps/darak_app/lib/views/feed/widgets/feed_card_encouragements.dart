import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme.dart';
import '../../../viewmodels/feed/feed_encouragement_viewmodel.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';

/// 피드 카드 격려 메시지 입력 영역
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
    final vmState = ref.watch(
      feedEncouragementViewModelProvider(widget.feedId),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 격려 메시지 입력 행
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLength: 100,
                maxLines: 1,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textDark,
                ),
                decoration: InputDecoration(
                  hintText: '따뜻한 한 마디',
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textGrey,
                  ),
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
                    borderSide: BorderSide(
                      color: AppColors.softCoral,
                      width: 1.5,
                    ),
                  ),
                ),
                onChanged: (v) => ref
                    .read(
                      feedEncouragementViewModelProvider(
                        widget.feedId,
                      ).notifier,
                    )
                    .updateText(v),
              ),
            ),
            const SizedBox(width: 8),
            // 전송 버튼 — '>' 아이콘 (BouncyTapWrapper로 더블 탭 방어)
            BouncyTapWrapper(
              onTap: vmState.isLoading
                  ? null
                  : () async {
                      final success = await ref
                          .read(
                            feedEncouragementViewModelProvider(
                              widget.feedId,
                            ).notifier,
                          )
                          .submit(userId: widget.currentUserId);
                      if (success && mounted) {
                        _controller.clear();
                        _focusNode.unfocus();
                      }
                    },
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: vmState.isLoading
                      ? AppColors.divider
                      : AppColors.softCoral,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.pureWhite,
                  size: 22,
                ),
              ),
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
