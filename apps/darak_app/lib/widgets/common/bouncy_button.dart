import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class BouncyButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final Color? color;
  final Color? textColor;
  final bool isFullWidth;

  const BouncyButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.color,
    this.textColor,
    this.isFullWidth = true,
  });

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onPressed != null;
    final Color backgroundColor = isEnabled
        ? (widget.color ?? AppColors.softCoral)
        : AppColors.disabled;
    final Color contentColor = widget.textColor ?? Colors.white;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          width: widget.isFullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: AppDecorations.buttonRadius,
            boxShadow: isEnabled
                ? [
                    // 3D Effect: Darker shade at the bottom
                    BoxShadow(
                      color: Color.alphaBlend(
                        Colors.black.withOpacity(0.2),
                        backgroundColor,
                      ),
                      offset: const Offset(0, 6),
                      blurRadius: 0, // Solid shadow for "pop" effect
                    ),
                    // Soft drop shadow
                    BoxShadow(
                      color: backgroundColor.withOpacity(0.4),
                      offset: const Offset(0, 10),
                      blurRadius: 20,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: contentColor, size: 24),
                  child: widget.icon!,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: AppTextStyles.buttonLabel.copyWith(color: contentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
