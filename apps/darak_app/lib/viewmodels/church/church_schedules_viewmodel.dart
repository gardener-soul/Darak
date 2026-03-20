import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/church_schedules_state.dart';
import '../../repositories/church_schedule_repository.dart';

part 'church_schedules_viewmodel.g.dart';

/// 일정 탭의 상태를 관리하는 ViewModel.
/// 주간/월간 뷰 모드 전환 및 해당 기간의 일정 목록을 제공합니다.
@riverpod
class ChurchSchedulesViewModel extends _$ChurchSchedulesViewModel {
  ScheduleViewMode _viewMode = ScheduleViewMode.weekly;

  @override
  Future<ChurchSchedulesState> build(String churchId) async {
    final now = DateTime.now();
    final to = _viewMode == ScheduleViewMode.weekly
        ? now.add(const Duration(days: 7))
        : DateTime(now.year, now.month + 1, 1);

    final schedules = await ref
        .read(churchScheduleRepositoryProvider)
        .getSchedules(churchId: churchId, from: now, to: to);

    return ChurchSchedulesState(
      schedules: schedules,
      viewMode: _viewMode,
    );
  }

  /// 뷰 모드(주간/월간)를 변경하고 해당 기간의 일정을 재조회합니다.
  void toggleView(ScheduleViewMode mode) {
    _viewMode = mode;
    ref.invalidateSelf();
  }
}
