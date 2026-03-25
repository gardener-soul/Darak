import 'package:freezed_annotation/freezed_annotation.dart';

import 'church_schedule.dart';

part 'church_schedules_state.freezed.dart';

/// 일정 탭 ViewModel 상태 모델
/// 선택된 날짜 및 캘린더 포커스 월을 포함합니다.
@freezed
class ChurchSchedulesState with _$ChurchSchedulesState {
  const factory ChurchSchedulesState({
    required List<ChurchSchedule> schedules, // 현재 포커스 월 전체 일정
    required DateTime focusedMonth, // 캘린더 포커스 월
    required DateTime selectedDate, // 선택된 날짜
  }) = _ChurchSchedulesState;
}
