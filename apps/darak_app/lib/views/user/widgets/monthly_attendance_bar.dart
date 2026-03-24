import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme.dart';
import '../../../viewmodels/user/spiritual_dashboard_viewmodel.dart';
import '../../../widgets/common/clay_card.dart';

/// 월간 출석 프로그레스 바 위젯 (MYPAGE_PLAN §7-4)
///
/// 이번 달 출석 현황을 프로그레스 바 형태로 표시합니다.
/// 100% 달성 시 체크 아이콘과 바운스 애니메이션이 표시됩니다.
class MonthlyAttendanceBar extends ConsumerWidget {
  final String userId;

  const MonthlyAttendanceBar({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(monthlyAttendanceProvider(userId));

    return statsAsync.when(
      loading: () => _buildSkeleton(),
      error: (err, st) => const SizedBox.shrink(),
      data: (stats) =>
          _MonthlyBarContent(attended: stats.attended, total: stats.total),
    );
  }

  Widget _buildSkeleton() {
    return ClayCard(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.divider.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _MonthlyBarContent extends StatefulWidget {
  final int attended;
  final int total;

  const _MonthlyBarContent({required this.attended, required this.total});

  @override
  State<_MonthlyBarContent> createState() => _MonthlyBarContentState();
}

class _MonthlyBarContentState extends State<_MonthlyBarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnim;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    final ratio = widget.total > 0 ? widget.attended / widget.total : 0.0;
    _widthAnim = Tween<double>(
      begin: 0,
      end: ratio.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // 100% 달성 시 바운스 애니메이션
    _bounceAnim =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 1.15, end: 0.92), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.0), weight: 1),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.8, 1.0, curve: Curves.easeInOut),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isComplete => widget.total > 0 && widget.attended >= widget.total;

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '이번 달 출석',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${widget.attended}회',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.sageGreen,
                    ),
                  ),
                  Text(' / ${widget.total}회', style: AppTextStyles.bodySmall),
                  if (_isComplete) ...[
                    const SizedBox(width: 6),
                    ScaleTransition(
                      scale: _bounceAnim,
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.sageGreen,
                        size: 18,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 프로그레스 바
          LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedBuilder(
                animation: _widthAnim,
                builder: (context, child) {
                  return Stack(
                    children: [
                      // 배경 트랙
                      Container(
                        height: 10,
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                          color: AppColors.divider.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      // 진행 바
                      Container(
                        height: 10,
                        width: constraints.maxWidth * _widthAnim.value,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.sageGreen,
                              AppColors.sageGreen.withValues(alpha: 0.75),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          if (widget.total == 0) ...[
            const SizedBox(height: 6),
            Text(
              '이번 달 출석 기록이 아직 없어요.',
              style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
