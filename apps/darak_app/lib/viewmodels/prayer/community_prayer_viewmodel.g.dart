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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
