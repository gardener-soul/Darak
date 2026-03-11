import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// 온보딩 슬라이드의 개별 페이지 위젯
class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color? iconColor;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),

          // 아이콘 컨테이너 (클레이모피즘)
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: AppDecorations.cardRadius,
              boxShadow: AppDecorations.clayShadow,
            ),
            child: Icon(
              icon,
              size: 80,
              color: iconColor ?? AppColors.softCoral,
            ),
          ),

          const SizedBox(height: 48),

          // 제목
          Text(
            title,
            style: AppTextStyles.headlineLarge,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // 설명
          Text(
            description,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textGrey,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
