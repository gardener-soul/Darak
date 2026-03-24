import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme.dart';
import '../../../viewmodels/user/spiritual_dashboard_viewmodel.dart';
import '../../../widgets/common/clay_card.dart';

/// 영적 여정 요약 2x2 카드 (MYPAGE_PLAN §7-2)
///
/// 연속 출석 / 이번 달 출석률 / 기도 응답 / 소속 다락방을
/// 2x2 그리드 레이아웃으로 표시합니다.
/// Phase 2: 숫자 셀에 카운트업 애니메이션 적용
class SpiritualDashboardCard extends ConsumerWidget {
  final String userId;
  final String? groupId;

  const SpiritualDashboardCard({super.key, required this.userId, this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(
      spiritualDashboardProvider((userId: userId, groupId: groupId)),
    );

    return dashboardAsync.when(
      loading: () => const _DashboardSkeleton(),
      error: (err, st) => const _DashboardError(),
      data: (data) => _DashboardGrid(data: data),
    );
  }
}

// ─── 데이터 그리드 ─────────────────────────────────────────────────────────

class _DashboardGrid extends StatelessWidget {
  final SpiritualDashboardData data;

  const _DashboardGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    final streakIsHigh = data.consecutiveWeeks >= 7;

    return Column(
      children: [
        // 상단 행: 연속출석 | 이달출석률
        Row(
          children: [
            Expanded(
              child: _DashboardCell(
                icon: Icons.local_fire_department_rounded,
                iconColor: streakIsHigh
                    ? AppColors.warmTangerine
                    : AppColors.textGrey,
                glowColor: streakIsHigh ? AppColors.warmTangerine : null,
                // 0이면 텍스트 그대로, 아니면 카운트업 후 "N주 연속" 표시
                animatedValue:
                    data.consecutiveWeeks > 0 ? data.consecutiveWeeks : null,
                valueSuffix: '주 연속',
                fallbackValue: '아직 시작 전이에요!',
                label: '연속 출석',
                isSmall: data.consecutiveWeeks == 0,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DashboardCell(
                icon: Icons.check_circle_rounded,
                iconColor: AppColors.sageGreen,
                animatedValue: data.monthlyRatePercent,
                valueSuffix: '%',
                label: '이달 출석률',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 하단 행: 기도응답 | 소속 다락방
        Row(
          children: [
            Expanded(
              child: _DashboardCell(
                icon: Icons.favorite_rounded,
                iconColor: AppColors.softCoral,
                animatedValue: data.answeredPrayerCount,
                valueSuffix: '건',
                label: '기도 응답',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DashboardCell(
                icon: Icons.people_rounded,
                iconColor: AppColors.softLavender,
                // 다락방 이름은 텍스트형 — 카운트업 없음
                animatedValue: null,
                fallbackValue: data.groupName ?? '--',
                label: '소속 다락방',
                isSmall: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── 개별 셀 (카운트업 애니메이션 포함) ────────────────────────────────────

class _DashboardCell extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color? glowColor;

  /// 카운트업 애니메이션 대상 정수값. null이면 [fallbackValue]를 그대로 표시
  final int? animatedValue;

  /// 카운트업 후 숫자 뒤에 붙을 접미사 (예: "주 연속", "%", "건")
  final String valueSuffix;

  /// [animatedValue]가 null일 때 표시할 텍스트
  final String fallbackValue;

  final String label;
  final bool isSmall;

  const _DashboardCell({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.glowColor,
    this.animatedValue,
    this.valueSuffix = '',
    this.fallbackValue = '--',
    this.isSmall = false,
  });

  @override
  State<_DashboardCell> createState() => _DashboardCellState();
}

class _DashboardCellState extends State<_DashboardCell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _countAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _startAnimation();
  }

  @override
  void didUpdateWidget(_DashboardCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 값이 바뀌면 애니메이션 재실행
    if (oldWidget.animatedValue != widget.animatedValue) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    if (widget.animatedValue == null) return;
    _countAnimation = Tween<double>(
      begin: 0,
      end: widget.animatedValue!.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 아이콘 배지
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              boxShadow: widget.glowColor != null
                  ? [
                      BoxShadow(
                        color: widget.glowColor!.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(widget.icon, color: widget.iconColor, size: 22),
          ),
          const SizedBox(height: 10),
          // 값 (숫자형이면 카운트업, 텍스트형이면 그대로)
          widget.animatedValue != null
              ? AnimatedBuilder(
                  animation: _countAnimation,
                  builder: (context, _) {
                    final current = _countAnimation.value.round();
                    return Text(
                      '$current${widget.valueSuffix}',
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                )
              : Text(
                  widget.fallbackValue,
                  style: widget.isSmall
                      ? AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        )
                      : AppTextStyles.headlineMedium.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          const SizedBox(height: 4),
          // 라벨
          Text(
            widget.label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11,
              color: AppColors.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── 스켈레톤 로딩 ─────────────────────────────────────────────────────────

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _SkeletonCell()),
            const SizedBox(width: 12),
            Expanded(child: _SkeletonCell()),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _SkeletonCell()),
            const SizedBox(width: 12),
            Expanded(child: _SkeletonCell()),
          ],
        ),
      ],
    );
  }
}

class _SkeletonCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClayCard(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.divider.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 60,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.divider.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 40,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.divider.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 에러 상태 ─────────────────────────────────────────────────────────────

class _DashboardError extends StatelessWidget {
  const _DashboardError();

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Text('데이터를 불러오지 못했어요.', style: AppTextStyles.bodySmall),
      ),
    );
  }
}
