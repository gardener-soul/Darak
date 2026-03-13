import 'package:freezed_annotation/freezed_annotation.dart';

import 'church_schedule.dart';

part 'church_schedules_state.freezed.dart';

/// 일정 탭 뷰 모드
enum ScheduleViewMode { weekly, monthly }

/// 일정 탭 ViewModel 상태 모델
@freezed
class ChurchSchedulesState with _$ChurchSchedulesState {
  const factory ChurchSchedulesState({
    required List<ChurchSchedule> schedules,
    @Default(ScheduleViewMode.weekly) ScheduleViewMode viewMode,
  }) = _ChurchSchedulesState;
}
