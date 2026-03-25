import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/follow/follow_status.dart';
import '../../models/user.dart';
import '../../repositories/follow_repository.dart';
import '../../repositories/user_repository.dart';

part 'follow_search_viewmodel.g.dart';

// ─── 검색 상태 모델 ───────────────────────────────────────────────────────────

/// 사용자 검색 결과 항목 (검색 결과 + 팔로우 상태 포함)
class FollowSearchResult {
  final User user;
  final FollowStatus? followStatus; // null = 팔로우 관계 없음

  const FollowSearchResult({
    required this.user,
    required this.followStatus,
  });
}

// ─── 팔로우 검색 ViewModel ────────────────────────────────────────────────────

/// 같은 교회 내 교인 검색 + 팔로우 상태 표시 + 팔로우 요청 전송 ViewModel
@riverpod
class FollowSearchViewModel extends _$FollowSearchViewModel {
  @override
  Future<List<FollowSearchResult>> build() async => [];

  /// 검색어 기반으로 같은 교회 교인 검색 (본인 제외)
  Future<void> search({
    required String query,
    required String currentUserId,
    required String churchId,
  }) async {
    if (query.trim().isEmpty) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    try {
      // UserRepository를 통해 검색 — ViewModel에서 Firestore 직접 접근 금지
      final users = await ref.read(userRepositoryProvider).searchUsersByName(
            churchId: churchId,
            query: query,
            excludeUserId: currentUserId,
          );

      final followRepo = ref.read(followRepositoryProvider);
      final results = <FollowSearchResult>[];

      for (final user in users) {
        final followStatus = await followRepo.getFollowStatus(
          followerId: currentUserId,
          followeeId: user.id,
        );
        results.add(FollowSearchResult(user: user, followStatus: followStatus));
      }

      state = AsyncData(results);
    } catch (e) {
      debugPrint('교인 검색 실패: $e');
      state = AsyncError(e, StackTrace.current);
    }
  }

  /// 팔로우 요청 전송 후 낙관적 UI 업데이트
  Future<void> sendFollowRequest({
    required String followerId,
    required String followeeId,
    required String churchId,
  }) async {
    try {
      await ref.read(followRepositoryProvider).sendFollowRequest(
            followerId: followerId,
            followeeId: followeeId,
            churchId: churchId,
          );
      // 낙관적 UI 업데이트: 해당 항목 상태를 pending으로 변경
      final current = state.valueOrNull ?? [];
      state = AsyncData(
        current.map((item) {
          if (item.user.id == followeeId) {
            return FollowSearchResult(
              user: item.user,
              followStatus: FollowStatus.pending,
            );
          }
          return item;
        }).toList(),
      );
    } catch (e) {
      debugPrint('팔로우 요청 실패: $e');
      rethrow;
    }
  }
}
