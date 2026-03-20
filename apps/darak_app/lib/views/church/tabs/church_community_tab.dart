import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/church_member.dart';
import '../../../models/village_with_groups.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/church/church_community_viewmodel.dart';
import '../../../viewmodels/church/church_roles_provider.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../widgets/village_create_bottom_sheet.dart';
import '../widgets/village_tree_tile.dart';

/// 교회 상세 - 공동체 탭
/// 마을 > 다락방 트리 구조를 ExpansionTile로 표시
class ChurchCommunityTab extends ConsumerWidget {
  final String churchId;
  final ChurchMember? currentMember;
  final bool isAdmin;

  const ChurchCommunityTab({
    super.key,
    required this.churchId,
    required this.currentMember,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communityAsync =
        ref.watch(churchCommunityViewModelProvider(churchId));
    final rolesAsync = ref.watch(churchRolesProvider(churchId));

    // 현재 유저의 roleLevel 계산: roles 목록에서 currentMember.roleId에 해당하는 level 조회
    final roles = rolesAsync.valueOrNull ?? [];
    final currentUserRoleLevel = roles
            .where((r) => r.id == currentMember?.roleId)
            .firstOrNull
            ?.level ??
        1;

    return communityAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.softCoral),
      ),
      error: (e, _) => Center(
        child: Text(
          '공동체 정보를 불러오지 못했어요.',
          style: AppTextStyles.bodySmall,
        ),
      ),
      data: (villages) => _CommunityBody(
        churchId: churchId,
        villages: villages,
        currentMember: currentMember,
        isAdmin: isAdmin,
        currentUserRoleLevel: currentUserRoleLevel,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _CommunityBody extends StatelessWidget {
  final String churchId;
  final List<VillageWithGroups> villages;
  final ChurchMember? currentMember;
  final bool isAdmin;
  final int currentUserRoleLevel;

  const _CommunityBody({
    required this.churchId,
    required this.villages,
    required this.currentMember,
    required this.isAdmin,
    required this.currentUserRoleLevel,
  });

  @override
  Widget build(BuildContext context) {
    if (villages.isEmpty) {
      return _EmptyCommunityState(
        isAdmin: isAdmin,
        onCreateVillageTap: () =>
            VillageCreateBottomSheet.show(context, churchId),
      );
    }

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          itemCount: villages.length,
          itemBuilder: (ctx, i) => VillageTreeTile(
            churchId: churchId,
            villageWithGroups: villages[i],
            currentMember: currentMember,
            isAdmin: isAdmin,
            currentUserRoleLevel: currentUserRoleLevel,
          ),
        ),
        if (isAdmin)
          Positioned(
            right: 20,
            bottom: 24,
            child: BouncyButton(
              text: '마을 만들기',
              icon: const Icon(Icons.add_rounded),
              isFullWidth: false,
              onPressed: () => VillageCreateBottomSheet.show(context, churchId),
            ),
          ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _EmptyCommunityState extends StatelessWidget {
  final bool isAdmin;
  final VoidCallback onCreateVillageTap;

  const _EmptyCommunityState({
    required this.isAdmin,
    required this.onCreateVillageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.holiday_village_rounded,
              size: 56,
              color: AppColors.textGrey,
            ),
            const SizedBox(height: 16),
            const Text(
              '아직 마을이 없습니다',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isAdmin ? '첫 번째 마을을 만들어보세요!' : '관리자가 마을을 생성하면 표시됩니다.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (isAdmin) ...[
              const SizedBox(height: 24),
              BouncyButton(
                text: '마을 만들기',
                icon: const Icon(Icons.add_rounded),
                isFullWidth: false,
                onPressed: onCreateVillageTap,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
