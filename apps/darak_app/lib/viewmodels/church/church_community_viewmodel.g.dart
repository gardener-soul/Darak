// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_community_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$churchCommunityViewModelHash() =>
    r'd31611e8efc8d89f8ceb732c4bbba5acf79e85e6';

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

abstract class _$ChurchCommunityViewModel
    extends BuildlessAutoDisposeStreamNotifier<List<VillageWithGroups>> {
  late final String churchId;

  Stream<List<VillageWithGroups>> build(String churchId);
}

/// 공동체 탭(마을/다락방 트리)의 상태를 관리하는 ViewModel.
/// VillageRepository와 GroupRepository 스트림을 실시간으로 결합하여 트리 구조를 제공합니다.
///
/// Copied from [ChurchCommunityViewModel].
@ProviderFor(ChurchCommunityViewModel)
const churchCommunityViewModelProvider = ChurchCommunityViewModelFamily();

/// 공동체 탭(마을/다락방 트리)의 상태를 관리하는 ViewModel.
/// VillageRepository와 GroupRepository 스트림을 실시간으로 결합하여 트리 구조를 제공합니다.
///
/// Copied from [ChurchCommunityViewModel].
class ChurchCommunityViewModelFamily
    extends Family<AsyncValue<List<VillageWithGroups>>> {
  /// 공동체 탭(마을/다락방 트리)의 상태를 관리하는 ViewModel.
  /// VillageRepository와 GroupRepository 스트림을 실시간으로 결합하여 트리 구조를 제공합니다.
  ///
  /// Copied from [ChurchCommunityViewModel].
  const ChurchCommunityViewModelFamily();

  /// 공동체 탭(마을/다락방 트리)의 상태를 관리하는 ViewModel.
  /// VillageRepository와 GroupRepository 스트림을 실시간으로 결합하여 트리 구조를 제공합니다.
  ///
  /// Copied from [ChurchCommunityViewModel].
  ChurchCommunityViewModelProvider call(String churchId) {
    return ChurchCommunityViewModelProvider(churchId);
  }

  @override
  ChurchCommunityViewModelProvider getProviderOverride(
    covariant ChurchCommunityViewModelProvider provider,
  ) {
    return call(provider.churchId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'churchCommunityViewModelProvider';
}

/// 공동체 탭(마을/다락방 트리)의 상태를 관리하는 ViewModel.
/// VillageRepository와 GroupRepository 스트림을 실시간으로 결합하여 트리 구조를 제공합니다.
///
/// Copied from [ChurchCommunityViewModel].
class ChurchCommunityViewModelProvider
    extends
        AutoDisposeStreamNotifierProviderImpl<
          ChurchCommunityViewModel,
          List<VillageWithGroups>
        > {
  /// 공동체 탭(마을/다락방 트리)의 상태를 관리하는 ViewModel.
  /// VillageRepository와 GroupRepository 스트림을 실시간으로 결합하여 트리 구조를 제공합니다.
  ///
  /// Copied from [ChurchCommunityViewModel].
  ChurchCommunityViewModelProvider(String churchId)
    : this._internal(
        () => ChurchCommunityViewModel()..churchId = churchId,
        from: churchCommunityViewModelProvider,
        name: r'churchCommunityViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$churchCommunityViewModelHash,
        dependencies: ChurchCommunityViewModelFamily._dependencies,
        allTransitiveDependencies:
            ChurchCommunityViewModelFamily._allTransitiveDependencies,
        churchId: churchId,
      );

  ChurchCommunityViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.churchId,
  }) : super.internal();

  final String churchId;

  @override
  Stream<List<VillageWithGroups>> runNotifierBuild(
    covariant ChurchCommunityViewModel notifier,
  ) {
    return notifier.build(churchId);
  }

  @override
  Override overrideWith(ChurchCommunityViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChurchCommunityViewModelProvider._internal(
        () => create()..churchId = churchId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        churchId: churchId,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<
    ChurchCommunityViewModel,
    List<VillageWithGroups>
  >
  createElement() {
    return _ChurchCommunityViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChurchCommunityViewModelProvider &&
        other.churchId == churchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, churchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ChurchCommunityViewModelRef
    on AutoDisposeStreamNotifierProviderRef<List<VillageWithGroups>> {
  /// The parameter `churchId` of this provider.
  String get churchId;
}

class _ChurchCommunityViewModelProviderElement
    extends
        AutoDisposeStreamNotifierProviderElement<
          ChurchCommunityViewModel,
          List<VillageWithGroups>
        >
    with ChurchCommunityViewModelRef {
  _ChurchCommunityViewModelProviderElement(super.provider);

  @override
  String get churchId => (origin as ChurchCommunityViewModelProvider).churchId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
