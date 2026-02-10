import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/firebase_providers.dart';

/// 홈 화면 (로그인 후 메인 화면 또는 미리보기 모드)
class HomeScreen extends ConsumerWidget {
  /// true이면 미리보기 모드 (로그인 없이 둘러보기)
  final bool isPreview;

  const HomeScreen({super.key, this.isPreview = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Darak'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (!isPreview)
            // 로그인 상태: 로그아웃 버튼
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final auth = ref.read(firebaseAuthProvider);
                await auth.signOut();
              },
              tooltip: '로그아웃',
            ),
        ],
      ),
      // 미리보기 모드일 때 상단에 안내 배너
      body: Column(
        children: [
          if (isPreview)
            MaterialBanner(
              content: const Text('미리보기 모드입니다. 로그인하면 모든 기능을 사용할 수 있어요!'),
              leading: const Icon(Icons.info_outline),
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: 0.5),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('돌아가기'),
                ),
              ],
            ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 교회 아이콘
                    Icon(
                      Icons.church,
                      size: 120,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 32),

                    // 앱 타이틀
                    const Text(
                      '교회 공동체 관리 앱',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 환영 메시지
                    Text(
                      isPreview
                          ? '이런 기능들을 사용할 수 있어요!'
                          : 'Darak 앱에 오신 것을 환영합니다!',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 48),

                    // 기능 소개 카드들
                    _FeatureCard(
                      icon: Icons.check_circle_outline,
                      title: '출석 체크',
                      description: '주일 예배, 다락방 모임 출석 관리',
                      isLocked: isPreview,
                    ),
                    const SizedBox(height: 16),
                    _FeatureCard(
                      icon: Icons.menu_book,
                      title: '경건 생활',
                      description: '말씀, 기도, QT 기록',
                      isLocked: isPreview,
                    ),
                    const SizedBox(height: 16),
                    _FeatureCard(
                      icon: Icons.people,
                      title: '공동체 관리',
                      description: '순원 관리 및 특이사항 기록',
                      isLocked: isPreview,
                    ),
                    const SizedBox(height: 16),
                    _FeatureCard(
                      icon: Icons.event,
                      title: '행사/알림',
                      description: '수련회, 경조사, 카풀 매칭',
                      isLocked: isPreview,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 기능 소개 카드 위젯
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isLocked;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // 아이콘
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),

            // 텍스트 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // 미리보기 모드에서 잠금 아이콘 표시
            if (isLocked)
              Icon(Icons.lock_outline, size: 20, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
