import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

/// 앱 엔트리포인트
/// Firebase 초기화 후 Riverpod의 ProviderScope로 앱 전체를 감싸서 상태 관리 활성화
void main() async {
  // Flutter 엔진과 위젯 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: DarakApp(),
    ),
  );
}

/// Darak 앱의 루트 위젯
class DarakApp extends StatelessWidget {
  const DarakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Darak - 교회 공동체 관리',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Material 3 디자인 시스템 사용
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,

        // 앱바 테마
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),

        // 카드 테마
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

/// 홈 화면
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Darak'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
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
                'Darak 앱에 오신 것을 환영합니다!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 48),

              // 기능 소개 카드들
              _FeatureCard(
                icon: Icons.check_circle_outline,
                title: '출석 체크',
                description: '주일 예배, 다락방 모임 출석 관리',
              ),
              const SizedBox(height: 16),
              _FeatureCard(
                icon: Icons.menu_book,
                title: '경건 생활',
                description: '말씀, 기도, QT 기록',
              ),
              const SizedBox(height: 16),
              _FeatureCard(
                icon: Icons.people,
                title: '공동체 관리',
                description: '순원 관리 및 특이사항 기록',
              ),
              const SizedBox(height: 16),
              _FeatureCard(
                icon: Icons.event,
                title: '행사/알림',
                description: '수련회, 경조사, 카풀 매칭',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 기능 소개 카드 위젯
class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // 아이콘
            Icon(
              icon,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
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
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
