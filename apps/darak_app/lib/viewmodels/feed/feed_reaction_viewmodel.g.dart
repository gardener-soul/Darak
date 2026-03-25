// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_reaction_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedReactionViewModelHash() =>
    r'84efc71d21b1d69362480cfbc428b3c1c14a1518';

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

abstract class _$FeedReactionViewModel
    extends BuildlessAutoDisposeNotifier<void> {
  late final String feedId;

  void build(String feedId);
}

/// 특정 피드의 반응을 낙관적 UI로 관리하는 Notifier
/// familyKey: feedId
///
/// Copied from [FeedReactionViewModel].
@ProviderFor(FeedReactionViewModel)
const feedReactionViewModelProvider = FeedReactionViewModelFamily();

/// 특정 피드의 반응을 낙관적 UI로 관리하는 Notifier
/// familyKey: feedId
///
/// Copied from [FeedReactionViewModel].
class FeedReactionViewModelFamily extends Family<void> {
  /// 특정 피드의 반응을 낙관적 UI로 관리하는 Notifier
  /// familyKey: feedId
  ///
  /// Copied from [FeedReactionViewModel].
  const FeedReactionViewModelFamily();

  /// 특정 피드의 반응을 낙관적 UI로 관리하는 Notifier
  /// familyKey: feedId
  ///
  /// Copied from [FeedReactionViewModel].
  FeedReactionViewModelProvider call(String feedId) {
    return FeedReactionViewModelProvider(feedId);
  }

  @override
  FeedReactionViewModelProvider getProviderOverride(
    covariant FeedReactionViewModelProvider provider,
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
  String? get name => r'feedReactionViewModelProvider';
}

/// 특정 피드의 반응을 낙관적 UI로 관리하는 Notifier
/// familyKey: feedId
///
/// Copied from [FeedReactionViewModel].
class FeedReactionViewModelProvider
    extends AutoDisposeNotifierProviderImpl<FeedReactionViewModel, void> {
  /// 특정 피드의 반응을 낙관적 UI로 관리하는 Notifier
  /// familyKey: feedId
  ///
  /// Copied from [FeedReactionViewModel].
  FeedReactionViewModelProvider(String feedId)
    : this._internal(
        () => FeedReactionViewModel()..feedId = feedId,
        from: feedReactionViewModelProvider,
        name: r'feedReactionViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$feedReactionViewModelHash,
        dependencies: FeedReactionViewModelFamily._dependencies,
        allTransitiveDependencies:
            FeedReactionViewModelFamily._allTransitiveDependencies,
        feedId: feedId,
      );

  FeedReactionViewModelProvider._internal(
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
  void runNotifierBuild(covariant FeedReactionViewModel notifier) {
    return notifier.build(feedId);
  }

  @override
  Override overrideWith(FeedReactionViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: FeedReactionViewModelProvider._internal(
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
  AutoDisposeNotifierProviderElement<FeedReactionViewModel, void>
  createElement() {
    return _FeedReactionViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FeedReactionViewModelProvider && other.feedId == feedId;
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
mixin FeedReactionViewModelRef on AutoDisposeNotifierProviderRef<void> {
  /// The parameter `feedId` of this provider.
  String get feedId;
}

class _FeedReactionViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<FeedReactionViewModel, void>
    with FeedReactionViewModelRef {
  _FeedReactionViewModelProviderElement(super.provider);

  @override
  String get feedId => (origin as FeedReactionViewModelProvider).feedId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
