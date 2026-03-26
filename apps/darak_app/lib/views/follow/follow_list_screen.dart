import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/user_providers.dart';
import '../../models/follow/follow.dart';
import '../../models/user.dart';
import '../../repositories/user_repository.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/follow/follow_list_viewmodel.dart';
import '../../widgets/common/core/clay_avatar.dart';
import '../../widgets/common/core/soft_chip.dart';
import '../../widgets/common/core/soft_dialog.dart';
import '../../widgets/common/empty_state_view.dart';
import '../../widgets/common/bouncy_button.dart';
import '../church/member_detail_screen.dart';

/// 팔로잉 / 팔로워 목록 화면
///
/// [initialTab] : 0 = 팔로잉, 1 = 팔로워
class FollowListScreen extends ConsumerStatefulWidget {
  final int initialTab;

  const FollowListScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends ConsumerState<FollowListScreen> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab.clamp(0, 1);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.softCoral),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      appBar: AppBar(
        title: const Text('팔로우'),
        backgroundColor: AppColors.creamWhite,
      ),
      body: Column(
        children: [
          // ─── 탭 칩 ────────────────────────────────────────────────
          _TabChips(
            selectedTab: _selectedTab,
            onTabChanged: (tab) => setState(() => _selectedTab = tab),
          ),
          const SizedBox(height: 8),

          // ─── 목록 ─────────────────────────────────────────────────
          Expanded(
            child: _selectedTab == 0
                ? _FollowingTab(currentUserId: currentUser.id)
                : _FollowerTab(currentUserId: currentUser.id),
          ),
        ],
      ),
    );
  }
}

// ─── 탭 칩 ───────────────────────────────────────────────────────────────────

class _TabChips extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const _TabChips({
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          SoftChip(
            label: '팔로잉',
            color: AppColors.softCoral,
            isSelected: selectedTab == 0,
            onTap: () => onTabChanged(0),
          ),
          const SizedBox(width: 8),
          SoftChip(
            label: '팔로워',
            color: AppColors.softCoral,
            isSelected: selectedTab == 1,
            onTap: () => onTabChanged(1),
          ),
        ],
      ),
    );
  }
}

// ─── 팔로잉 탭 ───────────────────────────────────────────────────────────────

class _FollowingTab extends ConsumerWidget {
  final String currentUserId;

  const _FollowingTab({required this.currentUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followingAsync = ref.watch(followingListProvider(currentUserId));

    return followingAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.softCoral),
      ),
      error: (_, __) => const EmptyStateView(
        icon: Icons.wifi_off_rounded,
        message: '목록을 불러오지 못했어요',
        subMessage: '네트워크 연결을 확인해주세요',
      ),
      data: (follows) {
        if (follows.isEmpty) {
          return const EmptyStateView(
            icon: Icons.person_add_rounded,
            message: '팔로우 중인 교인이 없어요',
            subMessage: '교인 찾기에서 팔로우해보세요',
          );
        }
        return _FollowingList(
          follows: follows,
          currentUserId: currentUserId,
        );
      },
    );
  }
}

class _FollowingList extends ConsumerWidget {
  final List<Follow> follows;
  final String currentUserId;

  const _FollowingList({
    required this.follows,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      itemCount: follows.length,
      separatorBuilder: (context, index) => const Divider(
        color: AppColors.divider,
        height: 1,
        indent: 56,
      ),
      itemBuilder: (context, i) {
        final follow = follows[i];
        return _FollowingItem(
          follow: follow,
          currentUserId: currentUserId,
        );
      },
    );
  }
}

class _FollowingItem extends ConsumerWidget {
  final Follow follow;
  final String currentUserId;

  const _FollowingItem({
    required this.follow,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByIdProvider(follow.followeeId));
    final User? user = userAsync.valueOrNull;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // 아바타+이름 영역 탭 시 상대 프로필로 이동
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).push(
                MemberDetailScreen.route(follow.followeeId),
              ),
              child: Row(
                children: [
                  ClayAvatar(
                    imageUrl: user?.profileImageUrl,
                    size: AvatarSize.small,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? '로딩 중...',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (user?.groupName != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            user?.groupName ?? '',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          BouncyButton(
            text: '팔로우 취소',
            isFullWidth: false,
            color: AppColors.softCoral,
            onPressed: () => _onCancelTap(context, ref, user?.name ?? ''),
          ),
        ],
      ),
    );
  }

