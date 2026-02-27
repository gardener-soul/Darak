import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';

/// 마이페이지 메뉴 아이템 타일 (MYPAGE_PLAN §6.3)
///
/// 기존 `InkWell` 기본 Ripple 대신 `BouncyTapWrapper`로 감싸
/// 쫀득한 스프링 애니메이션(0.95배 → 복귀)을 적용합니다.
class UserMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;
  final bool isDestructive;
  final bool isLoading;

  const UserMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
    this.isDestructive = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDestructive ? AppColors.softCoral : AppColors.textDark;

    return BouncyTapWrapper(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            // 아이콘 배지
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            // 타이틀 & 서브타이틀
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            // 화살표 or 로딩
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.softCoral,
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.textGrey.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }
}
