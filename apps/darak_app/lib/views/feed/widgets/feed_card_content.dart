import 'package:flutter/material.dart';

import '../../../models/feed/feed.dart';
import '../../../models/feed/feed_content_type.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ContentTypeBadge(contentType: widget.feed.contentType),
        const SizedBox(height: 6),
        AnimatedCrossFade(
          firstChild: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textDark,
              height: 1.6,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textDark,
              height: 1.6,
            ),
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

// ─── 콘텐츠 유형 배지 ─────────────────────────────────────────────────────────

class _ContentTypeBadge extends StatelessWidget {
  final FeedContentType contentType;

  const _ContentTypeBadge({required this.contentType});

  @override
  Widget build(BuildContext context) {
    if (contentType == FeedContentType.general) return const SizedBox.shrink();

    final (label, color) = switch (contentType) {
      FeedContentType.prayerShare => ('🙏 기도 공유', AppColors.softLavender),
      FeedContentType.testimony => ('✨ 간증', AppColors.warmTangerine),
      _ => ('', AppColors.divider),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
