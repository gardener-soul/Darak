import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/user_providers.dart';
import '../../models/feed/feed.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/feed/feed_timeline_viewmodel.dart';
import '../../viewmodels/follow/follow_list_viewmodel.dart';
import '../../widgets/common/core/soft_chip.dart';
import '../../widgets/common/skeleton_card.dart';
import 'widgets/feed_card.dart';
import 'widgets/feed_create_sheet.dart';
import 'widgets/feed_empty_state.dart';

/// 피드 타임라인 메인 화면 — 홈 탭에 통합
class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTimeline());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTimeline() async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;
    await ref.read(feedTimelineViewModelProvider.notifier).loadTimeline(
          userId: user.id,
          churchId: user.churchId ?? '',
          groupId: user.groupId,
        );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      final user = ref.read(currentUserProvider).valueOrNull;
      if (user == null) return;
      ref.read(feedTimelineViewModelProvider.notifier).loadMore(
            userId: user.id,
            churchId: user.churchId ?? '',
            groupId: user.groupId,
          );
    }
  }

  Future<void> _onRefresh() async {
    await _loadTimeline();
  }

  void _openCreateSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FeedCreateSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeline = ref.watch(feedTimelineViewModelProvider);
    final userAsync = ref.watch(currentUserProvider);
    final filter = ref.watch(selectedFeedFilterProvider);

    // 팔로잉 필터일 때만 팔로우 ID 목록 구독 (불필요한 Firestore 리스너 방지)
    final currentUser = userAsync.valueOrNull;
    final followingIdList = (filter == FeedFilter.following && currentUser != null)
        ? ref.watch(followingIdsProvider(currentUser.id)).valueOrNull ?? []
        : <String>[];

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: SafeArea(
        child: Column(
          children: [
            // 앱바
            const _FeedAppBar(),

            // 필터 칩
            _FilterRow(selected: filter),

            // 피드 리스트
            Expanded(
              child: userAsync.when(
                loading: () => _SkeletonList(),
                error: (_, _) => const Center(
                  child: Text('사용자 정보를 불러오지 못했어요.'),
                ),
                data: (user) {
                  if (user == null) return const SizedBox.shrink();

                  if (timeline.isLoading) return _SkeletonList();

                  if (timeline.errorMessage != null) {
                    return _ErrorView(
                      message: timeline.errorMessage!,
                      onRetry: _loadTimeline,
                    );
                  }

                  // 필터에 따른 피드 필터링
                  final feeds = _filteredFeeds(timeline, filter, user.groupId, followingIdList);

                  if (feeds.isEmpty) {
                    return FeedEmptyState(onCreateTap: _openCreateSheet);
                  }

                  return RefreshIndicator(
                    color: AppColors.softCoral,
                    onRefresh: _onRefresh,
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount:
                          feeds.length + (timeline.isLoadingMore ? 1 : 0),
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        if (i == feeds.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(
                                color: AppColors.softCoral,
                              ),
                            ),
                          );
                        }
                        final feed = feeds[i];
                        return FeedCard(
                          key: ValueKey(feed.id),
                          feed: feed,
                          currentUserId: user.id,
                          onEdit: feed.userId == user.id
                              ? () => _showEditDialog(context, feed)
                              : null,
                          onDelete: feed.userId == user.id
                              ? () => _confirmDelete(context, feed.id)
                              : null,
                          onReport: feed.userId != user.id
                              ? () => _confirmReport(
                                    context,
                                    feed.id,
                                    user.id,
                                  )
                              : null,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateSheet,
        backgroundColor: AppColors.softCoral,
        child: const Icon(Icons.add_rounded, color: AppColors.pureWhite),
      ),
    );
  }

  // 필터에 따른 피드 필터링
  List<Feed> _filteredFeeds(
    FeedTimelineState timeline,
    FeedFilter filter,
    String? myGroupId,
    List<String> followingIds,
  ) {
    switch (filter) {
      case FeedFilter.group:
        return timeline.feeds
            .where((f) => f.groupId == myGroupId)
            .toList();
      case FeedFilter.following:
        // 내가 팔로우하는 사람의 피드만 표시
        return timeline.feeds
            .where((f) => followingIds.contains(f.userId))
            .toList();
      case FeedFilter.all:
        return timeline.feeds;
    }
  }

  void _showEditDialog(BuildContext context, Feed feed) {
    // TODO: 수정 다이얼로그 구현 (v2)
  }

  Future<void> _confirmDelete(BuildContext context, String feedId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('게시물 삭제'),
        content: const Text('게시물을 삭제할까요? 삭제 후에는 복구할 수 없어요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('취소',
                style: TextStyle(color: AppColors.textGrey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('삭제',
                style: TextStyle(color: AppColors.softCoral)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      try {
        await ref
            .read(feedTimelineViewModelProvider.notifier)
            .deleteFeed(feedId);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('게시물 삭제에 실패했어요. 다시 시도해주세요.')),
          );
        }
      }
    }
  }

  Future<void> _confirmReport(
    BuildContext context,
    String feedId,
    String reporterId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('게시물 신고'),
        content: const Text('부적절한 내용으로 신고하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('취소',
                style: TextStyle(color: AppColors.textGrey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('신고'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      try {
        await ref.read(feedTimelineViewModelProvider.notifier).reportFeed(
              feedId: feedId,
              reporterId: reporterId,
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('신고가 접수되었어요.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('신고에 실패했어요. 다시 시도해주세요.')),
          );
        }
      }
    }
  }
}


// ─── 앱바 ─────────────────────────────────────────────────────────────────────

class _FeedAppBar extends StatelessWidget {
  const _FeedAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Text(
            '나눔',
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 필터 행 ──────────────────────────────────────────────────────────────────

class _FilterRow extends ConsumerWidget {
  final FeedFilter selected;

  const _FilterRow({required this.selected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: FeedFilter.values.map((f) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SoftChip(
              label: f.label,
              isSelected: selected == f,
              color: AppColors.softCoral,
              onTap: () =>
                  ref.read(selectedFeedFilterProvider.notifier).select(f),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── 스켈레톤 로딩 ────────────────────────────────────────────────────────────

class _SkeletonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => const SkeletonCard(height: 180),
    );
  }
}

// ─── 에러 뷰 ──────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message,
              style:
                  AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey)),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: Text('다시 시도',
                style: TextStyle(color: AppColors.softCoral)),
          ),
        ],
      ),
    );
  }
}
