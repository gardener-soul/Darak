import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class ClayCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const ClayCard({
    super.key,
    required this.child,
    this.color,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color ?? AppColors.pureWhite, // Cards usually white on cream bg
        borderRadius: borderRadius ?? AppDecorations.cardRadius,
        boxShadow: AppDecorations.clayShadow,
      ),
      child: child,
    );
  }
}
