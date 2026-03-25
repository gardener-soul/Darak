// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_prayer_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$communityPrayerListHash() =>
    r'8cdb9b8f7a352d235e83eeca7ccc25af5a09dbae';

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

/// 공동체 기도 목록 — 같은 다락방의 group 공개 기도 제목 실시간 스트림
///
/// Copied from [communityPrayerList].
@ProviderFor(communityPrayerList)
const communityPrayerListProvider = CommunityPrayerListFamily();

/// 공동체 기도 목록 — 같은 다락방의 group 공개 기도 제목 실시간 스트림
///
/// Copied from [communityPrayerList].
class CommunityPrayerListFamily extends Family<AsyncValue<List<Prayer>>> {
  /// 공동체 기도 목록 — 같은 다락방의 group 공개 기도 제목 실시간 스트림
  ///
  /// Copied from [communityPrayerList].
  const CommunityPrayerListFamily();

  /// 공동체 기도 목록 — 같은 다락방의 group 공개 기도 제목 실시간 스트림
  ///
  /// Copied from [communityPrayerList].
  CommunityPrayerListProvider call(String groupId) {
    return CommunityPrayerListProvider(groupId);
  }

  @override
  CommunityPrayerListProvider getProviderOverride(
    covariant CommunityPrayerListProvider provider,
  ) {
    return call(provider.groupId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'communityPrayerListProvider';
}

/// 공동체 기도 목록 — 같은 다락방의 group 공개 기도 제목 실시간 스트림
///
/// Copied from [communityPrayerList].
class CommunityPrayerListProvider
    extends AutoDisposeStreamProvider<List<Prayer>> {
  /// 공동체 기도 목록 — 같은 다락방의 group 공개 기도 제목 실시간 스트림
  ///
  /// Copied from [communityPrayerList].
  CommunityPrayerListProvider(String groupId)
    : this._internal(
        (ref) => communityPrayerList(ref as CommunityPrayerListRef, groupId),
        from: communityPrayerListProvider,
        name: r'communityPrayerListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$communityPrayerListHash,
        dependencies: CommunityPrayerListFamily._dependencies,
        allTransitiveDependencies:
            CommunityPrayerListFamily._allTransitiveDependencies,
        groupId: groupId,
      );

  CommunityPrayerListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  Override overrideWith(
    Stream<List<Prayer>> Function(CommunityPrayerListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CommunityPrayerListProvider._internal(
        (ref) => create(ref as CommunityPrayerListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Prayer>> createElement() {
    return _CommunityPrayerListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommunityPrayerListProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CommunityPrayerListRef on AutoDisposeStreamProviderRef<List<Prayer>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _CommunityPrayerListProviderElement
    extends AutoDisposeStreamProviderElement<List<Prayer>>
    with CommunityPrayerListRef {
  _CommunityPrayerListProviderElement(super.provider);

  @override
  String get groupId => (origin as CommunityPrayerListProvider).groupId;
}

String _$followingPrayerListHash() =>
    r'37650624c305842ba5a46291ca0c27a4bf70670a';

/// 팔로잉 기도 목록 — 내가 팔로우 중인 사용자들의 followers 공개 기도 실시간 스트림
///
/// Copied from [followingPrayerList].
@ProviderFor(followingPrayerList)
const followingPrayerListProvider = FollowingPrayerListFamily();

/// 팔로잉 기도 목록 — 내가 팔로우 중인 사용자들의 followers 공개 기도 실시간 스트림
///
/// Copied from [followingPrayerList].
class FollowingPrayerListFamily extends Family<AsyncValue<List<Prayer>>> {
  /// 팔로잉 기도 목록 — 내가 팔로우 중인 사용자들의 followers 공개 기도 실시간 스트림
  ///
  /// Copied from [followingPrayerList].
  const FollowingPrayerListFamily();

  /// 팔로잉 기도 목록 — 내가 팔로우 중인 사용자들의 followers 공개 기도 실시간 스트림
  ///
  /// Copied from [followingPrayerList].
  FollowingPrayerListProvider call(String userId) {
    return FollowingPrayerListProvider(userId);
  }

  @override
  FollowingPrayerListProvider getProviderOverride(
    covariant FollowingPrayerListProvider provider,
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
  String? get name => r'followingPrayerListProvider';
}

/// 팔로잉 기도 목록 — 내가 팔로우 중인 사용자들의 followers 공개 기도 실시간 스트림
///
/// Copied from [followingPrayerList].
class FollowingPrayerListProvider
    extends AutoDisposeStreamProvider<List<Prayer>> {
  /// 팔로잉 기도 목록 — 내가 팔로우 중인 사용자들의 followers 공개 기도 실시간 스트림
  ///
  /// Copied from [followingPrayerList].
  FollowingPrayerListProvider(String userId)
    : this._internal(
        (ref) => followingPrayerList(ref as FollowingPrayerListRef, userId),
        from: followingPrayerListProvider,
        name: r'followingPrayerListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$followingPrayerListHash,
        dependencies: FollowingPrayerListFamily._dependencies,
        allTransitiveDependencies:
            FollowingPrayerListFamily._allTransitiveDependencies,
        userId: userId,
      );

  FollowingPrayerListProvider._internal(
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
    Stream<List<Prayer>> Function(FollowingPrayerListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FollowingPrayerListProvider._internal(
        (ref) => create(ref as FollowingPrayerListRef),
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
  AutoDisposeStreamProviderElement<List<Prayer>> createElement() {
    return _FollowingPrayerListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FollowingPrayerListProvider && other.userId == userId;
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
mixin FollowingPrayerListRef on AutoDisposeStreamProviderRef<List<Prayer>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _FollowingPrayerListProviderElement
    extends AutoDisposeStreamProviderElement<List<Prayer>>
    with FollowingPrayerListRef {
  _FollowingPrayerListProviderElement(super.provider);

  @override
  String get userId => (origin as FollowingPrayerListProvider).userId;
}

String _$mergedCommunityPrayerListHash() =>
    r'16fd42a3ca5774165805e8cb5e6414ac4ef35fe7';

/// 통합 공동체 기도 목록 — 다락방 + 팔로잉 기도 합산 후 최신순 정렬
///
/// Copied from [mergedCommunityPrayerList].
@ProviderFor(mergedCommunityPrayerList)
const mergedCommunityPrayerListProvider = MergedCommunityPrayerListFamily();

/// 통합 공동체 기도 목록 — 다락방 + 팔로잉 기도 합산 후 최신순 정렬
///
/// Copied from [mergedCommunityPrayerList].
class MergedCommunityPrayerListFamily extends Family<AsyncValue<List<Prayer>>> {
  /// 통합 공동체 기도 목록 — 다락방 + 팔로잉 기도 합산 후 최신순 정렬
  ///
  /// Copied from [mergedCommunityPrayerList].
  const MergedCommunityPrayerListFamily();

  /// 통합 공동체 기도 목록 — 다락방 + 팔로잉 기도 합산 후 최신순 정렬
  ///
  /// Copied from [mergedCommunityPrayerList].
  MergedCommunityPrayerListProvider call(String groupId, String userId) {
    return MergedCommunityPrayerListProvider(groupId, userId);
  }

  @override
  MergedCommunityPrayerListProvider getProviderOverride(
    covariant MergedCommunityPrayerListProvider provider,
  ) {
    return call(provider.groupId, provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mergedCommunityPrayerListProvider';
}

/// 통합 공동체 기도 목록 — 다락방 + 팔로잉 기도 합산 후 최신순 정렬
///
/// Copied from [mergedCommunityPrayerList].
class MergedCommunityPrayerListProvider
    extends AutoDisposeStreamProvider<List<Prayer>> {
  /// 통합 공동체 기도 목록 — 다락방 + 팔로잉 기도 합산 후 최신순 정렬
  ///
  /// Copied from [mergedCommunityPrayerList].
  MergedCommunityPrayerListProvider(String groupId, String userId)
    : this._internal(
        (ref) => mergedCommunityPrayerList(
          ref as MergedCommunityPrayerListRef,
          groupId,
          userId,
        ),
        from: mergedCommunityPrayerListProvider,
        name: r'mergedCommunityPrayerListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$mergedCommunityPrayerListHash,
        dependencies: MergedCommunityPrayerListFamily._dependencies,
        allTransitiveDependencies:
            MergedCommunityPrayerListFamily._allTransitiveDependencies,
        groupId: groupId,
        userId: userId,
      );

  MergedCommunityPrayerListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
    required this.userId,
  }) : super.internal();

  final String groupId;
  final String userId;

  @override
  Override overrideWith(
    Stream<List<Prayer>> Function(MergedCommunityPrayerListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MergedCommunityPrayerListProvider._internal(
        (ref) => create(ref as MergedCommunityPrayerListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Prayer>> createElement() {
    return _MergedCommunityPrayerListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MergedCommunityPrayerListProvider &&
        other.groupId == groupId &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MergedCommunityPrayerListRef
    on AutoDisposeStreamProviderRef<List<Prayer>> {
  /// The parameter `groupId` of this provider.
  String get groupId;

  /// The parameter `userId` of this provider.
  String get userId;
}

class _MergedCommunityPrayerListProviderElement
    extends AutoDisposeStreamProviderElement<List<Prayer>>
    with MergedCommunityPrayerListRef {
  _MergedCommunityPrayerListProviderElement(super.provider);

  @override
  String get groupId => (origin as MergedCommunityPrayerListProvider).groupId;
  @override
  String get userId => (origin as MergedCommunityPrayerListProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
