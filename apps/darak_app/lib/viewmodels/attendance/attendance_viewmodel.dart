import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/attendance.dart';
import '../../models/attendance_status.dart';
import '../../models/attendance_type.dart';
import '../../repositories/attendance_repository.dart';

part 'attendance_viewmodel.g.dart';

// ═══════════════════════════════════════════════════════════════
// 출석 체크 상태 클래스 (순장용)
// ═══════════════════════════════════════════════════════════════

/// 순장이 AttendanceCheckBottomSheet에서 사용할 입력 상태
class AttendanceCheckState {
  final DateTime selectedDate;
  final AttendanceType selectedType;
  final Map<String, AttendanceStatus> memberStatuses; // userId → status
  final Map<String, String?> memberNotes;             // userId → note
  final bool isLoading;
  final String? errorMessage;

  const AttendanceCheckState({
    required this.selectedDate,
    required this.selectedType,
    required this.memberStatuses,
    this.memberNotes = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  AttendanceCheckState copyWith({
    DateTime? selectedDate,
    AttendanceType? selectedType,
    Map<String, AttendanceStatus>? memberStatuses,
    Map<String, String?>? memberNotes,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AttendanceCheckState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedType: selectedType ?? this.selectedType,
      memberStatuses: memberStatuses ?? this.memberStatuses,
      memberNotes: memberNotes ?? this.memberNotes,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// AttendanceCheckViewModel — 출석 체크 입력 상태 관리
// ═══════════════════════════════════════════════════════════════

@riverpod
class AttendanceCheckViewModel extends _$AttendanceCheckViewModel {
  // QA-3 [SUGGESTION]: 다중 비동기 Race Condition 방어용 Request ID
  int _loadRequestId = 0;

  @override
  AttendanceCheckState build() {
    return AttendanceCheckState(
      selectedDate: DateTime.now(),
      selectedType: AttendanceType.onlySundayService,
      memberStatuses: const {},
    );
  }

  /// 멤버 초기화 (BottomSheet 진입 시 호출)
  Future<void> initMembers({
    required String groupId,
    required List<String> memberIds,
  }) async {
    final reqId = ++_loadRequestId;
    final statuses = {for (final id in memberIds) id: AttendanceStatus.present};
    state = state.copyWith(memberStatuses: statuses, isLoading: true);
    await _loadExistingRecords(groupId: groupId, memberIds: memberIds, reqId: reqId);
  }

  /// 날짜 변경 시 기존 출석 기록을 다시 불러옵니다.
  Future<void> changeDate({
    required DateTime date,
    required String groupId,
    required List<String> memberIds,
  }) async {
    final reqId = ++_loadRequestId;
    state = state.copyWith(selectedDate: date, isLoading: true);
    await _loadExistingRecords(groupId: groupId, memberIds: memberIds, reqId: reqId);
  }

  /// 출석 유형 변경
  Future<void> changeType({
    required AttendanceType type,
    required String groupId,
    required List<String> memberIds,
  }) async {
    final reqId = ++_loadRequestId;
    state = state.copyWith(selectedType: type, isLoading: true);
    await _loadExistingRecords(groupId: groupId, memberIds: memberIds, reqId: reqId);
  }

  /// 특정 멤버의 출석 상태 변경
  void updateMemberStatus(String userId, AttendanceStatus status) {
    final updated = Map<String, AttendanceStatus>.from(state.memberStatuses);
    updated[userId] = status;
    state = state.copyWith(memberStatuses: updated);
  }

  /// 특정 멤버의 비고 변경
  void updateMemberNote(String userId, String? note) {
    final updated = Map<String, String?>.from(state.memberNotes);
    updated[userId] = note;
    state = state.copyWith(memberNotes: updated);
  }

  /// 기존 출석 기록 로드 (수정 모드 진입 시 호출)
  Future<void> _loadExistingRecords({
    required String groupId,
    required List<String> memberIds,
    required int reqId,
  }) async {
    try {
      final repo = ref.read(attendanceRepositoryProvider);
      final records = await repo.getAttendancesByGroupAndDate(
        groupId: groupId,
        date: state.selectedDate,
        type: state.selectedType,
      );

      // Race Condition 방어: 내 요청 이후에 새로운 요청이 있었다면 폐기
      if (reqId != _loadRequestId) return;

      final statuses = {for (final id in memberIds) id: AttendanceStatus.present};
      final notes = <String, String?>{};
      for (final record in records) {
        statuses[record.userId] = record.status;
        notes[record.userId] = record.note;
      }

      state = state.copyWith(
        memberStatuses: statuses,
        memberNotes: notes,
        isLoading: false,
        errorMessage: null,
      );
    } catch (e) {
      if (reqId != _loadRequestId) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: '기존 출석 기록을 불러오지 못했습니다.',
      );
    }
  }

  /// 저장 실행 (BatchUpsert)
  Future<bool> saveAttendance({
    required String groupId,
    required String checkedById,
  }) async {
    if (state.memberStatuses.isEmpty) {
      state = state.copyWith(errorMessage: '저장할 멤버가 없습니다.');
      return false;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(attendanceRepositoryProvider);
      await repo.batchUpsertAttendance(
        groupId: groupId,
        date: state.selectedDate,
        type: state.selectedType,
        checkedById: checkedById,
        records: state.memberStatuses,
        notes: state.memberNotes,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '출석 저장에 실패했습니다. 다시 시도해 주세요.',
      );
      return false;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// 조회용 Providers
// ═══════════════════════════════════════════════════════════════

/// 다락방별 월별 출석 스트림 Provider (AttendanceHistorySheet용)
@riverpod
Stream<List<Attendance>> groupAttendanceByMonth(
  Ref ref,
  String groupId,
  int year,
  int month,
) {
  final repo = ref.watch(attendanceRepositoryProvider);
  return repo.watchGroupAttendanceByMonth(
    groupId: groupId,
    year: year,
    month: month,
  );
}

/// 마을 전체 출석 현황 Provider (VillageAttendanceSheet용)
@riverpod
Future<List<Attendance>> villageAttendanceSummary(
  Ref ref,
  List<String> groupIds,
  DateTime startDate,
  DateTime endDate,
) async {
  final repo = ref.watch(attendanceRepositoryProvider);
  return repo.getAttendancesByGroups(
    groupIds: groupIds,
    from: startDate,
    to: endDate,
  );
}

/// 마이페이지용 내 출석 이력 Provider
@riverpod
Future<List<Attendance>> myAttendanceHistory(Ref ref, String userId) async {
  final repo = ref.watch(attendanceRepositoryProvider);
  return repo.getMyAttendances(userId: userId, limit: 5);
}

/// 그룹 최근 출석 요약 Provider (GroupDetailBottomSheet용)
@riverpod
Future<List<Attendance>> recentGroupAttendances(Ref ref, String groupId) async {
  final repo = ref.watch(attendanceRepositoryProvider);
  return repo.getRecentGroupAttendances(groupId: groupId, limit: 30);
}
