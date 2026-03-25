import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/feed/feed.dart';
import '../../repositories/feed_repository.dart';
import '../../repositories/follow_repository.dart';

part 'feed_timeline_viewmodel.g.dart';

// ─── 피드 필터 타입 ───────────────────────────────────────────────────────────

enum FeedFilter {
  all, // 전체 (다락방 + 팔로잉 통합)
  group, // 다락방만
  following, // 팔로잉만
}

extension FeedFilterX on FeedFilter {
  String get label {
    switch (this) {
      case FeedFilter.all:
        return '전체';
      case FeedFilter.group:
        return '다락방';
      case FeedFilter.following:
        return '팔로잉';
    }
  }
}

// ─── 타임라인 상태 ─────────────────────────────────────────────────────────────

class FeedTimelineState {
  final List<Feed> feeds;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;
  final FeedFilter filter;

  const FeedTimelineState({
    this.feeds = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.errorMessage,
    this.filter = FeedFilter.all,
  });

  FeedTimelineState copyWith({
    List<Feed>? feeds,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    bool clearError = false,
    FeedFilter? filter,
  }) {
    return FeedTimelineState(
      feeds: feeds ?? this.feeds,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      filter: filter ?? this.filter,
    );
  }
}

// ─── FeedTimelineViewModel ─────────────────────────────────────────────────

@riverpod
class FeedTimelineViewModel extends _$FeedTimelineViewModel {
  // 각 소스별 페이지네이션 커서
  DocumentSnapshot? _lastGroupDoc;
  DocumentSnapshot? _lastFollowingDoc;

  // 중복 제거용 ID Set
  final Set<String> _seenIds = {};

  // 팔로잉 ID 캐시 (loadMore 시 재조회 방지)
  List<String> _cachedFolloweeIds = [];

  @override
  FeedTimelineState build() => const FeedTimelineState();

  /// 타임라인 초기 로딩 (3개 소스 병합)
  Future<void> loadTimeline({
    required String userId,
    required String churchId,
    String? groupId,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    _lastGroupDoc = null;
    _lastFollowingDoc = null;
    _seenIds.clear();

    try {
      final feedRepo = ref.read(feedRepositoryProvider);
      final followRepo = ref.read(followRepositoryProvider);

      // 팔로잉 목록 조회 후 캐시 (loadMore 시 재조회 방지)
      _cachedFolloweeIds = await _getFolloweeIds(userId, followRepo);
      final followeeIds = _cachedFolloweeIds;

      // 각 소스에서 병렬로 피드 조회
      final results = await Future.wait([
        if (groupId != null)
          feedRepo.getGroupFeedPage(churchId: churchId, groupId: groupId)
        else
          Future.value((feeds: <Feed>[], lastDoc: null)),
        feedRepo.getFollowingFeedPage(followeeIds: followeeIds),
      ]);

      final groupResult = results[0];
      final followingResult = results[1];

      _lastGroupDoc = groupResult.lastDoc;
      _lastFollowingDoc = followingResult.lastDoc;

      final merged = _mergeAndDeduplicate([
        ...groupResult.feeds,
        ...followingResult.feeds,
      ]);

      state = state.copyWith(
        feeds: merged,
        isLoading: false,
        hasMore: groupResult.feeds.length == 20 ||
            followingResult.feeds.length == 20,
      );
    } catch (e) {
      debugPrint('피드 타임라인 로딩 실패: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: '피드를 불러오지 못했어요. 다시 시도해주세요.',
      );
    }
  }

  /// 추가 페이지 로딩 (무한 스크롤)
  Future<void> loadMore({
    required String userId,
    required String churchId,
    String? groupId,
  }) async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final feedRepo = ref.read(feedRepositoryProvider);

      // 캐시된 팔로잉 목록 사용 (매번 재조회 방지)
      final followeeIds = _cachedFolloweeIds;

      final results = await Future.wait([
        if (groupId != null)
          feedRepo.getGroupFeedPage(
            churchId: churchId,
            groupId: groupId,
            lastDoc: _lastGroupDoc,
          )
        else
          Future.value((feeds: <Feed>[], lastDoc: null)),
        feedRepo.getFollowingFeedPage(
          followeeIds: followeeIds,
          lastDoc: _lastFollowingDoc,
        ),
      ]);

      final groupResult = results[0];
      final followingResult = results[1];

      if (groupResult.lastDoc != null) _lastGroupDoc = groupResult.lastDoc;
      if (followingResult.lastDoc != null) {
        _lastFollowingDoc = followingResult.lastDoc;
      }

      final newFeeds = _mergeAndDeduplicate([
        ...groupResult.feeds,
        ...followingResult.feeds,
      ]);

      state = state.copyWith(
        feeds: [...state.feeds, ...newFeeds],
        isLoadingMore: false,
        hasMore: groupResult.feeds.length == 20 ||
            followingResult.feeds.length == 20,
      );
    } catch (e) {
      debugPrint('피드 추가 로딩 실패: $e');
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// 필터 변경
  void setFilter(FeedFilter filter) {
    state = state.copyWith(filter: filter);
  }

  /// 피드 목록에서 로컬 삭제 (낙관적 UI)
  void removeLocalFeed(String feedId) {
    state = state.copyWith(
      feeds: state.feeds.where((f) => f.id != feedId).toList(),
    );
  }

  /// 피드 목록에서 로컬 업데이트 (낙관적 UI)
  void updateLocalFeed(Feed updated) {
    state = state.copyWith(
      feeds: state.feeds
          .map((f) => f.id == updated.id ? updated : f)
          .toList(),
    );
  }

  // ─── 내부 헬퍼 ──────────────────────────────────────────────────────────

  Future<List<String>> _getFolloweeIds(
    String userId,
    FollowRepository followRepo,
  ) async {
    try {
      return await followRepo.getFolloweeIds(userId: userId);
    } catch (e) {
      debugPrint('팔로잉 목록 조회 실패: $e');
      return [];
    }
  }

  /// 중복 제거 + 최신순 정렬
  List<Feed> _mergeAndDeduplicate(List<Feed> feeds) {
    final result = <Feed>[];
    for (final feed in feeds) {
      if (!_seenIds.contains(feed.id)) {
        _seenIds.add(feed.id);
        result.add(feed);
      }
    }
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }
}

// ─── 필터 선택 상태 Provider ───────────────────────────────────────────────

@riverpod
class SelectedFeedFilter extends _$SelectedFeedFilter {
  @override
  FeedFilter build() => FeedFilter.all;

  void select(FeedFilter filter) => state = filter;
}
