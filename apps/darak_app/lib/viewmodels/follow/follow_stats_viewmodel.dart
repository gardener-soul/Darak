import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repositories/follow_repository.dart';

/// 팔로잉/팔로워 수 집계 Provider
///
/// 주어진 [userId]의 팔로잉 수와 팔로워 수를 병렬로 조회하여 반환합니다.
/// accepted 상태의 팔로우 관계만 카운트합니다.
final followStatsProvider =
    FutureProvider.family<({int following, int follower}), String>(
  (ref, userId) async {
    final repo = ref.watch(followRepositoryProvider);
    final results = await Future.wait([
      repo.getFollowingCount(userId: userId),
      repo.getFollowerCount(userId: userId),
    ]);
    return (following: results[0], follower: results[1]);
  },
);
