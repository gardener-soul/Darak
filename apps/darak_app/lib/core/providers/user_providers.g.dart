// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserHash() => r'32c8fd65dfdbaa14e2c7b7ccb7e2b9146e074f8c';

/// 현재 로그인된 유저의 Firestore User 데이터를 실시간 구독하는 Provider.
///
/// Firebase Auth의 uid를 기반으로 Firestore `users/{uid}` 문서를 스트림으로 watch합니다.
/// 마이페이지를 포함한 모든 화면에서 이 Provider를 watch하면
/// 매번 Firestore API를 호출(get())하지 않고 메모리 캐시된 User 객체를 사용합니다.
///
/// 로그아웃 시 Firebase Auth 상태가 null이 되면 자동으로 null을 반환합니다.
///
/// Copied from [currentUser].
@ProviderFor(currentUser)
final currentUserProvider = AutoDisposeStreamProvider<User?>.internal(
  currentUser,
  name: r'currentUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserRef = AutoDisposeStreamProviderRef<User?>;
String _$currentUserIdHash() => r'70bb641758ac66083db7faf1da6e0427402334b9';

/// 현재 유저의 uid를 간편하게 가져오는 Provider.
/// null이면 비로그인 상태입니다.
///
/// Copied from [currentUserId].
@ProviderFor(currentUserId)
final currentUserIdProvider = AutoDisposeProvider<String?>.internal(
  currentUserId,
  name: r'currentUserIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUserIdRef = AutoDisposeProviderRef<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
