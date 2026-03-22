import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/empty_state_view.dart';

/// 순원 상세 화면 - 기도 제목 섹션
/// prayerRequests 배열을 읽기 전용으로 표시합니다.
class MemberPrayerCard extends StatelessWidget {
  final List<String> prayerRequests;

  const MemberPrayerCard({super.key, required this.prayerRequests});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        Row(
          children: [
            const Icon(
              Icons.volunteer_activism_rounded,
              color: AppColors.softCoral,
              size: 22,
            ),
            const SizedBox(width: 8),
            const Text('기도 제목', style: AppTextStyles.bodyLarge),
          ],
        ),
        const SizedBox(height: 12),

        if (prayerRequests.isEmpty)
          ClayCard(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            child: EmptyStateView(
              icon: Icons.volunteer_activism_rounded,
              message: '등록된 기도 제목이 없어요',
              iconColor: AppColors.disabled,
            ),
          )
        else
          ClayCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(prayerRequests.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: i < prayerRequests.length - 1 ? 16 : 0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 번호 뱃지
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: AppColors.softCoral.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${i + 1}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.softCoral,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          prayerRequests[i],
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
