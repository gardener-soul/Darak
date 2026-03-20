import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/church_schedules_state.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/church/church_schedules_viewmodel.dart';
import '../widgets/schedule_card.dart';

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
                      ScheduleCard(schedule: state.schedules[i]),
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
        textStyle: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
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
