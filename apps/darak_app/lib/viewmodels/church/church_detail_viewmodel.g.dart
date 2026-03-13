// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_detail_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$churchDetailViewModelHash() =>
    r'62d40a6515fa9b3178a75e0580cbf5406006f16d';

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

abstract class _$ChurchDetailViewModel
    extends BuildlessAutoDisposeStreamNotifier<ChurchDetailState> {
  late final String churchId;

  Stream<ChurchDetailState> build(String churchId);
}

/// 교회 상세 화면의 상태를 관리하는 ViewModel.
/// Church 실시간 스트림 구독 + 현재 유저의 멤버십 정보 + 관리자 여부를 조립합니다.
///
/// Copied from [ChurchDetailViewModel].
@ProviderFor(ChurchDetailViewModel)
const churchDetailViewModelProvider = ChurchDetailViewModelFamily();

/// 교회 상세 화면의 상태를 관리하는 ViewModel.
/// Church 실시간 스트림 구독 + 현재 유저의 멤버십 정보 + 관리자 여부를 조립합니다.
///
/// Copied from [ChurchDetailViewModel].
class ChurchDetailViewModelFamily
    extends Family<AsyncValue<ChurchDetailState>> {
  /// 교회 상세 화면의 상태를 관리하는 ViewModel.
  /// Church 실시간 스트림 구독 + 현재 유저의 멤버십 정보 + 관리자 여부를 조립합니다.
  ///
  /// Copied from [ChurchDetailViewModel].
  const ChurchDetailViewModelFamily();

  /// 교회 상세 화면의 상태를 관리하는 ViewModel.
  /// Church 실시간 스트림 구독 + 현재 유저의 멤버십 정보 + 관리자 여부를 조립합니다.
  ///
  /// Copied from [ChurchDetailViewModel].
  ChurchDetailViewModelProvider call(String churchId) {
    return ChurchDetailViewModelProvider(churchId);
  }

  @override
  ChurchDetailViewModelProvider getProviderOverride(
    covariant ChurchDetailViewModelProvider provider,
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
  String? get name => r'churchDetailViewModelProvider';
}

/// 교회 상세 화면의 상태를 관리하는 ViewModel.
/// Church 실시간 스트림 구독 + 현재 유저의 멤버십 정보 + 관리자 여부를 조립합니다.
///
/// Copied from [ChurchDetailViewModel].
class ChurchDetailViewModelProvider
    extends
        AutoDisposeStreamNotifierProviderImpl<
          ChurchDetailViewModel,
          ChurchDetailState
        > {
  /// 교회 상세 화면의 상태를 관리하는 ViewModel.
  /// Church 실시간 스트림 구독 + 현재 유저의 멤버십 정보 + 관리자 여부를 조립합니다.
  ///
  /// Copied from [ChurchDetailViewModel].
  ChurchDetailViewModelProvider(String churchId)
    : this._internal(
        () => ChurchDetailViewModel()..churchId = churchId,
        from: churchDetailViewModelProvider,
        name: r'churchDetailViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$churchDetailViewModelHash,
        dependencies: ChurchDetailViewModelFamily._dependencies,
        allTransitiveDependencies:
            ChurchDetailViewModelFamily._allTransitiveDependencies,
        churchId: churchId,
      );

  ChurchDetailViewModelProvider._internal(
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
  Stream<ChurchDetailState> runNotifierBuild(
    covariant ChurchDetailViewModel notifier,
  ) {
    return notifier.build(churchId);
  }

  @override
  Override overrideWith(ChurchDetailViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChurchDetailViewModelProvider._internal(
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
    ChurchDetailViewModel,
    ChurchDetailState
  >
  createElement() {
    return _ChurchDetailViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChurchDetailViewModelProvider && other.churchId == churchId;
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
mixin ChurchDetailViewModelRef
    on AutoDisposeStreamNotifierProviderRef<ChurchDetailState> {
  /// The parameter `churchId` of this provider.
  String get churchId;
}

class _ChurchDetailViewModelProviderElement
    extends
        AutoDisposeStreamNotifierProviderElement<
          ChurchDetailViewModel,
          ChurchDetailState
        >
    with ChurchDetailViewModelRef {
  _ChurchDetailViewModelProviderElement(super.provider);

  @override
  String get churchId => (origin as ChurchDetailViewModelProvider).churchId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
