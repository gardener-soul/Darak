import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/bouncy_button.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';

/// 앱 첫 진입 시 보여주는 환영 화면
/// "Soft Pop & Claymorphism" 디자인 적용
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // ─── Header Illustration ─────────────────────────────
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  shape: BoxShape.circle,
                  boxShadow: AppDecorations.floatingShadow,
                ),
                child: const Icon(
                  Icons.church_rounded,
                  size: 80,
                  color: AppColors.softCoral,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Darak',
                style: AppTextStyles.headlineLarge.copyWith(
                  fontSize: 48,
                  color: AppColors.softCoral,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '공동체를 위한 따뜻한 연결',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textGrey,
                ),
              ),

              const Spacer(flex: 2),

              // ─── Feature Icons (Simple & Cute) ───────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CuteFeatureIcon(
                    icon: Icons.check_circle_rounded,
                    label: '출석',
                    color: AppColors.sageGreen,
                  ),
                  _CuteFeatureIcon(
                    icon: Icons.menu_book_rounded,
                    label: '말씀',
                    color: AppColors.warmTangerine,
                  ),
                  _CuteFeatureIcon(
                    icon: Icons.people_rounded,
                    label: '다락방',
                    color: AppColors.skyBlue,
                  ),
                ],
              ),

              const Spacer(flex: 3),

              // ─── Action Buttons ──────────────────────────────────

              // 1. Preview Mode
              BouncyButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(isPreview: true),
                    ),
                  );
                },
                text: '다락 둘러보기',
                color: AppColors.softLavender,
                textColor: AppColors.textDark,
                icon: const Icon(
                  Icons.visibility_rounded,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),

              // 2. Login / Sign Up
              BouncyButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                text: '로그인 / 시작하기',
                color: AppColors.softCoral,
                textColor: Colors.white,
                icon: const Icon(Icons.login_rounded, color: Colors.white),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class _CuteFeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _CuteFeatureIcon({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, size: 32, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
