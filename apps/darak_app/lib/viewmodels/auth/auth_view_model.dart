import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../services/auth_service.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  FutureOr<void> build() {
    // 초기 상태: 아무것도 하지 않음
  }

  /// 회원가입
  /// 성공 시 Firebase Auth 상태 변경으로 AuthWrapper가 자동으로 홈 화면으로 전환
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    state = const AsyncLoading();

    try {
      final authService = ref.read(authServiceProvider);

      // 10초 타임아웃 적용
      await authService
          .signUp(email: email, password: password, name: name, phone: phone)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('요청 시간이 초과되었습니다.'),
          );

      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  /// 로그인
  Future<bool> signIn({required String email, required String password}) async {
    state = const AsyncLoading();

    try {
      final authService = ref.read(authServiceProvider);

      // 10초 타임아웃 적용
      await authService
          .signIn(email: email, password: password)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('요청 시간이 초과되었습니다.'),
          );

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  /// 구글 로그인
  Future<bool> signInWithGoogle() async {
    state = const AsyncLoading();

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle();

      // 성공 시 로딩 상태 해제 (중요!)
      // AuthWrapper가 화면을 전환하겠지만, 현재 화면의 로딩 스피너를 끄기 위해 상태 초기화
      state = const AsyncData(null);

      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    final authService = ref.read(authServiceProvider);
    await authService.signOut();
  }
}
