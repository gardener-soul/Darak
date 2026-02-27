import 'package:flutter/material.dart';

/// 쫀득한 바운싱 탭 래퍼 (MYPAGE_PLAN §6.3)
///
/// 모든 터치 가능한 요소에 감싸서 사용할 수 있는 범용 위젯입니다.
/// - TapDown: 0.95배율로 살짝 찌그러짐 (ScaleDown)
/// - TapUp: 원래 크기로 돌아오는 스프링 애니메이션 (Bouncing)
/// - Duration: 150ms, Curve: Curves.easeOutBack
class BouncyTapWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;

  const BouncyTapWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.95,
  });

  @override
  State<BouncyTapWrapper> createState() => _BouncyTapWrapperState();
}

class _BouncyTapWrapperState extends State<BouncyTapWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleDown,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        // §6.3: easeOutBack으로 쫀득한 스프링 느낌
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // 🚨 CRITICAL FIX: 투명 배경 클릭 씹힘 방지
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
