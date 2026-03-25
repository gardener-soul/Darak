// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'47d5184b12d4fe2a7cb896a833c7a4e42f3163ec';

/// Firestore `users` 컬렉션 전담 Repository
/// UI 레이어는 이 Repository를 통해서만 유저 데이터에 접근해야 합니다.
///
/// Copied from [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = AutoDisposeProvider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRepositoryRef = AutoDisposeProviderRef<UserRepository>;
String _$userByIdHash() => r'79a611680107a2dc47bcaaa3c9af9eaa6ad568c4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// userId로 User 정보를 조회하는 Provider.
/// 멤버 목록 표시 시 각 userId의 사용자 정보를 로드하는 데 사용합니다.
///
/// Copied from [userById].
@ProviderFor(userById)
const userByIdProvider = UserByIdFamily();

/// userId로 User 정보를 조회하는 Provider.
/// 멤버 목록 표시 시 각 userId의 사용자 정보를 로드하는 데 사용합니다.
///
/// Copied from [userById].
class UserByIdFamily extends Family<AsyncValue<User?>> {
  /// userId로 User 정보를 조회하는 Provider.
  /// 멤버 목록 표시 시 각 userId의 사용자 정보를 로드하는 데 사용합니다.
  ///
  /// Copied from [userById].
  const UserByIdFamily();

  /// userId로 User 정보를 조회하는 Provider.
  /// 멤버 목록 표시 시 각 userId의 사용자 정보를 로드하는 데 사용합니다.
  ///
  /// Copied from [userById].
  UserByIdProvider call(String userId) {
    return UserByIdProvider(userId);
  }

  @override
  UserByIdProvider getProviderOverride(covariant UserByIdProvider provider) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userByIdProvider';
}

/// userId로 User 정보를 조회하는 Provider.
/// 멤버 목록 표시 시 각 userId의 사용자 정보를 로드하는 데 사용합니다.
///
/// Copied from [userById].
class UserByIdProvider extends AutoDisposeFutureProvider<User?> {
  /// userId로 User 정보를 조회하는 Provider.
  /// 멤버 목록 표시 시 각 userId의 사용자 정보를 로드하는 데 사용합니다.
  ///
  /// Copied from [userById].
  UserByIdProvider(String userId)
    : this._internal(
        (ref) => userById(ref as UserByIdRef, userId),
        from: userByIdProvider,
        name: r'userByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userByIdHash,
        dependencies: UserByIdFamily._dependencies,
        allTransitiveDependencies: UserByIdFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(FutureOr<User?> Function(UserByIdRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: UserByIdProvider._internal(
        (ref) => create(ref as UserByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<User?> createElement() {
    return _UserByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserByIdProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserByIdRef on AutoDisposeFutureProviderRef<User?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserByIdProviderElement extends AutoDisposeFutureProviderElement<User?>
    with UserByIdRef {
  _UserByIdProviderElement(super.provider);

  @override
  String get userId => (origin as UserByIdProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
