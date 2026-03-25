import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/follow/follow.dart';
import '../../repositories/follow_repository.dart';

part 'follow_request_viewmodel.g.dart';

// ─── 팔로우 요청 목록 스트림 Provider ─────────────────────────────────────────

/// 나에게 온 팔로우 요청(pending) 실시간 스트림
@riverpod
Stream<List<Follow>> pendingFollowRequests(Ref ref, String userId) {
  return ref
      .watch(followRepositoryProvider)
      .watchPendingRequests(userId: userId);
}

// ─── 팔로우 요청 액션 ViewModel ───────────────────────────────────────────────

/// 팔로우 요청 수락/거절 액션 ViewModel
class FollowRequestViewModel extends Notifier<void> {
  @override
  void build() {}

  /// 팔로우 요청 수락
  Future<void> acceptRequest({required String followId}) async {
    try {
      await ref
          .read(followRepositoryProvider)
          .acceptFollowRequest(followId: followId);
    } catch (e) {
      debugPrint('팔로우 수락 실패: $e');
      rethrow;
    }
  }

  /// 팔로우 요청 거절 (Hard Delete)
  Future<void> rejectRequest({required String followId}) async {
    try {
      await ref
          .read(followRepositoryProvider)
          .rejectFollowRequest(followId: followId);
    } catch (e) {
      debugPrint('팔로우 거절 실패: $e');
      rethrow;
    }
  }
}

/// [FollowRequestViewModel] Provider
final followRequestViewModelProvider =
    NotifierProvider<FollowRequestViewModel, void>(FollowRequestViewModel.new);
