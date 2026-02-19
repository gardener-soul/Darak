import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../auth/verification_waiting_screen.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';
import 'home_bento_card.dart';

class HomeDashboard extends StatelessWidget {
  final User? user;
  final String userName;
  final bool isPreview;

  const HomeDashboard({
    super.key,
    required this.user,
    required this.userName,
    this.isPreview = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(), // 미세한 바운스 효과 제거
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header Section ───────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '반가워요, $userName! 👋',
                    style: AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text('오늘도 은혜로운 하루 되세요', style: AppTextStyles.bodySmall),
                ],
              ),
              CircleAvatar(
                radius: 24,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                backgroundColor: AppColors.sageGreen,
                child: user?.photoURL == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ─── Email Verification Banner ──────────────────────────────
          if (user != null && !user!.emailVerified)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const VerificationWaitingScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warmTangerine.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.warmTangerine),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.mark_email_unread_rounded,
                          color: AppColors.warmTangerine,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '이메일 인증이 필요해요! 📧',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.warmTangerine,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '눌러서 인증을 완료해주세요',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.warmTangerine,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: AppColors.warmTangerine,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // ─── Preview Mode Banner ─────────────────────────────────────
          if (isPreview)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.softCoral.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.softCoral),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_rounded, color: AppColors.softCoral),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '미리보기 모드입니다. 로그인하고 모든 기능을 누려보세요!',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.softCoral,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ─── Spirituality Streak (Top Feature) ────────────────────────
          ClayCard(
            color: AppColors.warmTangerine,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '영성 스트릭 3일째 🔥',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '말씀 묵상으로 하루를 시작했어요',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ─── Bento Grid Layout for Features ───────────────────────────
          Text('내 활동', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            // childAspectRatio를 0.85 -> 1.1로 변경하여 높이를 줄임 (더 납작하게)
            childAspectRatio: 1.1,
            children: [
              HomeBentoCard(
                title: '출석 체크',
                subtitle: '주일 예배 출석',
                icon: Icons.check_circle_rounded,
                color: AppColors.sageGreen,
                onTap: () {
                  // Navigate or Action
                },
                isLocked: isPreview,
              ),
              HomeBentoCard(
                title: '오늘의 말씀',
                subtitle: '매일 성경 QT',
                icon: Icons.menu_book_rounded,
                color: AppColors.skyBlue,
                onTap: () {},
                isLocked: isPreview,
              ),
              HomeBentoCard(
                title: '공동체',
                subtitle: '우리 다락방',
                icon: Icons.people_rounded,
                color: AppColors.softLavender,
                onTap: () {},
                isLocked: isPreview,
              ),
              HomeBentoCard(
                title: '행사/일정',
                subtitle: '교회 주요 행사',
                icon: Icons.calendar_month_rounded,
                color: AppColors.softCoral, // Accent
                textColor: Colors.white,
                isDark: true,
                onTap: () {},
                isLocked: isPreview,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
