import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/church_schedule.dart';
import '../../../models/church_schedules_state.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/church/church_schedules_viewmodel.dart';
import '../../../widgets/common/clay_card.dart';

/// 교회 상세 - 일정 탭
/// 이번 주 / 이번 달 전환 + 일정 목록 표시
class ChurchScheduleTab extends ConsumerWidget {
  final String churchId;

  const ChurchScheduleTab({super.key, required this.churchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync =
        ref.watch(churchSchedulesViewModelProvider(churchId));

    return schedulesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.softCoral),
      ),
      error: (e, _) => Center(
        child: Text(
          '일정을 불러오지 못했어요.',
          style: AppTextStyles.bodySmall,
        ),
      ),
      data: (state) => _ScheduleBody(
        churchId: churchId,
        state: state,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _ScheduleBody extends ConsumerWidget {
  final String churchId;
  final ChurchSchedulesState state;

  const _ScheduleBody({required this.churchId, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // ─── 뷰 모드 전환 SegmentedButton ──────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: _ViewModeSelector(
            currentMode: state.viewMode,
            onModeChanged: (mode) {
              ref
                  .read(churchSchedulesViewModelProvider(churchId).notifier)
                  .toggleView(mode);
            },
          ),
        ),

        // ─── 일정 목록 ─────────────────────────────────────────────
        Expanded(
          child: state.schedules.isEmpty
              ? const _EmptyScheduleState()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: state.schedules.length,
                  itemBuilder: (ctx, i) =>
                      _ScheduleCard(schedule: state.schedules[i]),
                ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _ViewModeSelector extends StatelessWidget {
  final ScheduleViewMode currentMode;
  final void Function(ScheduleViewMode) onModeChanged;

  const _ViewModeSelector({
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ScheduleViewMode>(
      showSelectedIcon: false,
      style: SegmentedButton.styleFrom(
        backgroundColor: AppColors.pureWhite,
        foregroundColor: AppColors.textGrey,
        selectedForegroundColor: AppColors.softCoral,
        selectedBackgroundColor: AppColors.softCoral.withValues(alpha: 0.12),
        side: const BorderSide(color: AppColors.divider),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      segments: const [
        ButtonSegment(
          value: ScheduleViewMode.weekly,
          label: Text('이번 주'),
          icon: Icon(Icons.view_week_rounded, size: 16),
        ),
        ButtonSegment(
          value: ScheduleViewMode.monthly,
          label: Text('이번 달'),
          icon: Icon(Icons.calendar_month_rounded, size: 16),
        ),
      ],
      selected: {currentMode},
      onSelectionChanged: (selected) => onModeChanged(selected.first),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _ScheduleCard extends StatelessWidget {
  final ChurchSchedule schedule;

  const _ScheduleCard({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CategoryBadge(category: schedule.category),
          const SizedBox(width: 12),
          Expanded(child: _ScheduleInfo(schedule: schedule)),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final ScheduleCategory category;

  const _CategoryBadge({required this.category});

  Color get _badgeColor {
    switch (category) {
      case ScheduleCategory.worship:
        return AppColors.softCoral;
      case ScheduleCategory.event:
        return AppColors.warmTangerine;
      case ScheduleCategory.meeting:
        return AppColors.sageGreen;
    }
  }

  String get _badgeLabel {
    switch (category) {
      case ScheduleCategory.worship:
        return '예배';
      case ScheduleCategory.event:
        return '행사';
      case ScheduleCategory.meeting:
        return '모임';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _badgeColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        _badgeLabel,
        style: AppTextStyles.bodySmall.copyWith(
          color: _badgeColor,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ScheduleInfo extends StatelessWidget {
  final ChurchSchedule schedule;

  const _ScheduleInfo({required this.schedule});

  String _formatDate(DateTime dt) {
    return DateFormat('M월 d일 (E)', 'ko_KR').format(dt);
  }

  String _formatTime(DateTime dt) {
    return DateFormat('HH:mm', 'ko_KR').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          schedule.title,
          style: AppTextStyles.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 13,
              color: AppColors.textGrey,
            ),
            const SizedBox(width: 4),
            Text(
              '${_formatDate(schedule.startAt)} ${_formatTime(schedule.startAt)}',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        if (schedule.location != null && schedule.location!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 13,
                color: AppColors.textGrey,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  schedule.location!,
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _EmptyScheduleState extends StatelessWidget {
  const _EmptyScheduleState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.event_busy_rounded,
            size: 56,
            color: AppColors.textGrey,
          ),
          const SizedBox(height: 16),
          const Text(
            '등록된 일정이 없습니다',
            style: AppTextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '해당 기간에 예정된 일정이 없어요.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
