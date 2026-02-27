import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../bouncy_tap_wrapper.dart';

/// 바운시 아이콘 버튼 크기 Variant
enum IconBtnSize {
  /// 작은 아이콘 버튼 (32px)
  small(32, 16),

  /// 중간 아이콘 버튼 (40px)
  medium(40, 22),

  /// 큰 아이콘 버튼 (48px)
  large(48, 26);

  const IconBtnSize(this.containerSize, this.iconSize);

  /// 컨테이너 전체 크기
  final double containerSize;

  /// 아이콘 렌더링 크기
  final double iconSize;
}

/// 쫀득한 바운싱 아이콘 버튼 (Phase 2 Core Component)
///
/// `BouncyTapWrapper`로 감싸 터치 시 스프링 애니메이션을 적용하고,
/// 선택적으로 파스텔 톤의 원형 배경 배지를 표시합니다.
///
/// 사용법:
/// ```dart
/// BouncyIconBtn(
///   icon: Icons.edit_rounded,
///   color: AppColors.softCoral,
///   onTap: () => print('tapped'),
/// )
/// ```
class BouncyIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final IconBtnSize size;
  final bool showBackground;
  final String? tooltip;

  const BouncyIconBtn({
    super.key,
    required this.icon,
    this.onTap,
    this.color,
    this.size = IconBtnSize.medium,
    this.showBackground = true,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.softCoral;

    Widget iconWidget = Container(
      width: size.containerSize,
      height: size.containerSize,
      decoration: showBackground
          ? BoxDecoration(
              color: effectiveColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(size.containerSize / 2.8),
            )
          : null,
      alignment: Alignment.center,
      child: Icon(icon, color: effectiveColor, size: size.iconSize),
    );

    // ⚠️ W-1 FIX: Material 가이드라인 최소 터치 타겟 48px 보장
    iconWidget = ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      child: iconWidget,
    );

    // 툴팁이 있으면 Tooltip으로 감싸기
    if (tooltip != null) {
      iconWidget = Tooltip(message: tooltip!, child: iconWidget);
    }

    return BouncyTapWrapper(onTap: onTap, child: iconWidget);
  }
}
