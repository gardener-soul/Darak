import 'package:flutter/material.dart';

import '../../../models/church_member.dart';
import '../../../models/village_with_groups.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import 'group_create_bottom_sheet.dart';
import 'group_tree_tile.dart';
import 'village_attendance_sheet.dart';

/// 마을 트리 타일 위젯
/// ExpansionTile 형태로 마을 하위에 다락방 목록 표시
/// 내 마을 여부에 따라 강조 테두리 적용
class VillageTreeTile extends StatelessWidget {
  final String churchId;
  final VillageWithGroups villageWithGroups;
  final ChurchMember? currentMember;
  final bool isAdmin;
  final int currentUserRoleLevel;

  const VillageTreeTile({
    super.key,
    required this.churchId,
    required this.villageWithGroups,
    required this.currentMember,
    required this.isAdmin,
    required this.currentUserRoleLevel,
  });

  bool get _isMyVillage =>
      currentMember?.villageId == villageWithGroups.village.id;

  /// 순장(roleLevel >= 2) 이상이면 다락방 추가 가능
  bool get _canAddGroup => isAdmin || currentUserRoleLevel >= 2;

  /// 마을장(roleLevel >= 3) 이상이면 출석 현황 조회 가능
  bool get _canViewAttendance => isAdmin || currentUserRoleLevel >= 3;

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
        subtitle: Row(
          children: [
            Text(
              '다락방 ${groups.length}개',
              style: AppTextStyles.bodySmall,
            ),
            if (_canViewAttendance) ...[
              const SizedBox(width: 8),
              BouncyTapWrapper(
                onTap: () => VillageAttendanceSheet.show(
                  context,
                  villageWithGroups: villageWithGroups,
                  churchId: churchId,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AttendanceColors.present.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: AttendanceColors.present.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.bar_chart_rounded,
                        size: 12,
                        color: AttendanceColors.present,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '출석 현황',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AttendanceColors.present,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        children: [
          ...groups.map(
            (g) => GroupTreeTile(
              churchId: churchId,
              group: g,
              currentMember: currentMember,
              isAdmin: isAdmin,
            ),
          ),
          if (_canAddGroup)
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

// ──────────────────────────────────────────────────────────────────────────────

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
        ),
      ),
    );
  }
}
