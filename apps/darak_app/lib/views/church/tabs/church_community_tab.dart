import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/church_member.dart';
import '../../../models/group.dart';
import '../../../models/village_with_groups.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/church/church_community_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../widgets/group_create_bottom_sheet.dart';
import '../widgets/group_detail_bottom_sheet.dart';
import '../widgets/village_create_bottom_sheet.dart';

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

  const _CommunityBody({
    required this.churchId,
    required this.villages,
    required this.currentMember,
    required this.isAdmin,
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
          itemBuilder: (ctx, i) => _VillageTile(
            churchId: churchId,
            villageWithGroups: villages[i],
            currentMember: currentMember,
            isAdmin: isAdmin,
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

class _VillageTile extends StatelessWidget {
  final String churchId;
  final VillageWithGroups villageWithGroups;
  final ChurchMember? currentMember;
  final bool isAdmin;

  const _VillageTile({
    required this.churchId,
    required this.villageWithGroups,
    required this.currentMember,
    required this.isAdmin,
  });

  bool get _isMyVillage =>
      currentMember?.villageId == villageWithGroups.village.id;

  @override
  Widget build(BuildContext context) {
    final village = villageWithGroups.village;
    final groups = villageWithGroups.groups;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.pureWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: _isMyVillage
              ? AppColors.softCoral.withValues(alpha: 0.5)
              : AppColors.divider,
          width: _isMyVillage ? 2 : 1,
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _VillageLeadingIcon(isMyVillage: _isMyVillage),
        title: Row(
          children: [
            Text(village.name, style: AppTextStyles.bodyMedium),
            if (_isMyVillage) ...[
              const SizedBox(width: 8),
              const _MyBadge(label: '내 마을', color: AppColors.softCoral),
            ],
          ],
        ),
        subtitle: Text(
          '다락방 ${groups.length}개',
          style: AppTextStyles.bodySmall,
        ),
        children: [
          ...groups.map(
            (g) => _GroupListTile(
              churchId: churchId,
              group: g,
              currentMember: currentMember,
              isAdmin: isAdmin,
            ),
          ),
          if (isAdmin || _isMyVillage)
            _AddGroupTile(
              onTap: () => GroupCreateBottomSheet.show(
                context,
                churchId: churchId,
                villageId: village.id,
              ),
            ),
        ],
      ),
    );
  }
}

class _VillageLeadingIcon extends StatelessWidget {
  final bool isMyVillage;

  const _VillageLeadingIcon({required this.isMyVillage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isMyVillage
            ? AppColors.softCoral.withValues(alpha: 0.15)
            : AppColors.sageGreen.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.location_city_rounded,
        color: isMyVillage ? AppColors.softCoral : AppColors.sageGreen,
        size: 22,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _GroupListTile extends StatelessWidget {
  final String churchId;
  final Group group;
  final ChurchMember? currentMember;
  final bool isAdmin;

  const _GroupListTile({
    required this.churchId,
    required this.group,
    required this.currentMember,
    required this.isAdmin,
  });

  bool get _isMyGroup => currentMember?.groupId == group.id;
  bool get _isLeader => currentMember?.userId == group.leaderId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => GroupDetailBottomSheet.show(
        context,
        group: group,
        isAdmin: isAdmin,
        isLeader: _isLeader,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _isMyGroup
                    ? AppColors.warmTangerine.withValues(alpha: 0.15)
                    : AppColors.skyBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.groups_rounded,
                color: _isMyGroup
                    ? AppColors.warmTangerine
                    : AppColors.skyBlue,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(group.name, style: AppTextStyles.bodyMedium),
            ),
            if (_isMyGroup)
              const _MyBadge(label: '내 다락방', color: AppColors.warmTangerine),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textGrey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddGroupTile extends StatelessWidget {
  final VoidCallback onTap;

  const _AddGroupTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.divider.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: AppColors.textGrey,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '다락방 추가',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _MyBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _MyBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

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
