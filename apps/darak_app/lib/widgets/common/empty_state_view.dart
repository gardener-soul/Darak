import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'bouncy_button.dart';

/// 빈 상태(Empty State)를 표시하는 통합 위젯
///
/// 모든 목록에서 데이터가 없을 때 일관된 UX를 제공합니다.
/// [onAction] 콜백이 제공되면 하단에 CTA 버튼을 표시합니다.
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? subMessage;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.message,
    this.subMessage,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: iconColor ?? AppColors.textGrey,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            if (subMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                subMessage!,
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              BouncyButton(
                text: actionLabel!,
                onPressed: onAction,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
