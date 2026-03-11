import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// 젤리틱한 소프트 다이얼로그 (Phase 1 Core Component)
///
/// 기존 `AlertDialog`를 직접 조립하던 패턴을 대체합니다.
/// - 모서리 곡률: 32px (DESIGN.md cardRadius 동일)
/// - 배경: creamWhite
/// - 디자인 토큰 기반 타이포그래피 자동 적용
///
/// 사용법:
/// ```dart
/// final result = await SoftDialog.show<bool>(
///   context: context,
///   title: '로그아웃',
///   content: '정말 로그아웃 하시겠어요?',
///   actions: [
///     SoftDialogAction(label: '취소', onPressed: () => Navigator.pop(context, false)),
///     SoftDialogAction(label: '로그아웃', isDestructive: true, onPressed: () => Navigator.pop(context, true)),
///   ],
/// );
/// ```
class SoftDialog extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? contentWidget;
  final List<SoftDialogAction> actions;
  final Color? backgroundColor;
  final String? semanticLabel;

  const SoftDialog({
    super.key,
    required this.title,
    this.content,
    this.contentWidget,
    this.actions = const [],
    this.backgroundColor,
    this.semanticLabel,
  }) : assert(
         content != null || contentWidget != null,
         'content 또는 contentWidget 중 하나는 반드시 제공해야 합니다.',
       );

  /// 다이얼로그를 표시하는 정적 헬퍼 메서드
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? content,
    Widget? contentWidget,
    List<SoftDialogAction> actions = const [],
    Color? backgroundColor,
    String? semanticLabel,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => SoftDialog(
        title: title,
        content: content,
        contentWidget: contentWidget,
        actions: actions,
        backgroundColor: backgroundColor,
        semanticLabel: semanticLabel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      semanticLabel: semanticLabel,
      shape: RoundedRectangleBorder(
        borderRadius: AppDecorations.cardRadius, // 32px
      ),
      backgroundColor: backgroundColor ?? AppColors.creamWhite,
      title: Text(title, style: AppTextStyles.headlineMedium),
      // 🚨 W-2 FIX: Release 빌드에서 assert 무시 시에도 null 크래시 방지
      content:
          contentWidget ?? Text(content ?? '', style: AppTextStyles.bodyMedium),
      actions: actions
          .map(
            (action) => TextButton(
              onPressed: action.onPressed,
              child: Text(
                action.label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: action.isDestructive
                      ? AppColors.softCoral
                      : AppColors.textGrey,
                  fontWeight: action.isDestructive
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

/// SoftDialog에서 사용하는 액션 버튼 데이터 객체
///
/// `isDestructive`가 true이면 Coral 색상 + Bold 스타일이 적용됩니다.
class SoftDialogAction {
  final String label;
  final VoidCallback? onPressed;
  final bool isDestructive;

  const SoftDialogAction({
    required this.label,
    this.onPressed,
    this.isDestructive = false,
  });
}
