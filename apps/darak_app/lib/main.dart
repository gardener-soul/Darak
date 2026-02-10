import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/providers/firebase_providers.dart';
import 'views/home/home_screen.dart';
import 'views/welcome/welcome_screen.dart';

/// 앱 엔트리포인트
/// Firebase 초기화 후 Riverpod의 ProviderScope로 앱 전체를 감싸서 상태 관리 활성화
void main() async {
  // Flutter 엔진과 위젯 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: DarakApp()));
}

/// Darak 앱의 루트 위젯
class DarakApp extends ConsumerWidget {
  const DarakApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),

        // 카드 테마
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // 입력 필드 테마
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),

        // 버튼 테마
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

/// 인증 상태에 따라 화면 분기
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        // 로그인 O → 홈 화면
        if (user != null) {
          return const HomeScreen();
        }
        // 로그인 X → 환영 화면 (미리보기 / 로그인 선택)
        return const WelcomeScreen();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('오류: $error'))),
    );
  }
}
