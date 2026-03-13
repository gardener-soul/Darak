import 'package:flutter/material.dart';

import '../../../models/group.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';

/// 다락방 상세 바텀시트
/// 다락방 이름 + 순장 정보 + 멤버 수 표시
/// 순장 전용: 멤버 초대 버튼 (v2 예정)
/// 관리자 전용: 순원 추가 버튼 (v2 예정)
class GroupDetailBottomSheet extends StatelessWidget {
  final Group group;
  final bool isAdmin;
  final bool isLeader;

  const GroupDetailBottomSheet({
    super.key,
    required this.group,
    required this.isAdmin,
    required this.isLeader,
  });

  /// 바텀시트를 표시하는 정적 헬퍼
  static Future<void> show(
    BuildContext context, {
    required Group group,
    required bool isAdmin,
    required bool isLeader,
  }) {
    return AppBottomSheet.show(
      context: context,
      child: GroupDetailBottomSheet(
        group: group,
        isAdmin: isAdmin,
        isLeader: isLeader,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final memberCount = group.memberIds?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(group.name, style: AppTextStyles.headlineMedium),
        const SizedBox(height: 20),
        _GroupLeaderInfo(leaderId: group.leaderId),
        const SizedBox(height: 16),
        _MemberCountRow(memberCount: memberCount),
        if (isLeader || isAdmin) ...[
          const SizedBox(height: 20),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 16),
          _GroupActionButtons(
            isAdmin: isAdmin,
            isLeader: isLeader,
            onInviteTap: () => _showComingSoon(context, '멤버 초대'),
            onAddMemberTap: () => _showComingSoon(context, '순원 추가'),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature 기능은 v2에서 구현 예정입니다.')),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _GroupLeaderInfo extends StatelessWidget {
  final String? leaderId;

  const _GroupLeaderInfo({required this.leaderId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.star_rounded,
          size: 18,
          color: AppColors.warmTangerine,
        ),
        const SizedBox(width: 8),
        Text('순장', style: AppTextStyles.bodySmall),
        const SizedBox(width: 8),
        Text(
          leaderId != null ? '등록됨' : '순장 없음',
          style: AppTextStyles.bodyMedium.copyWith(
            color: leaderId != null ? AppColors.textDark : AppColors.textGrey,
          ),
        ),
      ],
    );
  }
}

class _MemberCountRow extends StatelessWidget {
  final int memberCount;

  const _MemberCountRow({required this.memberCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.people_rounded,
          size: 18,
          color: AppColors.sageGreen,
        ),
        const SizedBox(width: 8),
        Text('멤버', style: AppTextStyles.bodySmall),
        const SizedBox(width: 8),
        Text(
          '$memberCount명',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}

class _GroupActionButtons extends StatelessWidget {
  final bool isAdmin;
  final bool isLeader;
  final VoidCallback onInviteTap;
  final VoidCallback onAddMemberTap;

  const _GroupActionButtons({
    required this.isAdmin,
    required this.isLeader,
    required this.onInviteTap,
    required this.onAddMemberTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLeader)
          _ActionTile(
            icon: Icons.person_add_rounded,
            label: '멤버 초대',
            color: AppColors.skyBlue,
            onTap: onInviteTap,
          ),
        if (isAdmin) ...[
          if (isLeader) const SizedBox(height: 8),
          _ActionTile(
            icon: Icons.group_add_rounded,
            label: '순원 추가',
            color: AppColors.softCoral,
            onTap: onAddMemberTap,
          ),
        ],
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
