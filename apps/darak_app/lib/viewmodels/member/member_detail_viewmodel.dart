import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/attendance.dart';
import '../../models/member_note.dart';
import '../../models/user.dart';
import '../../core/utils/string_utils.dart';
import '../../repositories/attendance_repository.dart';
import '../../repositories/member_note_repository.dart';
import '../../repositories/user_repository.dart';

part 'member_detail_viewmodel.g.dart';

// ═══════════════════════════════════════════════════════════════
// MemberDetailState
// ═══════════════════════════════════════════════════════════════

class MemberDetailState {
  final AsyncValue<User?> userAsync;
  final AsyncValue<List<MemberNote>> notesAsync;
  final bool isSubmittingNote;
  final String? errorMessage;

  const MemberDetailState({
    this.userAsync = const AsyncValue.loading(),
    this.notesAsync = const AsyncValue.loading(),
    this.isSubmittingNote = false,
    this.errorMessage,
  });

  MemberDetailState copyWith({
    AsyncValue<User?>? userAsync,
    AsyncValue<List<MemberNote>>? notesAsync,
    bool? isSubmittingNote,
    String? errorMessage,
  }) {
    return MemberDetailState(
      userAsync: userAsync ?? this.userAsync,
      notesAsync: notesAsync ?? this.notesAsync,
      isSubmittingNote: isSubmittingNote ?? this.isSubmittingNote,
      errorMessage: errorMessage,
    );
  }

  /// 생일까지 남은 일수 (올해 또는 내년 기준)
  /// null이면 생일 정보 없음
  int? get daysUntilBirthday {
    final user = userAsync.valueOrNull;
    if (user == null || user.birthDate == null) return null;

    final now = DateTime.now();
    final birth = user.birthDate!;

    // 올해 생일 계산
    var thisYearBirthday = DateTime(now.year, birth.month, birth.day);

    // 올해 생일이 이미 지났으면 내년 생일로 계산
    if (thisYearBirthday.isBefore(DateTime(now.year, now.month, now.day))) {
      thisYearBirthday = DateTime(now.year + 1, birth.month, birth.day);
    }

    return thisYearBirthday.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  /// 생일 넛지 표시 여부 (7일 이내)
  bool get showBirthdayNudge {
    final days = daysUntilBirthday;
    return days != null && days <= 7;
  }
}

// ═══════════════════════════════════════════════════════════════
// MemberDetailViewModel
// ═══════════════════════════════════════════════════════════════

@riverpod
class MemberDetailViewModel extends _$MemberDetailViewModel {
  StreamSubscription<List<MemberNote>>? _notesSub;

  @override
  MemberDetailState build(String userId) {
    ref.onDispose(() => _notesSub?.cancel());
    _loadUser();
    return const MemberDetailState();
  }

  /// 순원 프로필 데이터 로딩
  Future<void> _loadUser() async {
    try {
      final user = await ref.read(userRepositoryProvider).getUserById(userId);
      state = state.copyWith(userAsync: AsyncValue.data(user));
    } catch (e) {
      state = state.copyWith(
        userAsync: AsyncValue.error(e, StackTrace.current),
      );
    }
  }

  /// 비공개 메모 실시간 구독 시작 (View에서 권한 확인 후 호출)
  void startWatchingNotes() {
    _notesSub?.cancel();
    _notesSub = ref
        .read(memberNoteRepositoryProvider)
        .watchNotes(userId)
        .listen(
          (notes) => state = state.copyWith(
            notesAsync: AsyncValue.data(notes),
          ),
          onError: (error) => state = state.copyWith(
            notesAsync: AsyncValue.error(error, StackTrace.current),
          ),
        );
  }

  /// 메모 추가
  Future<void> addNote({
    required String content,
    required String createdBy,
  }) async {
    if (content.trim().isEmpty) return;
    state = state.copyWith(isSubmittingNote: true, errorMessage: null);
    try {
      await ref.read(memberNoteRepositoryProvider).createNote(
            userId: userId,
            content: content.trim(),
            createdBy: createdBy,
          );
      state = state.copyWith(isSubmittingNote: false);
    } catch (e) {
      state = state.copyWith(
        isSubmittingNote: false,
        errorMessage: StringUtils.cleanExceptionMessage(e),
      );
      rethrow;
    }
  }

  /// 메모 수정
  Future<void> updateNote({
    required String noteId,
    required String content,
  }) async {
    if (content.trim().isEmpty) return;
    state = state.copyWith(isSubmittingNote: true, errorMessage: null);
    try {
      await ref.read(memberNoteRepositoryProvider).updateNote(
            userId: userId,
            noteId: noteId,
            content: content.trim(),
          );
      state = state.copyWith(isSubmittingNote: false);
    } catch (e) {
      state = state.copyWith(
        isSubmittingNote: false,
        errorMessage: StringUtils.cleanExceptionMessage(e),
      );
      rethrow;
    }
  }

  /// 메모 Soft Delete
  Future<void> deleteNote({required String noteId}) async {
    state = state.copyWith(errorMessage: null);
    try {
      await ref.read(memberNoteRepositoryProvider).softDeleteNote(
            userId: userId,
            noteId: noteId,
          );
    } catch (e) {
      state = state.copyWith(
        errorMessage: StringUtils.cleanExceptionMessage(e),
      );
      rethrow;
    }
  }

  /// 데이터 새로고침
  Future<void> refresh() async {
    state = state.copyWith(
      userAsync: const AsyncValue.loading(),
    );
    await _loadUser();
  }
}

// ═══════════════════════════════════════════════════════════════
// 출석 이력 Provider (순원 상세 화면용)
// ═══════════════════════════════════════════════════════════════

@riverpod
Future<List<Attendance>> memberAttendanceHistory(
  Ref ref,
  String userId,
) async {
  return ref.read(attendanceRepositoryProvider).getMyAttendances(
        userId: userId,
        limit: 8,
      );
}
