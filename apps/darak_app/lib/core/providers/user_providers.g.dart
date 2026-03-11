// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserHash() => r'2863d6ea110e3de5194cc181f35609057624d290';

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
String _$isProfileCompleteHash() => r'7e99f2b606e4a40f26dbfae0b512a2e753c0b22f';

/// 현재 유저의 프로필이 완성되었는지 체크합니다.
/// 온보딩 완료 여부를 판단하는 기준으로 사용됩니다.
/// phone 필드가 비어있지 않으면 프로필이 완성된 것으로 간주합니다.
///
/// Copied from [isProfileComplete].
@ProviderFor(isProfileComplete)
final isProfileCompleteProvider = AutoDisposeProvider<bool>.internal(
  isProfileComplete,
  name: r'isProfileCompleteProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isProfileCompleteHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsProfileCompleteRef = AutoDisposeProviderRef<bool>;
String _$hasJoinedGroupHash() => r'dadc07fa2a34c7b56ce8754edf6ef55a7b93e67e';

/// 현재 유저가 그룹(다락방)에 가입했는지 체크합니다.
/// groupId 필드가 null이 아니면 그룹에 가입한 것으로 간주합니다.
///
/// Copied from [hasJoinedGroup].
@ProviderFor(hasJoinedGroup)
final hasJoinedGroupProvider = AutoDisposeProvider<bool>.internal(
  hasJoinedGroup,
  name: r'hasJoinedGroupProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasJoinedGroupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasJoinedGroupRef = AutoDisposeProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
