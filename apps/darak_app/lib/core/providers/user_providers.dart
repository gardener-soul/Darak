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

/// 현재 유저의 프로필이 완성되었는지 체크합니다.
/// 온보딩 완료 여부를 판단하는 기준으로 사용됩니다.
/// phone 필드가 비어있지 않으면 프로필이 완성된 것으로 간주합니다.
@riverpod
bool isProfileComplete(Ref ref) {
  final userAsync = ref.watch(currentUserProvider);

  return userAsync.when(
    data: (user) {
      if (user == null) return false;
      // phone 필드가 비어있지 않으면 프로필 완성으로 간주
      return user.phone.isNotEmpty;
    },
    loading: () => false,
    error: (_, _) => false,
  );
}

/// 현재 유저가 그룹(다락방)에 가입했는지 체크합니다.
/// groupId 필드가 null이 아니면 그룹에 가입한 것으로 간주합니다.
@riverpod
bool hasJoinedGroup(Ref ref) {
  final userAsync = ref.watch(currentUserProvider);

  return userAsync.when(
    data: (user) {
      if (user == null) return false;
      // groupId가 null이 아니면 그룹 가입 완료
      return user.groupId != null;
    },
    loading: () => false,
    error: (_, _) => false,
  );
}
