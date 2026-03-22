import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/prayer.dart';
import '../../repositories/prayer_repository.dart';
import '../follow/follow_list_viewmodel.dart';

part 'community_prayer_viewmodel.g.dart';

// ─── 공동체 기도 필터 타입 ─────────────────────────────────────────────────────

/// 공동체 기도 탭 필터 종류
enum CommunityPrayerFilter {
  /// 다락방 + 팔로잉 기도 전체
  all,

  /// 다락방 공개 기도만
  group,

  /// 팔로잉 기도만
  followers,
}

// ─── 공동체 기도 목록 스트림 Provider ─────────────────────────────────────────

/// 공동체 기도 목록 — 같은 다락방의 group 공개 기도 제목 실시간 스트림
@riverpod
Stream<List<Prayer>> communityPrayerList(Ref ref, String groupId) {
  return ref
      .watch(prayerRepositoryProvider)
      .watchCommunityPrayers(groupId: groupId);
}

/// 팔로잉 기도 목록 — 내가 팔로우 중인 사용자들의 followers 공개 기도 실시간 스트림
@riverpod
Stream<List<Prayer>> followingPrayerList(Ref ref, String userId) {
  final followingIdsAsync = ref.watch(followingIdsProvider(userId));
  final followeeIds = followingIdsAsync.valueOrNull ?? [];
  return ref
      .watch(prayerRepositoryProvider)
      .watchFollowersPrayers(followeeIds: followeeIds);
}

/// 통합 공동체 기도 목록 — 다락방 + 팔로잉 기도 합산 후 최신순 정렬
@riverpod
Stream<List<Prayer>> mergedCommunityPrayerList(
  Ref ref,
  String groupId,
  String userId,
) {
  final groupStream = ref
      .watch(prayerRepositoryProvider)
      .watchCommunityPrayers(groupId: groupId);

  final followingIdsAsync = ref.watch(followingIdsProvider(userId));
  final followeeIds = followingIdsAsync.valueOrNull ?? [];
  final followersStream = ref
      .watch(prayerRepositoryProvider)
      .watchFollowersPrayers(followeeIds: followeeIds);

  return groupStream.asyncExpand(
    (groupPrayers) => followersStream.map((followersPrayers) {
      // 중복 제거 후 최신순 정렬
      final allIds = <String>{};
      final merged = <Prayer>[];
      for (final p in [...groupPrayers, ...followersPrayers]) {
        if (allIds.add(p.id)) merged.add(p);
      }
      merged.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return merged;
    }),
  );
}
