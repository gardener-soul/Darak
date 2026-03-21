import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/church_schedule.dart';
import '../../models/church_schedules_state.dart';
import '../../repositories/church_schedule_repository.dart';

part 'church_schedules_viewmodel.g.dart';

/// 일정 탭의 상태를 관리하는 ViewModel.
/// 월 단위 스트림 기반으로 캘린더 이벤트 마커 및 날짜 선택 상태를 제공합니다.
///
/// [W-5 수정] _currentMonth를 클래스 변수로 관리하여 changeFocusedMonth 시
/// build()가 반환한 스트림과 수동 구독이 동시에 활성화되는 충돌 문제를 해결합니다.
/// ref.invalidateSelf()를 사용하여 build()를 재호출, 단일 스트림을 유지합니다.
@riverpod
class ChurchSchedulesViewModel extends _$ChurchSchedulesViewModel {
  /// 현재 포커스 중인 월. build() 재호출 시 이 값을 기준으로 스트림을 구성합니다.
  DateTime _currentMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  @override
  Stream<ChurchSchedulesState> build(String churchId) {
    final month = _currentMonth;
    final initialState = ChurchSchedulesState(
      schedules: const [],
      focusedMonth: month,
      selectedDate: DateTime(month.year, month.month, DateTime.now().day),
    );

    // _currentMonth 기준으로 스트림을 구성합니다.
    // changeFocusedMonth → invalidateSelf → build 재호출 사이클로 단일 스트림 보장
    return _watchMonth(churchId, month.year, month.month).map(
      (schedules) =>
          (state.valueOrNull ?? initialState).copyWith(schedules: schedules),
    );
  }

  /// 선택된 날짜를 업데이트합니다.
  void selectDate(DateTime date) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        selectedDate: DateTime(date.year, date.month, date.day),
      ),
    );
  }

  /// 캘린더 포커스 월을 변경합니다.
  /// invalidateSelf() 전에 focusedMonth를 먼저 갱신하여,
  /// skipLoadingOnRefresh 시 이전 값을 사용하는 동안에도 캘린더가
  /// 새 월을 유지하도록 합니다 (스냅백 현상 방지).
  void changeFocusedMonth(String churchId, DateTime month) {
    _currentMonth = month;
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(focusedMonth: month));
    }
    ref.invalidateSelf();
  }

  Stream<List<ChurchSchedule>> _watchMonth(
    String churchId,
    int year,
    int month,
  ) {
    return ref
        .read(churchScheduleRepositoryProvider)
        .watchSchedulesByMonth(churchId: churchId, year: year, month: month);
  }

  /// 일정 생성
  Future<void> createSchedule({
    required String churchId,
    required ChurchSchedule schedule,
  }) async {
    try {
      await ref
          .read(churchScheduleRepositoryProvider)
          .createSchedule(churchId: churchId, schedule: schedule);
    } catch (e) {
      throw Exception('일정 생성에 실패했습니다: $e');
    }
  }

  /// 일정 수정
  Future<void> updateSchedule({
    required String churchId,
    required String scheduleId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await ref
          .read(churchScheduleRepositoryProvider)
          .updateSchedule(
            churchId: churchId,
            scheduleId: scheduleId,
            data: data,
          );
    } catch (e) {
      throw Exception('일정 수정에 실패했습니다: $e');
    }
  }

  /// 일정 삭제 (Soft Delete)
  Future<void> deleteSchedule({
    required String churchId,
    required String scheduleId,
  }) async {
    try {
      await ref
          .read(churchScheduleRepositoryProvider)
          .deleteSchedule(churchId: churchId, scheduleId: scheduleId);
    } catch (e) {
      throw Exception('일정 삭제에 실패했습니다: $e');
    }
  }
}
