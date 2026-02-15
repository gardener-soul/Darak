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
      await authService.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
      // 성공 → AuthWrapper가 화면 전환 → 이 Provider가 dispose될 수 있음
      // dispose 후 state 접근 방지
      return true;
    } catch (e, st) {
      // 에러 시에만 상태 업데이트 (화면이 아직 살아있으므로 안전)
      state = AsyncError(e, st);
      return false;
    }
  }

  /// 로그인
  /// 성공 시 Firebase Auth 상태 변경으로 AuthWrapper가 자동으로 홈 화면으로 전환
  Future<bool> signIn({required String email, required String password}) async {
    state = const AsyncLoading();

    try {
      final authService = ref.read(authServiceProvider);
      await authService.signIn(email: email, password: password);
      // 성공 시 로딩 상태 해제
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
