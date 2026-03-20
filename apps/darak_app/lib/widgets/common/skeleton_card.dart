import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Shimmer 효과의 스켈레톤 로딩 위젯
///
/// [width], [height], [borderRadius]를 파라미터로 받아 범용적으로 사용합니다.
/// AnimatedContainer를 활용해 shimmer 효과를 구현합니다.
class SkeletonCard extends StatefulWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const SkeletonCard({
    super.key,
    this.width,
    this.height = 60,
    this.borderRadius = 16,
  });

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.divider.withValues(alpha: _animation.value),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}

/// 교인 목록용 스켈레톤 아이템 (아바타 + 텍스트 라인 2개)
class SkeletonMemberTile extends StatelessWidget {
  const SkeletonMemberTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const SkeletonCard(width: 48, height: 48, borderRadius: 100),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonCard(
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: 16,
                  borderRadius: 8,
                ),
                const SizedBox(height: 8),
                SkeletonCard(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: 12,
                  borderRadius: 6,
                ),
              ],
            ),
          ),
          const SkeletonCard(width: 48, height: 24, borderRadius: 12),
        ],
      ),
    );
  }
}

/// 공지사항 카드용 스켈레톤
class SkeletonAnnouncementCard extends StatelessWidget {
  const SkeletonAnnouncementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonCard(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 18,
            borderRadius: 8,
          ),
          const SizedBox(height: 8),
          SkeletonCard(
            width: double.infinity,
            height: 14,
            borderRadius: 6,
          ),
          const SizedBox(height: 4),
          SkeletonCard(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 14,
            borderRadius: 6,
          ),
        ],
      ),
    );
  }
}
