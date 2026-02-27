import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/user.dart';
import '../../repositories/user_repository.dart';
import 'firebase_providers.dart';

part 'user_providers.g.dart';

/// 현재 로그인된 유저의 Firestore User 데이터를 실시간 구독하는 Provider.
///
/// Firebase Auth의 uid를 기반으로 Firestore `users/{uid}` 문서를 스트림으로 watch합니다.
/// 마이페이지를 포함한 모든 화면에서 이 Provider를 watch하면
/// 매번 Firestore API를 호출(get())하지 않고 메모리 캐시된 User 객체를 사용합니다.
///
/// 로그아웃 시 Firebase Auth 상태가 null이 되면 자동으로 null을 반환합니다.
@riverpod
Stream<User?> currentUser(Ref ref) {
  // 🚨 CRITICAL FIX: FirebaseAuth 인스턴스가 아닌, 인증 상태 '스트림' 자체를 구독해야 함
  final authState = ref.watch(authStateChangesProvider);

  return authState.when(
    data: (firebaseUser) {
      if (firebaseUser == null) {
        // 로그아웃 상태이므로 null 스트림 반환 (구독 해제 효과)
        return Stream.value(null);
      }
      // 로그인 상태이므로 Firestore에서 해당 유저의 문서 실시간 구독
      final repository = ref.watch(userRepositoryProvider);
      return repository.watchUser(firebaseUser.uid);
    },
    // 로딩 또는 에러 상태일 땐 null 처리하여 UI가 에러/로딩 화면을 띄울 수 있게 함
    loading: () => Stream.value(null),
    error: (err, stack) => Stream.value(null),
  );
}

/// 현재 유저의 uid를 간편하게 가져오는 Provider.
/// null이면 비로그인 상태입니다.
@riverpod
String? currentUserId(Ref ref) {
  return ref.watch(authStateChangesProvider).valueOrNull?.uid;
}
