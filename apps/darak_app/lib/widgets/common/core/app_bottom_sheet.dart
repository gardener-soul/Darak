import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// 앱 전역 바텀시트 공통 껍데기 (Phase 1 Core Component)
///
/// 모든 바텀시트는 이 위젯으로 감싸서 디자인 일관성을 보장합니다.
/// - 상단: 회색 핸들바 (40×4, borderRadius 2)
/// - 배경: creamWhite, 상단 모서리 곡률 32px
/// - 키보드 올라올 때 viewInsets 자동 패딩
/// - SingleChildScrollView로 RenderFlex Overflow 방어
///
/// 사용법:
/// ```dart
/// AppBottomSheet.show(
///   context: context,
///   child: YourContent(),
/// );
/// ```
class AppBottomSheet extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? contentPadding;

  const AppBottomSheet({
    super.key,
    required this.child,
    this.backgroundColor,
    this.contentPadding,
  });

  /// 바텀시트를 표시하는 정적 헬퍼 메서드
  ///
  /// [isScrollControlled]와 [backgroundColor: transparent]를 자동 설정하여
  /// 호출측에서 보일러플레이트를 반복하지 않도록 합니다.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    Color? backgroundColor,
    EdgeInsetsGeometry? contentPadding,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => AppBottomSheet(
        backgroundColor: backgroundColor,
        contentPadding: contentPadding,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.creamWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      // ⚠️ W-1 FIX: 키보드 SafeArea는 항상 적용, contentPadding은 콘텐츠 영역만 담당
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: contentPadding ?? const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── 핸들바 ──────────────────────────────────────────
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ─── 콘텐츠 ─────────────────────────────────────────
            child,
          ],
        ),
      ),
    );
  }
}
