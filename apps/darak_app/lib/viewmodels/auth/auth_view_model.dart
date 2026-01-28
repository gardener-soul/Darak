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

  // 회원가입
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final authService = ref.read(authServiceProvider);
      await authService.signUp(
        email: email,
        password: password,
        name: name,
        phone: phone,
      );
    });

    return !state.hasError;
  }

  // 로그아웃
  Future<void> signOut() async {
    final authService = ref.read(authServiceProvider);
    await authService.signOut();
  }
}
