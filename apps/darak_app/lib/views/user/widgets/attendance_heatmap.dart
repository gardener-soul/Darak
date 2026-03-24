import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/attendance_type.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/user/attendance_heatmap_viewmodel.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/core/soft_dialog.dart';

/// 출석 히트맵 (잔디심기) 위젯 (MYPAGE_PLAN §7-3)
///
/// 최근 12주(84일)의 출석 기록을 7행 x 12열 격자로 표시합니다.
/// Phase 2: 뱃지 시스템 + 히트맵 진입 staggered 애니메이션 추가
class AttendanceHeatmap extends ConsumerStatefulWidget {
  final String userId;

  /// 연속 출석 주수 — spiritualDashboardProvider에서 전달 (뱃지 계산에 사용)
  /// 로딩 중이거나 데이터 없을 때는 0으로 fallback
  final int consecutiveWeeks;

  const AttendanceHeatmap({
    super.key,
    required this.userId,
    this.consecutiveWeeks = 0,
  });

  @override
  ConsumerState<AttendanceHeatmap> createState() => _AttendanceHeatmapState();
}

class _AttendanceHeatmapState extends ConsumerState<AttendanceHeatmap>
    with SingleTickerProviderStateMixin {
  /// 현재 툴팁이 표시된 셀 인덱스
  int? _tooltipIndex;

  /// 히트맵 셀 staggered 진입 애니메이션 컨트롤러
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    // 전체 애니메이션 시간: 열 딜레이(0.06 * 12) + 페이드 시간 = 약 1.5초
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heatmapAsync = ref.watch(attendanceHeatmapProvider(widget.userId));

    return GestureDetector(
      // 기획서 §4-2: 툴팁 외부 탭 시 닫힘 처리
      onTap: () {
        if (_tooltipIndex != null) {
          setState(() => _tooltipIndex = null);
        }
      },
      behavior: HitTestBehavior.translucent,
      child: ClayCard(
        padding: const EdgeInsets.all(16),
        child: heatmapAsync.when(
          loading: () => _buildSkeleton(),
          error: (err, st) => _buildError(),
          data: (cells) {
            // 데이터 로드 완료 시 진입 애니메이션 시작
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_animController.isAnimating && _animController.value == 0.0) {
                _animController.forward();
              }
            });
            return _buildHeatmap(cells);
          },
        ),
      ),
    );
  }

  Widget _buildHeatmap(List<HeatmapDayData> cells) {
    if (cells.every((c) => !c.hasAttendance)) {
      return _buildEmptyState();
    }

    // 뱃지 계산 (클라이언트 순수 계산)
    final badges = calculateBadges(
      cells: cells,
      consecutiveWeeks: widget.consecutiveWeeks,
    );

    // 84개 셀을 12열 x 7행으로 재구성
    // cells[0]이 가장 오래된 날, cells[83]이 오늘
    const int cols = 12;
    const int rows = 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phase 2: 뱃지 가로 스크롤 행 (히트맵 상단)
        _buildBadgeRow(badges),
        const SizedBox(height: 12),
        // 헤더: 월 레이블
        _buildMonthLabels(cells),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 좌측 요일 레이블
            _buildWeekdayLabels(),
            const SizedBox(width: 4),
            // 히트맵 그리드 (가로 스크롤)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: List.generate(rows, (row) {
                    return Row(
                      children: List.generate(cols, (col) {
                        final index = col * rows + row;
                        if (index >= cells.length) {
                          return _buildEmptyCell();
                        }
                        return _buildAnimatedCell(cells[index], index, col);
                      }),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // 하단 범례
        _buildLegend(),
        // 툴팁
        if (_tooltipIndex != null && _tooltipIndex! < cells.length)
          _buildTooltip(cells[_tooltipIndex!]),
      ],
    );
  }

  // ─── 뱃지 가로 스크롤 행 ─────────────────────────────────────

  Widget _buildBadgeRow(List<AttendanceBadge> badges) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: badges.map((badge) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _BadgeChip(
              badge: badge,
              onTap: () => _showBadgeDialog(badge),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// 뱃지 탭 시 SoftDialog로 달성 조건 표시
  void _showBadgeDialog(AttendanceBadge badge) {
    SoftDialog.show<void>(
      context: context,
      title: badge.name,
      content: badge.isEarned
          ? '달성! ${badge.condition}'
          : '미달성 · ${badge.condition}',
      actions: [
        SoftDialogAction(
          label: '확인',
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  // ─── 히트맵 셀 (staggered 진입 애니메이션 적용) ────────────────

  /// 열 인덱스 기반 staggered fade-in 애니메이션 셀
  Widget _buildAnimatedCell(HeatmapDayData day, int index, int colIndex) {
    // 열 순서대로 딜레이: 0열은 즉시, 11열은 0.66초 후 시작
    final start = (colIndex * 0.06).clamp(0.0, 0.8);
    final end = (start + 0.2).clamp(0.2, 1.0);

    final animation = CurvedAnimation(
      parent: _animController,
      curve: Interval(start, end, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: animation,
      child: _buildCell(day, index),
    );
  }

  Widget _buildCell(HeatmapDayData day, int index) {
    final color = _cellColor(day.attendedCount);
    return GestureDetector(
      onTap: () {
        setState(() {
          _tooltipIndex = _tooltipIndex == index ? null : index;
        });
      },
      child: Container(
        width: 22,
        height: 22,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: _tooltipIndex == index
              ? Border.all(color: AppColors.sageGreen, width: 1.5)
              : null,
        ),
      ),
    );
  }

  Widget _buildEmptyCell() {
    return Container(width: 22, height: 22, margin: const EdgeInsets.all(2));
  }

  Color _cellColor(int count) {
    if (count == 0) return AppColors.divider.withValues(alpha: 0.3);
    if (count == 1) return AppColors.sageGreen.withValues(alpha: 0.3);
    if (count == 2) return AppColors.sageGreen.withValues(alpha: 0.6);
    return AppColors.sageGreen;
  }

  Widget _buildWeekdayLabels() {
    const labels = ['일', '월', '화', '수', '목', '금', '토'];
    return Column(
      children: labels.map((d) {
        return SizedBox(
          height: 26,
          width: 18,
          child: Text(
            d,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 9,
              color: AppColors.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMonthLabels(List<HeatmapDayData> cells) {
    final labels = <Widget>[];
    String? lastMonth;
    // 각 열(7개 간격)의 첫째 날 날짜 기준으로 월 레이블 표시
    for (var col = 0; col < 12; col++) {
      final index = col * 7;
      if (index < cells.length) {
        final month = DateFormat('M월').format(cells[index].date);
        if (month != lastMonth) {
          labels.add(
            SizedBox(
              width: 26,
              child: Text(
                month,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 9,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          );
          lastMonth = month;
        } else {
          labels.add(const SizedBox(width: 26));
        }
      }
    }
    return Padding(
      padding: const EdgeInsets.only(left: 22),
      child: Row(children: labels),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('적음', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
        const SizedBox(width: 4),
        _legendCell(0),
        _legendCell(1),
        _legendCell(2),
        _legendCell(3),
        const SizedBox(width: 4),
        Text('많음', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
      ],
    );
  }

  Widget _legendCell(int count) {
    return Container(
      width: 14,
      height: 14,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: _cellColor(count),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildTooltip(HeatmapDayData day) {
    final fmt = DateFormat('M월 d일 (E)', 'ko');
    final typeLabels = day.attendances.map((a) => a.type.label).toList();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.textDark.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fmt.format(day.date),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.pureWhite,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (typeLabels.isEmpty)
            Text(
              '출석 기록 없음',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.pureWhite.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            )
          else
            ...typeLabels.map(
              (label) => Text(
                '· $label: 출석',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.pureWhite.withValues(alpha: 0.9),
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        _buildEmptyGrid(),
        const SizedBox(height: 12),
        Text(
          '출석 기록이 쌓이면 여기에 표시돼요',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmptyGrid() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: List.generate(7, (row) {
          return Row(
            children: List.generate(12, (col) {
              return Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: AppColors.divider.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        color: AppColors.sageGreen,
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        '출석 기록을 불러오지 못했어요.',
        style: AppTextStyles.bodySmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ─── 뱃지 칩 위젯 ────────────────────────────────────────────

/// 출석 뱃지 하나를 표시하는 칩 위젯
///
/// 획득 뱃지: 컬러 아이콘 + 뱃지명 (파스텔 배경)
/// 미획득 뱃지: 회색 자물쇠 아이콘 + 뱃지명 (비활성 스타일)
class _BadgeChip extends StatelessWidget {
  final AttendanceBadge badge;
  final VoidCallback onTap;

  const _BadgeChip({required this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final effectiveColor = badge.isEarned ? badge.color : AppColors.textGrey;
    final bgColor = badge.isEarned
        ? badge.color.withValues(alpha: 0.15)
        : AppColors.divider.withValues(alpha: 0.3);
    final borderColor = badge.isEarned
        ? badge.color.withValues(alpha: 0.4)
        : AppColors.divider;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              badge.isEarned ? badge.icon : Icons.lock_rounded,
              color: effectiveColor,
              size: 15,
            ),
            const SizedBox(width: 5),
            Text(
              badge.name,
              style: AppTextStyles.bodySmall.copyWith(
                color: effectiveColor,
                fontWeight:
                    badge.isEarned ? FontWeight.w700 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
