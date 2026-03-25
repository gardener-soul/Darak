import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/common/bouncy_button.dart';

/// 피드 타임라인 빈 상태 안내 위젯
class FeedEmptyState extends StatelessWidget {
  final VoidCallback? onCreateTap;

  const FeedEmptyState({super.key, this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌱', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              '아직 나눔이 없어요',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '첫 번째 나눔을 시작해보세요!\n여러분의 이야기가 공동체를 따뜻하게 합니다',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            if (onCreateTap != null) ...[
              const SizedBox(height: 28),
              BouncyButton(
                onPressed: onCreateTap,
                text: '나눔 시작하기',
                color: AppColors.softCoral,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
