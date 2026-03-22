import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/firebase_providers.dart';
import '../../models/church_detail_state.dart';
import '../../models/church_member.dart';
import '../../repositories/church_member_repository.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/church/church_detail_viewmodel.dart';
import 'church_manage_screen.dart';
import 'tabs/church_home_tab.dart';
import 'tabs/church_members_tab.dart';
import 'tabs/church_community_tab.dart';
import 'tabs/church_schedule_tab.dart';

/// 교회 상세 페이지 (4탭 구조)
/// 진입 경로: 홈 > 공동체 벤토 카드 / 행사/일정 벤토 카드
class ChurchDetailScreen extends ConsumerWidget {
  final String churchId;
  final int initialTabIndex;

  const ChurchDetailScreen({
    super.key,
    required this.churchId,
    this.initialTabIndex = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(churchDetailViewModelProvider(churchId));

    return state.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => _ChurchDetailErrorView(error: e),
      data: (detail) => _ChurchDetailBody(
        churchId: churchId,
        initialTabIndex: initialTabIndex,
        detail: detail,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Private Widgets
// ──────────────────────────────────────────────────────────────────────────────

class _ChurchDetailErrorView extends StatelessWidget {
  final Object error;

  const _ChurchDetailErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.textGrey,
              ),
              const SizedBox(height: 16),
              const Text('오류가 발생했습니다.', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 8),
              Text(
                error.toString().replaceAll(RegExp(r'^Exception:\s*'), ''),
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChurchDetailBody extends ConsumerWidget {
  final String churchId;
  final int initialTabIndex;
  final ChurchDetailState detail;

  const _ChurchDetailBody({
    required this.churchId,
    required this.initialTabIndex,
    required this.detail,
  });

  Future<void> _leaveChurch(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('교회 탈퇴'),
        content: const Text('정말 이 교회에서 탈퇴하시겠어요?\n(테스트용)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('탈퇴', style: TextStyle(color: AppColors.softCoral)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final uid = ref.read(firebaseAuthProvider).currentUser?.uid;
    if (uid == null) return;
    try {
      await ref
          .read(churchMemberRepositoryProvider)
          .leaveChurch(churchId: churchId, userId: uid);
      if (context.mounted) Navigator.of(context).pop();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll(RegExp(r'^Exception:\s*'), ''))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChurchMember? currentMember = detail.currentMember;
    final bool isAdmin = detail.isAdmin;

    return DefaultTabController(
      length: 4,
      initialIndex: initialTabIndex,
      child: Scaffold(
        backgroundColor: AppColors.creamWhite,
        appBar: AppBar(
          backgroundColor: AppColors.creamWhite,
          elevation: 0,
          title: Text(detail.church.name, style: AppTextStyles.headlineMedium),
          actions: [
            if (isAdmin)
              IconButton(
                icon: const Icon(Icons.settings_rounded),
                color: AppColors.textDark,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChurchManageScreen(churchId: churchId),
                  ),
                ),
              ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, color: AppColors.textDark),
              onSelected: (value) {
                if (value == 'leave') _leaveChurch(context, ref);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'leave',
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded, color: AppColors.softCoral, size: 18),
                      SizedBox(width: 8),
                      Text('교회 탈퇴', style: TextStyle(color: AppColors.softCoral)),
                    ],
                  ),
                ),
              ],
            ),
          ],
          bottom: const _ChurchDetailTabBar(),
        ),
        body: TabBarView(
          children: [
            ChurchHomeTab(churchId: churchId, church: detail.church),
            ChurchMembersTab(
              churchId: churchId,
              currentMember: currentMember,
            ),
            ChurchCommunityTab(
              churchId: churchId,
              currentMember: currentMember,
              isAdmin: isAdmin,
            ),
            ChurchScheduleTab(churchId: churchId),
          ],
        ),
      ),
    );
  }
}

class _ChurchDetailTabBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _ChurchDetailTabBar();

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.softCoral.withValues(alpha: 0.12),
      ),
      dividerColor: Colors.transparent,
      labelColor: AppColors.softCoral,
      unselectedLabelColor: AppColors.textGrey,
      labelStyle: AppTextStyles.bodySmall.copyWith(
        fontWeight: FontWeight.w600,
      ),
      tabs: const [
        Tab(text: '홈'),
        Tab(text: '구성원'),
        Tab(text: '공동체'),
        Tab(text: '일정'),
      ],
    );
  }
}
