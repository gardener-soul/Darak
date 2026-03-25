// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_list_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$followingListHash() => r'bfb98afcd035de0e2b3c4ff6dda3dcd12cbc727d';

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

/// 내가 팔로우 중인 목록 실시간 스트림
///
/// Copied from [followingList].
@ProviderFor(followingList)
const followingListProvider = FollowingListFamily();

/// 내가 팔로우 중인 목록 실시간 스트림
///
/// Copied from [followingList].
class FollowingListFamily extends Family<AsyncValue<List<Follow>>> {
  /// 내가 팔로우 중인 목록 실시간 스트림
  ///
  /// Copied from [followingList].
  const FollowingListFamily();

  /// 내가 팔로우 중인 목록 실시간 스트림
  ///
  /// Copied from [followingList].
  FollowingListProvider call(String userId) {
    return FollowingListProvider(userId);
  }

  @override
  FollowingListProvider getProviderOverride(
    covariant FollowingListProvider provider,
  ) {
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
  String? get name => r'followingListProvider';
}

/// 내가 팔로우 중인 목록 실시간 스트림
///
/// Copied from [followingList].
class FollowingListProvider extends AutoDisposeStreamProvider<List<Follow>> {
  /// 내가 팔로우 중인 목록 실시간 스트림
  ///
  /// Copied from [followingList].
  FollowingListProvider(String userId)
    : this._internal(
        (ref) => followingList(ref as FollowingListRef, userId),
        from: followingListProvider,
        name: r'followingListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$followingListHash,
        dependencies: FollowingListFamily._dependencies,
        allTransitiveDependencies:
            FollowingListFamily._allTransitiveDependencies,
        userId: userId,
      );

  FollowingListProvider._internal(
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
  Override overrideWith(
    Stream<List<Follow>> Function(FollowingListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FollowingListProvider._internal(
        (ref) => create(ref as FollowingListRef),
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
  AutoDisposeStreamProviderElement<List<Follow>> createElement() {
    return _FollowingListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FollowingListProvider && other.userId == userId;
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
mixin FollowingListRef on AutoDisposeStreamProviderRef<List<Follow>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _FollowingListProviderElement
    extends AutoDisposeStreamProviderElement<List<Follow>>
    with FollowingListRef {
  _FollowingListProviderElement(super.provider);

  @override
  String get userId => (origin as FollowingListProvider).userId;
}

String _$followerListHash() => r'4e1101c9ca132c0e0d7507c3a616acbd9ff10d54';

/// 나를 팔로우하는 목록 실시간 스트림
///
/// Copied from [followerList].
@ProviderFor(followerList)
const followerListProvider = FollowerListFamily();

/// 나를 팔로우하는 목록 실시간 스트림
///
/// Copied from [followerList].
class FollowerListFamily extends Family<AsyncValue<List<Follow>>> {
  /// 나를 팔로우하는 목록 실시간 스트림
  ///
  /// Copied from [followerList].
  const FollowerListFamily();

  /// 나를 팔로우하는 목록 실시간 스트림
  ///
  /// Copied from [followerList].
  FollowerListProvider call(String userId) {
    return FollowerListProvider(userId);
  }

  @override
  FollowerListProvider getProviderOverride(
    covariant FollowerListProvider provider,
  ) {
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
  String? get name => r'followerListProvider';
}

/// 나를 팔로우하는 목록 실시간 스트림
///
/// Copied from [followerList].
class FollowerListProvider extends AutoDisposeStreamProvider<List<Follow>> {
  /// 나를 팔로우하는 목록 실시간 스트림
  ///
  /// Copied from [followerList].
  FollowerListProvider(String userId)
    : this._internal(
        (ref) => followerList(ref as FollowerListRef, userId),
        from: followerListProvider,
        name: r'followerListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$followerListHash,
        dependencies: FollowerListFamily._dependencies,
        allTransitiveDependencies:
            FollowerListFamily._allTransitiveDependencies,
        userId: userId,
      );

  FollowerListProvider._internal(
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
  Override overrideWith(
    Stream<List<Follow>> Function(FollowerListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FollowerListProvider._internal(
        (ref) => create(ref as FollowerListRef),
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
  AutoDisposeStreamProviderElement<List<Follow>> createElement() {
    return _FollowerListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FollowerListProvider && other.userId == userId;
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
mixin FollowerListRef on AutoDisposeStreamProviderRef<List<Follow>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _FollowerListProviderElement
    extends AutoDisposeStreamProviderElement<List<Follow>>
    with FollowerListRef {
  _FollowerListProviderElement(super.provider);

  @override
  String get userId => (origin as FollowerListProvider).userId;
}

String _$followingIdsHash() => r'a1fb94fc12ad21b20dc8967157098d979da71faa';

/// 내가 팔로우 중인 사용자 ID 목록 실시간 스트림
///
/// Copied from [followingIds].
@ProviderFor(followingIds)
const followingIdsProvider = FollowingIdsFamily();

/// 내가 팔로우 중인 사용자 ID 목록 실시간 스트림
///
/// Copied from [followingIds].
class FollowingIdsFamily extends Family<AsyncValue<List<String>>> {
  /// 내가 팔로우 중인 사용자 ID 목록 실시간 스트림
  ///
  /// Copied from [followingIds].
  const FollowingIdsFamily();

  /// 내가 팔로우 중인 사용자 ID 목록 실시간 스트림
  ///
  /// Copied from [followingIds].
  FollowingIdsProvider call(String userId) {
    return FollowingIdsProvider(userId);
  }

  @override
  FollowingIdsProvider getProviderOverride(
    covariant FollowingIdsProvider provider,
  ) {
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
  String? get name => r'followingIdsProvider';
}

/// 내가 팔로우 중인 사용자 ID 목록 실시간 스트림
///
/// Copied from [followingIds].
class FollowingIdsProvider extends AutoDisposeStreamProvider<List<String>> {
  /// 내가 팔로우 중인 사용자 ID 목록 실시간 스트림
  ///
  /// Copied from [followingIds].
  FollowingIdsProvider(String userId)
    : this._internal(
        (ref) => followingIds(ref as FollowingIdsRef, userId),
        from: followingIdsProvider,
        name: r'followingIdsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$followingIdsHash,
        dependencies: FollowingIdsFamily._dependencies,
        allTransitiveDependencies:
            FollowingIdsFamily._allTransitiveDependencies,
        userId: userId,
      );

  FollowingIdsProvider._internal(
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
  Override overrideWith(
    Stream<List<String>> Function(FollowingIdsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FollowingIdsProvider._internal(
        (ref) => create(ref as FollowingIdsRef),
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
  AutoDisposeStreamProviderElement<List<String>> createElement() {
    return _FollowingIdsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FollowingIdsProvider && other.userId == userId;
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
mixin FollowingIdsRef on AutoDisposeStreamProviderRef<List<String>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _FollowingIdsProviderElement
    extends AutoDisposeStreamProviderElement<List<String>>
    with FollowingIdsRef {
  _FollowingIdsProviderElement(super.provider);

  @override
  String get userId => (origin as FollowingIdsProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
