import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/bouncy_button.dart';

/// 에러 화면
/// 데이터 로딩 실패 시 표시되며, 재시도 버튼을 제공합니다.
class ErrorScreen extends StatelessWidget {
  final Object? error;
  final VoidCallback? onRetry;

  const ErrorScreen({
    super.key,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite,
                    borderRadius: AppDecorations.cardRadius,
                    boxShadow: AppDecorations.clayShadow,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: AppColors.softCoral,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  '앗, 문제가 발생했어요',
                  style: AppTextStyles.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  error?.toString() ?? '알 수 없는 오류가 발생했습니다.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                if (onRetry != null)
                  BouncyButton(
                    onPressed: onRetry,
                    text: '다시 시도',
                    icon: const Icon(Icons.refresh_rounded),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
