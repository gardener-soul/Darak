import 'package:flutter/material.dart';

import '../auth/login_screen.dart';
import '../home/home_screen.dart';

/// 앱 첫 진입 시 보여주는 환영 화면
/// 로그인 없이도 미리보기가 가능하도록 두 가지 경로를 제공
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // 앱 로고 & 타이틀
              Icon(Icons.church, size: 100, color: colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                'Darak',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '당신의 모든 완전한 나눔',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              Text(
                '교회 공동체를 위한 출석, 소그룹, 행사 관리 앱',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // 기능 하이라이트 (간단한 아이콘 Row)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _FeatureIcon(
                    icon: Icons.check_circle_outline,
                    label: '출석',
                    color: colorScheme.primary,
                  ),
                  _FeatureIcon(
                    icon: Icons.menu_book,
                    label: '경건',
                    color: colorScheme.primary,
                  ),
                  _FeatureIcon(
                    icon: Icons.people,
                    label: '공동체',
                    color: colorScheme.primary,
                  ),
                  _FeatureIcon(
                    icon: Icons.event,
                    label: '행사',
                    color: colorScheme.primary,
                  ),
                ],
              ),

              const Spacer(flex: 1),

              // 미리보기 버튼
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(isPreview: true),
                      ),
                    );
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('미리보기'),
                ),
              ),
              const SizedBox(height: 12),

              // 로그인 버튼
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('로그인'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

/// 기능 아이콘 위젯 (환영 화면용)
class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _FeatureIcon({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 28, color: color),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }
}
