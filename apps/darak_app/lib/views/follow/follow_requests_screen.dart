import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/user_providers.dart';
import '../../models/follow/follow.dart';
import '../../models/user.dart';
import '../../repositories/user_repository.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/follow/follow_request_viewmodel.dart';
import '../../widgets/common/empty_state_view.dart';
import '../../widgets/common/core/soft_dialog.dart';
import 'widgets/follow_request_card.dart';

/// 나에게 온 팔로우 요청 목록 화면
class FollowRequestsScreen extends ConsumerWidget {
  const FollowRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.softCoral)),
      );
    }

    final requestsAsync = ref.watch(
      pendingFollowRequestsProvider(currentUser.id),
    );

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      appBar: AppBar(
        title: const Text('팔로우 요청'),
        backgroundColor: AppColors.creamWhite,
      ),
      body: requestsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.softCoral),
        ),
        error: (_, __) => const EmptyStateView(
          icon: Icons.wifi_off_rounded,
          message: '요청 목록을 불러오지 못했어요',
          subMessage: '네트워크 연결을 확인해주세요',
        ),
        data: (requests) {
          if (requests.isEmpty) {
            return const EmptyStateView(
              icon: Icons.mark_email_read_rounded,
              message: '새로운 팔로우 요청이 없어요',
              subMessage: '받은 팔로우 요청이 여기 표시됩니다',
            );
          }
          return _RequestList(requests: requests);
        },
      ),
    );
  }
}

class _RequestList extends ConsumerWidget {
  final List<Follow> requests;

  const _RequestList({required this.requests});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      itemCount: requests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final follow = requests[i];
        return _RequestItem(follow: follow);
      },
    );
  }
}

class _RequestItem extends ConsumerWidget {
  final Follow follow;

  const _RequestItem({required this.follow});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requesterAsync = ref.watch(userByIdProvider(follow.followerId));
    final User? requester = requesterAsync.valueOrNull;

    return FollowRequestCard(
      follow: follow,
      requester: requester,
      onAccept: () => _onAccept(context, ref, follow),
      onReject: () => _onReject(context, ref, follow),
    );
  }

  Future<void> _onAccept(
    BuildContext context,
    WidgetRef ref,
    Follow follow,
  ) async {
    try {
      await ref
          .read(followRequestViewModelProvider.notifier)
          .acceptRequest(followId: follow.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('팔로우 요청을 수락했어요'),
            backgroundColor: AppColors.sageGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('수락에 실패했어요. 다시 시도해주세요.')),
        );
      }
    }
  }

  Future<void> _onReject(
    BuildContext context,
    WidgetRef ref,
    Follow follow,
  ) async {
    // 거절은 되돌릴 수 없으므로 확인 다이얼로그로 의도 재확인
    final requester = ref.read(userByIdProvider(follow.followerId)).valueOrNull;
    final requesterName = requester?.name ?? '상대방';

    final confirmed = await SoftDialog.show<bool>(
      context: context,
      title: '팔로우 요청 거절',
      content: '$requesterName님의 팔로우 요청을 거절하시겠어요?',
      barrierDismissible: false,
      actions: [
        SoftDialogAction(
          label: '취소',
          onPressed: () => Navigator.pop(context, false),
        ),
        SoftDialogAction(
          label: '거절',
          isDestructive: true,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(followRequestViewModelProvider.notifier)
          .rejectRequest(followId: follow.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('팔로우 요청을 거절했어요'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('거절에 실패했어요. 다시 시도해주세요.')),
        );
      }
    }
  }
}
