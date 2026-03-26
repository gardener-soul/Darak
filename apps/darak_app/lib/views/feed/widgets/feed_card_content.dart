import 'package:flutter/material.dart';

import '../../../models/feed/feed.dart';
import '../../../theme/app_theme.dart';

/// 피드 카드 본문 — 콘텐츠 유형 배지 + 텍스트 (3줄 미리보기 / 전체 보기)
class FeedCardContent extends StatefulWidget {
  final Feed feed;
  final bool expanded;

  const FeedCardContent({
    super.key,
    required this.feed,
    this.expanded = false,
  });

  @override
  State<FeedCardContent> createState() => _FeedCardContentState();
}

class _FeedCardContentState extends State<FeedCardContent> {
  bool _showFull = false;

  @override
  void initState() {
    super.initState();
    _showFull = widget.expanded;
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.feed.text ?? '';
    if (text.isEmpty) return const SizedBox.shrink();

    // firstChild/secondChild 공통 텍스트 스타일
    final textStyle = AppTextStyles.bodyMedium.copyWith(
      color: AppColors.textDark,
      height: 1.6,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          firstChild: Text(
            text,
            style: textStyle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(
            text,
            style: textStyle,
          ),
          crossFadeState:
              _showFull ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        if (!_showFull && _isLong(text))
          GestureDetector(
            onTap: () => setState(() => _showFull = true),
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '더 보기',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.softCoral,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  bool _isLong(String text) => text.length > 100 || text.contains('\n');
}

