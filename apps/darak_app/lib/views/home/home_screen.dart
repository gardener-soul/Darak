import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/firebase_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/clay_card.dart';
import '../../widgets/common/bouncy_button.dart';

/// 홈 화면 (로그인 후 메인 화면 또는 미리보기 모드)
class HomeScreen extends ConsumerWidget {
  /// true이면 미리보기 모드 (로그인 없이 둘러보기)
  final bool isPreview;

  const HomeScreen({super.key, this.isPreview = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Current user can be null in preview mode
    final user = ref.watch(firebaseAuthProvider).currentUser;
    final userName = user?.displayName ?? '친구';

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      const Icon(
                        Icons.info_rounded,
                        color: AppColors.softCoral,
                      ),
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
                childAspectRatio: 0.85, // Adjust for card height
                children: [
                  _BentoCard(
                    title: '출석 체크',
                    subtitle: '주일 예배 출석',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.sageGreen,
                    onTap: () {
                      // Navigate or Action
                    },
                    isLocked: isPreview,
                  ),
                  _BentoCard(
                    title: '오늘의 말씀',
                    subtitle: '매일 성경 QT',
                    icon: Icons.menu_book_rounded,
                    color: AppColors.skyBlue,
                    onTap: () {},
                    isLocked: isPreview,
                  ),
                  _BentoCard(
                    title: '공동체',
                    subtitle: '우리 다락방',
                    icon: Icons.people_rounded,
                    color: AppColors.softLavender,
                    onTap: () {},
                    isLocked: isPreview,
                  ),
                  _BentoCard(
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

              // ─── Logout Button (If logged in) ─────────────────────────────
              if (!isPreview)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: BouncyButton(
                    onPressed: () async {
                      final auth = ref.read(firebaseAuthProvider);
                      await auth.signOut();
                    },
                    text: '로그아웃',
                    color: AppColors.disabled,
                    textColor: AppColors.textGrey,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BentoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isLocked;
  final bool isDark;
  final Color? textColor;

  const _BentoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isLocked = false,
    this.isDark = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor =
        textColor ?? (isDark ? Colors.white : AppColors.textDark);
    final effectiveSubtitleColor = isDark
        ? Colors.white.withOpacity(0.8)
        : AppColors.textGrey;

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: ClayCard(
        color: color,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isDark ? Colors.white : AppColors.textDark,
                    size: 24,
                  ),
                ),
                if (isLocked)
                  Icon(
                    Icons.lock_rounded,
                    color: isDark ? Colors.white54 : Colors.black26,
                    size: 20,
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: effectiveTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: effectiveSubtitleColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
