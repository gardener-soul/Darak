import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/church_schedule.dart';
import '../../models/church_schedules_state.dart';
import '../../repositories/church_schedule_repository.dart';

part 'church_schedules_viewmodel.g.dart';

/// 일정 탭의 상태를 관리하는 ViewModel.
/// 월 단위 스트림 기반으로 캘린더 이벤트 마커 및 날짜 선택 상태를 제공합니다.
@riverpod
class ChurchSchedulesViewModel extends _$ChurchSchedulesViewModel {
  StreamSubscription<List<ChurchSchedule>>? _monthSubscription;

  @override
  Stream<ChurchSchedulesState> build(String churchId) {
    final now = DateTime.now();
    final initialState = ChurchSchedulesState(
      schedules: const [],
      focusedMonth: DateTime(now.year, now.month),
      selectedDate: DateTime(now.year, now.month, now.day),
    );

    ref.onDispose(() => _monthSubscription?.cancel());

    // 초기 월 스트림 구독
    return _watchMonth(churchId, now.year, now.month).map(
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

  /// 캘린더 포커스 월을 변경하고 해당 월의 일정을 재구독합니다.
  void changeFocusedMonth(String churchId, DateTime month) {
    // 이전 구독 취소
    _monthSubscription?.cancel();

    state = const AsyncLoading();

    _monthSubscription = _watchMonth(churchId, month.year, month.month).listen(
      (schedules) {
        try {
          final current = state.valueOrNull;
          state = AsyncData(
            (current ??
                    ChurchSchedulesState(
                      schedules: schedules,
                      focusedMonth: month,
                      selectedDate: DateTime(month.year, month.month, 1),
                    ))
                .copyWith(
              schedules: schedules,
              focusedMonth: month,
            ),
          );
        } catch (_) {
          // provider가 이미 dispose된 경우 무시
        }
      },
      onError: (Object e, StackTrace s) {
        try {
          state = AsyncError(e, s);
        } catch (_) {}
      },
    );
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
