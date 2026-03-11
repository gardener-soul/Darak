import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common/bouncy_button.dart';
import '../../widgets/common/clay_card.dart';

/// 교회 등록 신청 완료 후 대기 화면.
/// 신청이 완료된 사실과 검토 안내 메시지를 표시합니다.
class ChurchPendingScreen extends StatelessWidget {
  const ChurchPendingScreen({super.key});

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
                const Text('⏳', style: TextStyle(fontSize: 80)),
                const SizedBox(height: 24),
                Text(
                  '등록 신청이 완료됐어요!',
                  style: AppTextStyles.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  '관리자 검토 후 승인됩니다.\n승인까지 영업일 기준 1~3일이 소요돼요.\n승인되면 교회 목록에서 찾아볼 수 있어요.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ClayCard(
                  color: AppColors.skyBlue.withValues(alpha: 0.2),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        color: AppColors.skyBlue,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '검토 중',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.skyBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                BouncyButton(
                  text: '홈으로 돌아가기',
                  icon: const Icon(Icons.home_rounded),
                  color: AppColors.softCoral,
                  onPressed: () {
                    // HomeScreen까지 스택을 모두 제거하고 이동
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