  Future<void> _onCancelTap(
    BuildContext context,
    WidgetRef ref,
    String name,
  ) async {
    final confirmed = await SoftDialog.show<bool>(
      context: context,
      title: '팔로우 취소',
      content: '$name님 팔로우를 취소하시겠어요?',
      actions: [
        SoftDialogAction(
          label: '유지',
          onPressed: () => Navigator.pop(context, false),
        ),
        SoftDialogAction(
          label: '취소',
          isDestructive: true,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(followListViewModelProvider.notifier).cancelFollow(
            followerId: currentUserId,
            followeeId: follow.followeeId,
          );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('팔로우 취소에 실패했어요. 다시 시도해주세요.')),
        );
      }
    }
  }
}

// ─── 팔로워 탭 ───────────────────────────────────────────────────────────────

class _FollowerTab extends ConsumerWidget {
  final String currentUserId;

  const _FollowerTab({required this.currentUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followerAsync = ref.watch(followerListProvider(currentUserId));

    return followerAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.softCoral),
      ),
      error: (_, __) => const EmptyStateView(
        icon: Icons.wifi_off_rounded,
        message: '목록을 불러오지 못했어요',
        subMessage: '네트워크 연결을 확인해주세요',
      ),
      data: (follows) {
        if (follows.isEmpty) {
          return const EmptyStateView(
            icon: Icons.people_outline_rounded,
            message: '아직 팔로워가 없어요',
            subMessage: '교인들이 팔로우하면 여기 표시됩니다',
          );
        }
        return _FollowerList(
          follows: follows,
          currentUserId: currentUserId,
        );
      },
    );
  }
}

class _FollowerList extends ConsumerWidget {
  final List<Follow> follows;
  final String currentUserId;

  const _FollowerList({
    required this.follows,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      itemCount: follows.length,
      separatorBuilder: (context, index) => const Divider(
        color: AppColors.divider,
        height: 1,
        indent: 56,
      ),
      itemBuilder: (context, i) {
        final follow = follows[i];
        return _FollowerItem(
          follow: follow,
          currentUserId: currentUserId,
        );
      },
    );
  }
}

class _FollowerItem extends ConsumerWidget {
  final Follow follow;
  final String currentUserId;

  const _FollowerItem({
    required this.follow,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByIdProvider(follow.followerId));
    final User? user = userAsync.valueOrNull;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // 아바타+이름 영역 탭 시 상대 프로필로 이동
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).push(
                MemberDetailScreen.route(follow.followerId),
              ),
              child: Row(
                children: [
                  ClayAvatar(
                    imageUrl: user?.profileImageUrl,
                    size: AvatarSize.small,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? '로딩 중...',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (user?.groupName != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            user?.groupName ?? '',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          BouncyButton(
            text: '삭제',
            isFullWidth: false,
            color: AppColors.textGrey,
            onPressed: () => _onRemoveTap(context, ref, user?.name ?? ''),
          ),
        ],
      ),
    );
  }

  Future<void> _onRemoveTap(
    BuildContext context,
    WidgetRef ref,
    String name,
  ) async {
    final confirmed = await SoftDialog.show<bool>(
      context: context,
      title: '팔로워 삭제',
      content: '$name님을 팔로워 목록에서 삭제하시겠어요?',
      actions: [
        SoftDialogAction(
          label: '취소',
          onPressed: () => Navigator.pop(context, false),
        ),
        SoftDialogAction(
          label: '삭제',
          isDestructive: true,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(followListViewModelProvider.notifier).removeFollower(
            followerId: follow.followerId,
            followeeId: currentUserId,
          );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('팔로워 삭제에 실패했어요. 다시 시도해주세요.')),
        );
      }
    }
  }
}
