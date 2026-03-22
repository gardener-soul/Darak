import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/follow/follow.dart';
import '../../repositories/follow_repository.dart';

part 'follow_list_viewmodel.g.dart';

// ─── 팔로잉 목록 스트림 Provider ──────────────────────────────────────────────

/// 내가 팔로우 중인 목록 실시간 스트림
@riverpod
Stream<List<Follow>> followingList(Ref ref, String userId) {
  return ref.watch(followRepositoryProvider).watchFollowingList(userId: userId);
}

// ─── 팔로워 목록 스트림 Provider ──────────────────────────────────────────────

/// 나를 팔로우하는 목록 실시간 스트림
@riverpod
Stream<List<Follow>> followerList(Ref ref, String userId) {
  return ref.watch(followRepositoryProvider).watchFollowerList(userId: userId);
}

// ─── 팔로잉 ID 목록 스트림 Provider ──────────────────────────────────────────

/// 내가 팔로우 중인 사용자 ID 목록 실시간 스트림
@riverpod
Stream<List<String>> followingIds(Ref ref, String userId) {
  return ref.watch(followRepositoryProvider).watchFollowingIds(userId: userId);
}

// ─── 팔로잉/팔로워 목록 액션 ViewModel ───────────────────────────────────────

/// 팔로잉 목록 액션 ViewModel (팔로우 취소 / 팔로워 삭제)
class FollowListViewModel extends Notifier<void> {
  @override
  void build() {}

  /// 내가 팔로우 중인 상대를 언팔로우
  Future<void> cancelFollow({
    required String followerId,
    required String followeeId,
  }) async {
    try {
      await ref.read(followRepositoryProvider).cancelFollow(
            followerId: followerId,
            followeeId: followeeId,
          );
    } catch (e) {
      debugPrint('팔로우 취소 실패: $e');
      rethrow;
    }
  }

  /// 나를 팔로우하는 사람을 팔로워 목록에서 제거
  Future<void> removeFollower({
    required String followerId,
    required String followeeId,
  }) async {
    try {
      await ref.read(followRepositoryProvider).removeFollower(
            followerId: followerId,
            followeeId: followeeId,
          );
    } catch (e) {
      debugPrint('팔로워 삭제 실패: $e');
      rethrow;
    }
  }
}

/// [FollowListViewModel] Provider
final followListViewModelProvider =
    NotifierProvider<FollowListViewModel, void>(FollowListViewModel.new);
