// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_encouragement_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedEncouragementsHash() =>
    r'149f8eb5da6f82b344442fbe0b4e70f15242b374';

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

/// See also [feedEncouragements].
@ProviderFor(feedEncouragements)
const feedEncouragementsProvider = FeedEncouragementsFamily();

/// See also [feedEncouragements].
class FeedEncouragementsFamily extends Family<AsyncValue<List<Encouragement>>> {
  /// See also [feedEncouragements].
  const FeedEncouragementsFamily();

  /// See also [feedEncouragements].
  FeedEncouragementsProvider call(String feedId) {
    return FeedEncouragementsProvider(feedId);
  }

  @override
  FeedEncouragementsProvider getProviderOverride(
    covariant FeedEncouragementsProvider provider,
  ) {
    return call(provider.feedId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'feedEncouragementsProvider';
}

/// See also [feedEncouragements].
class FeedEncouragementsProvider
    extends AutoDisposeStreamProvider<List<Encouragement>> {
  /// See also [feedEncouragements].
  FeedEncouragementsProvider(String feedId)
    : this._internal(
        (ref) => feedEncouragements(ref as FeedEncouragementsRef, feedId),
        from: feedEncouragementsProvider,
        name: r'feedEncouragementsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$feedEncouragementsHash,
        dependencies: FeedEncouragementsFamily._dependencies,
        allTransitiveDependencies:
            FeedEncouragementsFamily._allTransitiveDependencies,
        feedId: feedId,
      );

  FeedEncouragementsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.feedId,
  }) : super.internal();

  final String feedId;

  @override
  Override overrideWith(
    Stream<List<Encouragement>> Function(FeedEncouragementsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FeedEncouragementsProvider._internal(
        (ref) => create(ref as FeedEncouragementsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        feedId: feedId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Encouragement>> createElement() {
    return _FeedEncouragementsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeedEncouragementsProvider && other.feedId == feedId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, feedId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FeedEncouragementsRef
    on AutoDisposeStreamProviderRef<List<Encouragement>> {
  /// The parameter `feedId` of this provider.
  String get feedId;
}

class _FeedEncouragementsProviderElement
    extends AutoDisposeStreamProviderElement<List<Encouragement>>
    with FeedEncouragementsRef {
  _FeedEncouragementsProviderElement(super.provider);

  @override
  String get feedId => (origin as FeedEncouragementsProvider).feedId;
}

String _$feedEncouragementViewModelHash() =>
    r'ef8a572107ee08a37b827eec7788d0527a05d065';

abstract class _$FeedEncouragementViewModel
    extends BuildlessAutoDisposeNotifier<EncouragementCreateState> {
  late final String feedId;

  EncouragementCreateState build(String feedId);
}

/// See also [FeedEncouragementViewModel].
@ProviderFor(FeedEncouragementViewModel)
const feedEncouragementViewModelProvider = FeedEncouragementViewModelFamily();

/// See also [FeedEncouragementViewModel].
class FeedEncouragementViewModelFamily
    extends Family<EncouragementCreateState> {
  /// See also [FeedEncouragementViewModel].
  const FeedEncouragementViewModelFamily();

  /// See also [FeedEncouragementViewModel].
  FeedEncouragementViewModelProvider call(String feedId) {
    return FeedEncouragementViewModelProvider(feedId);
  }

  @override
  FeedEncouragementViewModelProvider getProviderOverride(
    covariant FeedEncouragementViewModelProvider provider,
  ) {
    return call(provider.feedId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'feedEncouragementViewModelProvider';
}

/// See also [FeedEncouragementViewModel].
class FeedEncouragementViewModelProvider
    extends
        AutoDisposeNotifierProviderImpl<
          FeedEncouragementViewModel,
          EncouragementCreateState
        > {
  /// See also [FeedEncouragementViewModel].
  FeedEncouragementViewModelProvider(String feedId)
    : this._internal(
        () => FeedEncouragementViewModel()..feedId = feedId,
        from: feedEncouragementViewModelProvider,
        name: r'feedEncouragementViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$feedEncouragementViewModelHash,
        dependencies: FeedEncouragementViewModelFamily._dependencies,
        allTransitiveDependencies:
            FeedEncouragementViewModelFamily._allTransitiveDependencies,
        feedId: feedId,
      );

  FeedEncouragementViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.feedId,
  }) : super.internal();

  final String feedId;

  @override
  EncouragementCreateState runNotifierBuild(
    covariant FeedEncouragementViewModel notifier,
  ) {
    return notifier.build(feedId);
  }

  @override
  Override overrideWith(FeedEncouragementViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: FeedEncouragementViewModelProvider._internal(
        () => create()..feedId = feedId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        feedId: feedId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<
    FeedEncouragementViewModel,
    EncouragementCreateState
  >
  createElement() {
    return _FeedEncouragementViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeedEncouragementViewModelProvider &&
        other.feedId == feedId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, feedId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FeedEncouragementViewModelRef
    on AutoDisposeNotifierProviderRef<EncouragementCreateState> {
  /// The parameter `feedId` of this provider.
  String get feedId;
}

class _FeedEncouragementViewModelProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          FeedEncouragementViewModel,
          EncouragementCreateState
        >
    with FeedEncouragementViewModelRef {
  _FeedEncouragementViewModelProviderElement(super.provider);

  @override
  String get feedId => (origin as FeedEncouragementViewModelProvider).feedId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
