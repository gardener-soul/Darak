import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 로딩 화면 (클레이모피즘 스타일)
/// Firebase 데이터를 기다리는 동안 표시됩니다.
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: AppDecorations.cardRadius,
                boxShadow: AppDecorations.clayShadow,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.softCoral),
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '잠시만 기다려주세요...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
