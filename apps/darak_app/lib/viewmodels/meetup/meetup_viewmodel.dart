import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/user_providers.dart';
import '../../models/meetup.dart';
import '../../repositories/meetup_repository.dart';

part 'meetup_viewmodel.g.dart';

/// 번개 모임 탭의 상태를 관리하는 ViewModel.
/// 월 단위 스트림 기반으로 캘린더 이벤트 마커 및 날짜 선택 상태를 제공합니다.
@riverpod
class MeetupViewModel extends _$MeetupViewModel {
  DateTime _currentMonth = _initialMonth();

  static DateTime _initialMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  @override
  Stream<MeetupState> build(String churchId) {
    final month = _currentMonth;
    final now = DateTime.now();
    final initialState = MeetupState(
      meetups: const [],
      focusedMonth: month,
      selectedDate: DateTime(month.year, month.month, now.day),
    );

    return ref
        .read(meetupRepositoryProvider)
        .watchMeetupsByMonth(
          churchId: churchId,
          year: month.year,
          month: month.month,
        )
        .map(
          (meetups) =>
              (state.valueOrNull ?? initialState).copyWith(meetups: meetups),
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
  void changeFocusedMonth(DateTime month) {
    _currentMonth = month;
    final current = state.valueOrNull;
    if (current != null) {
      state = AsyncData(current.copyWith(focusedMonth: month));
    }
    ref.invalidateSelf();
  }

  /// 번개 모임 생성
  Future<void> createMeetup({
    required String churchId,
    required MeetUp meetup,
  }) =>
      ref.read(meetupRepositoryProvider).createMeetup(churchId: churchId, meetup: meetup);

  /// 번개 모임 참여
  Future<void> joinMeetup({
    required String churchId,
    required String meetupId,
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('로그인이 필요합니다.');
    await ref.read(meetupRepositoryProvider).joinMeetup(
      churchId: churchId,
      meetupId: meetupId,
      userId: userId,
    );
  }

  /// 번개 모임 참여 취소
  Future<void> leaveMeetup({
    required String churchId,
    required String meetupId,
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('로그인이 필요합니다.');
    await ref.read(meetupRepositoryProvider).leaveMeetup(
      churchId: churchId,
      meetupId: meetupId,
      userId: userId,
    );
  }

  /// 번개 모임 신고
  Future<void> reportMeetup({
    required String churchId,
    required String meetupId,
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('로그인이 필요합니다.');
    await ref.read(meetupRepositoryProvider).reportMeetup(
      churchId: churchId,
      meetupId: meetupId,
      userId: userId,
    );
  }

  /// 번개 모임 삭제 (주최자 전용 — ViewModel에서 소유자 검증)
  Future<void> deleteMeetup({
    required String churchId,
    required String meetupId,
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw Exception('로그인이 필요합니다.');

    // 현재 상태에서 해당 모임을 찾아 주최자 여부 확인
    final current = state.valueOrNull;
    final meetup = current?.meetups.where((m) => m.id == meetupId).firstOrNull;
    if (meetup != null && meetup.meetLeaderId != userId) {
      throw Exception('모임 주최자만 삭제할 수 있습니다.');
    }

    await ref.read(meetupRepositoryProvider).deleteMeetup(
      churchId: churchId,
      meetupId: meetupId,
    );
  }
}

/// 번개 탭 UI 상태
class MeetupState {
  final List<MeetUp> meetups;
  final DateTime focusedMonth;
  final DateTime selectedDate;

  const MeetupState({
    required this.meetups,
    required this.focusedMonth,
    required this.selectedDate,
  });

  MeetupState copyWith({
    List<MeetUp>? meetups,
    DateTime? focusedMonth,
    DateTime? selectedDate,
  }) {
    return MeetupState(
      meetups: meetups ?? this.meetups,
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
