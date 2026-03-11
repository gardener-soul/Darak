import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

/// 교회 미등록 유저에게 홈 스트릭 카드 아래 노출되는 배너.
/// [onTap]: 탭 시 실행 콜백 (일반적으로 ChurchListScreen으로 이동)
class ChurchNotRegisteredBanner extends StatelessWidget {
  final VoidCallback onTap;

  const ChurchNotRegisteredBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.skyBlue.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.skyBlue, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.church_rounded, color: AppColors.skyBlue),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '아직 교회가 등록되지 않았어요!',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.skyBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '지금 우리 교회를 찾아보세요',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.skyBlue,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.skyBlue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
