import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/feed/feed_content_type.dart';
import '../../models/feed/feed_visibility.dart';
import '../../repositories/feed_repository.dart';

part 'feed_create_viewmodel.g.dart';

// ─── 게시물 작성 폼 상태 ──────────────────────────────────────────────────────

class FeedCreateState {
  final String text;
  final FeedContentType contentType;
  final FeedVisibility visibility;
  final String? linkedPrayerId;
  final bool isLoading;
  final String? errorMessage;

  const FeedCreateState({
    this.text = '',
    this.contentType = FeedContentType.general,
    this.visibility = FeedVisibility.followers,
    this.linkedPrayerId,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isValid => text.trim().isNotEmpty && text.trim().length <= 500;

  FeedCreateState copyWith({
    String? text,
    FeedContentType? contentType,
    FeedVisibility? visibility,
    String? linkedPrayerId,
    bool clearLinkedPrayer = false,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return FeedCreateState(
      text: text ?? this.text,
      contentType: contentType ?? this.contentType,
      visibility: visibility ?? this.visibility,
      linkedPrayerId:
          clearLinkedPrayer ? null : (linkedPrayerId ?? this.linkedPrayerId),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ─── FeedCreateViewModel ──────────────────────────────────────────────────────

@riverpod
class FeedCreateViewModel extends _$FeedCreateViewModel {
  @override
  FeedCreateState build() => const FeedCreateState();

  void updateText(String value) {
    state = state.copyWith(text: value, clearError: true);
  }

  void updateContentType(FeedContentType type) {
    state = state.copyWith(contentType: type);
  }

  void updateVisibility(FeedVisibility visibility) {
    state = state.copyWith(visibility: visibility);
  }

  void linkPrayer(String prayerId) {
    state = state.copyWith(linkedPrayerId: prayerId);
  }

  void unlinkPrayer() {
    state = state.copyWith(clearLinkedPrayer: true);
  }

  /// 게시물 등록 — 성공 시 true 반환
  Future<bool> submit({
    required String userId,
    required String churchId,
    String? groupId,
  }) async {
    if (!state.isValid) {
      state = state.copyWith(errorMessage: '내용을 입력해주세요 (최대 500자)');
      return false;
    }
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await ref.read(feedRepositoryProvider).createFeed(
            userId: userId,
            churchId: churchId,
            groupId: groupId,
            contentType: state.contentType,
            text: state.text,
            visibility: state.visibility,
            linkedPrayerId: state.linkedPrayerId,
          );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '게시에 실패했어요. 다시 시도해주세요.',
      );
      return false;
    }
  }
}
