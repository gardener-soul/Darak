import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/feed/encouragement.dart';
import '../../repositories/feed_repository.dart';

part 'feed_encouragement_viewmodel.g.dart';

// ─── 격려 메시지 목록 스트림 Provider ─────────────────────────────────────────

@riverpod
Stream<List<Encouragement>> feedEncouragements(
  Ref ref,
  String feedId,
) {
  return ref
      .watch(feedRepositoryProvider)
      .watchEncouragements(feedId: feedId);
}

// ─── 격려 메시지 작성 상태 ─────────────────────────────────────────────────────

class EncouragementCreateState {
  final String text;
  final bool isLoading;
  final String? errorMessage;

  const EncouragementCreateState({
    this.text = '',
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isValid => text.trim().isNotEmpty && text.trim().length <= 100;

  EncouragementCreateState copyWith({
    String? text,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return EncouragementCreateState(
      text: text ?? this.text,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ─── FeedEncouragementViewModel ────────────────────────────────────────────────

@riverpod
class FeedEncouragementViewModel extends _$FeedEncouragementViewModel {
  @override
  EncouragementCreateState build(String feedId) =>
      const EncouragementCreateState();

  void updateText(String value) {
    state = state.copyWith(text: value, clearError: true);
  }

  void clear() {
    state = const EncouragementCreateState();
  }

  /// 격려 메시지 전송 — 성공 시 true 반환
  Future<bool> submit({required String userId}) async {
    if (!state.isValid) {
      state = state.copyWith(errorMessage: '격려 메시지를 입력해주세요 (최대 100자)');
      return false;
    }
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await ref.read(feedRepositoryProvider).createEncouragement(
            feedId: feedId,
            userId: userId,
            text: state.text,
          );
      state = const EncouragementCreateState();
      return true;
    } catch (e) {
      debugPrint('격려 메시지 전송 실패: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: '전송에 실패했어요. 다시 시도해주세요.',
      );
      return false;
    }
  }

  /// 격려 메시지 삭제
  Future<void> delete({required String encouragementId}) async {
    try {
      await ref.read(feedRepositoryProvider).deleteEncouragement(
            feedId: feedId,
            encouragementId: encouragementId,
          );
    } catch (e) {
      debugPrint('격려 메시지 삭제 실패: $e');
      rethrow;
    }
  }
}
