import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';

class HomeBentoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isLocked;
  final bool isDark;
  final Color? textColor;

  const HomeBentoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isLocked = false,
    this.isDark = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor =
        textColor ?? (isDark ? Colors.white : AppColors.textDark);
    final effectiveSubtitleColor = isDark
        ? Colors.white.withOpacity(0.8)
        : AppColors.textGrey;

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: ClayCard(
        color: color,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isDark ? Colors.white : AppColors.textDark,
                    size: 24,
                  ),
                ),
                if (isLocked)
                  Icon(
                    Icons.lock_rounded,
                    color: isDark ? Colors.white54 : Colors.black26,
                    size: 20,
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: effectiveTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: effectiveSubtitleColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
