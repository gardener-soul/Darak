import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../bouncy_tap_wrapper.dart';

/// 파스텔 톤 소프트 칩 (Phase 2 Core Component)
///
/// 카테고리, 태그, 상태를 표시할 때 사용하는 둥근 Pill 형태의 칩입니다.
/// - 선택 상태(`isSelected`)에 따라 채움(Fill) ↔ 외곽선(Outline) 토글
/// - `onTap`이 주어지면 `BouncyTapWrapper`로 감싸 터치 인터랙션 제공
/// - `icon`으로 앞쪽에 소형 아이콘 첨부 가능
///
/// 사용법:
/// ```dart
/// SoftChip(
///   label: '출석부',
///   color: AppColors.sageGreen,
///   icon: Icons.check_circle_rounded,
///   isSelected: true,
///   onTap: () => ...,
/// )
/// ```
class SoftChip extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isSelected;

  const SoftChip({
    super.key,
    required this.label,
    this.color,
    this.icon,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.softCoral;

    // 선택 상태에 따라 스타일 분기
    final chipBackgroundColor = isSelected
        ? effectiveColor.withValues(alpha: 0.2)
        : Colors.transparent;
    final chipBorderColor = effectiveColor.withValues(alpha: 0.4);
    final chipTextColor = isSelected ? effectiveColor : AppColors.textGrey;

    final chipContent = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: chipBackgroundColor,
        borderRadius: BorderRadius.circular(100), // Pill shape
        border: Border.all(color: chipBorderColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: chipTextColor, size: 16),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: chipTextColor,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );

    // onTap이 있으면 BouncyTapWrapper로 래핑하여 터치 인터랙션 제공
    if (onTap != null) {
      return BouncyTapWrapper(
        onTap: onTap,
        scaleDown: 0.92, // 칩은 작으므로 좀 더 과감한 스케일다운
        child: chipContent,
      );
    }

    return chipContent;
  }
}
