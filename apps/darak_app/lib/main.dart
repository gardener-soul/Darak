import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/providers/firebase_providers.dart';
import 'core/providers/user_providers.dart';
import 'views/home/home_screen.dart';
import 'views/welcome/welcome_screen.dart';
import 'views/onboarding/onboarding_screen.dart';
import 'views/common/loading_screen.dart';
import 'views/common/error_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: DarakApp()));
}

class DarakApp extends ConsumerWidget {
  const DarakApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Darak',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
      home: const AuthWrapper(),
    );
  }
}

/// 인증 상태 및 온보딩 상태에 따라 화면 분기
///
/// 분기 로직:
/// 1. Firebase Auth가 null → WelcomeScreen (로그인 필요)
/// 2. Firestore User 문서 로딩 중 → LoadingScreen
/// 3. User 프로필 미완성 (phone 빈 문자열) → OnboardingScreen
/// 4. 모든 조건 충족 → HomeScreen
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (firebaseUser) {
        // 1. 비로그인 상태
        if (firebaseUser == null) {
          return const WelcomeScreen();
        }

        // 2. Firestore User 문서 구독
        final userAsync = ref.watch(currentUserProvider);

        return userAsync.when(
          data: (user) {
            // 2-1. Firestore 문서가 없는 신규 사용자 → 온보딩으로 진입
            if (user == null) {
              return const OnboardingScreen();
            }

            // 2-2. 프로필 미완성 → 온보딩 시작
            if (user.phone.isEmpty) {
              return const OnboardingScreen();
            }

            // 2-3. 모든 조건 충족 → 홈 화면
            return const HomeScreen();
          },
          loading: () => const LoadingScreen(),
          error: (error, stack) => ErrorScreen(
            error: error,
            onRetry: () {
              // Provider 재시작 (invalidate)
              ref.invalidate(currentUserProvider);
            },
          ),
        );
      },
      loading: () => const LoadingScreen(),
      error: (error, stack) => ErrorScreen(
        error: error,
        onRetry: () {
          ref.invalidate(authStateChangesProvider);
        },
      ),
    );
  }
}
