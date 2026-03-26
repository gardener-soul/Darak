import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/user_providers.dart';
import '../../models/feed/feed.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/feed/feed_timeline_viewmodel.dart';
import '../../viewmodels/follow/follow_list_viewmodel.dart';
import '../../widgets/common/bouncy_button.dart';
import '../../widgets/common/bouncy_tap_wrapper.dart';
import '../../widgets/common/core/app_bottom_sheet.dart';
import '../../widgets/common/core/soft_chip.dart';
import '../../widgets/common/skeleton_card.dart';
import '../../widgets/common/soft_text_field.dart';
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
            // 앱바 (우측 상단 + 버튼 포함)
            _FeedAppBar(onCreateTap: _openCreateSheet),

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
                              ? () => _showEditSheet(feed)
                              : null,
                          onDelete: feed.userId == user.id
                              ? () => _confirmDelete(feed.id)
                              : null,
                          onReport: feed.userId != user.id
                              ? () => _confirmReport(feed.id, user.id)
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

  void _showEditSheet(Feed feed) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FeedEditSheet(
        feed: feed,
        onUpdate: (newText) async {
          await ref
              .read(feedTimelineViewModelProvider.notifier)
              .updateFeedText(feedId: feed.id, text: newText);
        },
      ),
    );
  }

  Future<void> _confirmDelete(String feedId) async {
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

  Future<void> _confirmReport(String feedId, String reporterId) async {
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
  final VoidCallback onCreateTap;

  const _FeedAppBar({required this.onCreateTap});

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
          const Spacer(),
          BouncyTapWrapper(
            onTap: onCreateTap,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.softCoral,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_rounded,
                color: AppColors.pureWhite,
                size: 20,
              ),
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

// ─── 피드 수정 시트 ────────────────────────────────────────────────────────────

class _FeedEditSheet extends StatefulWidget {
  final Feed feed;
  final Future<void> Function(String text) onUpdate;

  const _FeedEditSheet({required this.feed, required this.onUpdate});

  @override
  State<_FeedEditSheet> createState() => _FeedEditSheetState();
}

class _FeedEditSheetState extends State<_FeedEditSheet> {
  late final TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.feed.text ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await widget.onUpdate(text);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('나눔이 수정되었어요.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('수정에 실패했어요. 다시 시도해주세요.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나눔 수정',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          SoftTextField(
            controller: _controller,
            hintText: '내용을 수정해주세요 (최대 500자)',
            maxLines: 5,
            maxLength: 500,
          ),
          const SizedBox(height: 16),
          BouncyButton(
            onPressed: _isLoading ? null : _submit,
            text: _isLoading ? '저장 중...' : '저장',
            color: AppColors.softCoral,
          ),
        ],
      ),
    );
  }
}
