import 'package:flutter/material.dart';

import '../../../models/church_member.dart';
import '../../../models/group.dart';
import '../../../theme/app_theme.dart';
import 'group_detail_bottom_sheet.dart';

/// 다락방 트리 타일 위젯
/// 마을(VillageTreeTile) 하위에 표시되는 개별 다락방 항목
/// 내 다락방 여부 및 순장 여부에 따라 배지/색상 강조
class GroupTreeTile extends StatelessWidget {
  final String churchId;
  final Group group;
  final ChurchMember? currentMember;
  final bool isAdmin;

  const GroupTreeTile({
    super.key,
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
        churchId: churchId,
        isAdmin: isAdmin,
        isLeader: _isLeader,
        currentMember: currentMember,
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
                color:
                    _isMyGroup ? AppColors.warmTangerine : AppColors.skyBlue,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(group.name, style: AppTextStyles.bodyMedium),
            ),
            if (_isMyGroup)
              const _MyGroupBadge(),
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

// ──────────────────────────────────────────────────────────────────────────────

class _MyGroupBadge extends StatelessWidget {
  const _MyGroupBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.warmTangerine.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        '내 다락방',
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.warmTangerine,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
