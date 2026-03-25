import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 교회 내 역할을 시각적으로 표시하는 배지 위젯
///
/// [roleLevel] 1: 순원, 2: 순장, 3: 마을장, 4: 사역자
/// [roleName] 교회별 커스텀 역할명 지원
/// [isAdmin] true이면 관리자 스타일 (softCoral 계열)
class RoleBadge extends StatelessWidget {
  final int roleLevel;
  final String roleName;
  final bool isAdmin;

  const RoleBadge({
    super.key,
    required this.roleLevel,
    required this.roleName,
    this.isAdmin = false,
  });

  Color get _badgeColor {
    if (isAdmin) return AppColors.softCoral;
    switch (roleLevel) {
      case 4:
        return AppColors.softLavender;
      case 3:
        return AppColors.sageGreen;
      case 2:
        return AppColors.skyBlue;
      default:
        return AppColors.divider;
    }
  }

  Color get _textColor {
    if (isAdmin) return AppColors.roleAdminText;
    switch (roleLevel) {
      case 4:
        return AppColors.roleMinisterText;
      case 3:
        return AppColors.roleVillageLeaderText;
      case 2:
        return AppColors.roleGroupLeaderText;
      default:
        return AppColors.textGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _badgeColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _badgeColor, width: 1),
      ),
      child: Text(
        roleName,
        style: AppTextStyles.bodySmall.copyWith(
          color: _textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
