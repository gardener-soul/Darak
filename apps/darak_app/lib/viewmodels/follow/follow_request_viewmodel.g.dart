// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_request_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingFollowRequestsHash() =>
    r'6f735d66e2d80e0c981ea6881ddbbda5cb39dc66';

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

/// 나에게 온 팔로우 요청(pending) 실시간 스트림
///
/// Copied from [pendingFollowRequests].
@ProviderFor(pendingFollowRequests)
const pendingFollowRequestsProvider = PendingFollowRequestsFamily();

/// 나에게 온 팔로우 요청(pending) 실시간 스트림
///
/// Copied from [pendingFollowRequests].
class PendingFollowRequestsFamily extends Family<AsyncValue<List<Follow>>> {
  /// 나에게 온 팔로우 요청(pending) 실시간 스트림
  ///
  /// Copied from [pendingFollowRequests].
  const PendingFollowRequestsFamily();

  /// 나에게 온 팔로우 요청(pending) 실시간 스트림
  ///
  /// Copied from [pendingFollowRequests].
  PendingFollowRequestsProvider call(String userId) {
    return PendingFollowRequestsProvider(userId);
  }

  @override
  PendingFollowRequestsProvider getProviderOverride(
    covariant PendingFollowRequestsProvider provider,
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
  String? get name => r'pendingFollowRequestsProvider';
}

/// 나에게 온 팔로우 요청(pending) 실시간 스트림
///
/// Copied from [pendingFollowRequests].
class PendingFollowRequestsProvider
    extends AutoDisposeStreamProvider<List<Follow>> {
  /// 나에게 온 팔로우 요청(pending) 실시간 스트림
  ///
  /// Copied from [pendingFollowRequests].
  PendingFollowRequestsProvider(String userId)
    : this._internal(
        (ref) => pendingFollowRequests(ref as PendingFollowRequestsRef, userId),
        from: pendingFollowRequestsProvider,
        name: r'pendingFollowRequestsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$pendingFollowRequestsHash,
        dependencies: PendingFollowRequestsFamily._dependencies,
        allTransitiveDependencies:
            PendingFollowRequestsFamily._allTransitiveDependencies,
        userId: userId,
      );

  PendingFollowRequestsProvider._internal(
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
    Stream<List<Follow>> Function(PendingFollowRequestsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PendingFollowRequestsProvider._internal(
        (ref) => create(ref as PendingFollowRequestsRef),
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
    return _PendingFollowRequestsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingFollowRequestsProvider && other.userId == userId;
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
mixin PendingFollowRequestsRef on AutoDisposeStreamProviderRef<List<Follow>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _PendingFollowRequestsProviderElement
    extends AutoDisposeStreamProviderElement<List<Follow>>
    with PendingFollowRequestsRef {
  _PendingFollowRequestsProviderElement(super.provider);

  @override
  String get userId => (origin as PendingFollowRequestsProvider).userId;
}

String _$pendingFollowRequestCountHash() =>
    r'385c4e182bdf2109fe5043f433be30d01758227d';

/// 나에게 온 팔로우 요청 수 실시간 스트림
///
/// Copied from [pendingFollowRequestCount].
@ProviderFor(pendingFollowRequestCount)
const pendingFollowRequestCountProvider = PendingFollowRequestCountFamily();

/// 나에게 온 팔로우 요청 수 실시간 스트림
///
/// Copied from [pendingFollowRequestCount].
class PendingFollowRequestCountFamily extends Family<AsyncValue<int>> {
  /// 나에게 온 팔로우 요청 수 실시간 스트림
  ///
  /// Copied from [pendingFollowRequestCount].
  const PendingFollowRequestCountFamily();

  /// 나에게 온 팔로우 요청 수 실시간 스트림
  ///
  /// Copied from [pendingFollowRequestCount].
  PendingFollowRequestCountProvider call(String userId) {
    return PendingFollowRequestCountProvider(userId);
  }

  @override
  PendingFollowRequestCountProvider getProviderOverride(
    covariant PendingFollowRequestCountProvider provider,
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
  String? get name => r'pendingFollowRequestCountProvider';
}

/// 나에게 온 팔로우 요청 수 실시간 스트림
///
/// Copied from [pendingFollowRequestCount].
class PendingFollowRequestCountProvider extends AutoDisposeStreamProvider<int> {
  /// 나에게 온 팔로우 요청 수 실시간 스트림
  ///
  /// Copied from [pendingFollowRequestCount].
  PendingFollowRequestCountProvider(String userId)
    : this._internal(
        (ref) => pendingFollowRequestCount(
          ref as PendingFollowRequestCountRef,
          userId,
        ),
        from: pendingFollowRequestCountProvider,
        name: r'pendingFollowRequestCountProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$pendingFollowRequestCountHash,
        dependencies: PendingFollowRequestCountFamily._dependencies,
        allTransitiveDependencies:
            PendingFollowRequestCountFamily._allTransitiveDependencies,
        userId: userId,
      );

  PendingFollowRequestCountProvider._internal(
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
    Stream<int> Function(PendingFollowRequestCountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PendingFollowRequestCountProvider._internal(
        (ref) => create(ref as PendingFollowRequestCountRef),
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
  AutoDisposeStreamProviderElement<int> createElement() {
    return _PendingFollowRequestCountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingFollowRequestCountProvider && other.userId == userId;
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
mixin PendingFollowRequestCountRef on AutoDisposeStreamProviderRef<int> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _PendingFollowRequestCountProviderElement
    extends AutoDisposeStreamProviderElement<int>
    with PendingFollowRequestCountRef {
  _PendingFollowRequestCountProviderElement(super.provider);

  @override
  String get userId => (origin as PendingFollowRequestCountProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
