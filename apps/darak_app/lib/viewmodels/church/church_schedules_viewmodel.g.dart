// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_schedules_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$churchSchedulesViewModelHash() =>
    r'0c47c1e09c39d83a312ed963fd63ae5b861c936d';

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

abstract class _$ChurchSchedulesViewModel
    extends BuildlessAutoDisposeAsyncNotifier<ChurchSchedulesState> {
  late final String churchId;

  FutureOr<ChurchSchedulesState> build(String churchId);
}

/// 일정 탭의 상태를 관리하는 ViewModel.
/// 주간/월간 뷰 모드 전환 및 해당 기간의 일정 목록을 제공합니다.
///
/// Copied from [ChurchSchedulesViewModel].
@ProviderFor(ChurchSchedulesViewModel)
const churchSchedulesViewModelProvider = ChurchSchedulesViewModelFamily();

/// 일정 탭의 상태를 관리하는 ViewModel.
/// 주간/월간 뷰 모드 전환 및 해당 기간의 일정 목록을 제공합니다.
///
/// Copied from [ChurchSchedulesViewModel].
class ChurchSchedulesViewModelFamily
    extends Family<AsyncValue<ChurchSchedulesState>> {
  /// 일정 탭의 상태를 관리하는 ViewModel.
  /// 주간/월간 뷰 모드 전환 및 해당 기간의 일정 목록을 제공합니다.
  ///
  /// Copied from [ChurchSchedulesViewModel].
  const ChurchSchedulesViewModelFamily();

  /// 일정 탭의 상태를 관리하는 ViewModel.
  /// 주간/월간 뷰 모드 전환 및 해당 기간의 일정 목록을 제공합니다.
  ///
  /// Copied from [ChurchSchedulesViewModel].
  ChurchSchedulesViewModelProvider call(String churchId) {
    return ChurchSchedulesViewModelProvider(churchId);
  }

  @override
  ChurchSchedulesViewModelProvider getProviderOverride(
    covariant ChurchSchedulesViewModelProvider provider,
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
  String? get name => r'churchSchedulesViewModelProvider';
}

/// 일정 탭의 상태를 관리하는 ViewModel.
/// 주간/월간 뷰 모드 전환 및 해당 기간의 일정 목록을 제공합니다.
///
/// Copied from [ChurchSchedulesViewModel].
class ChurchSchedulesViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ChurchSchedulesViewModel,
          ChurchSchedulesState
        > {
  /// 일정 탭의 상태를 관리하는 ViewModel.
  /// 주간/월간 뷰 모드 전환 및 해당 기간의 일정 목록을 제공합니다.
  ///
  /// Copied from [ChurchSchedulesViewModel].
  ChurchSchedulesViewModelProvider(String churchId)
    : this._internal(
        () => ChurchSchedulesViewModel()..churchId = churchId,
        from: churchSchedulesViewModelProvider,
        name: r'churchSchedulesViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$churchSchedulesViewModelHash,
        dependencies: ChurchSchedulesViewModelFamily._dependencies,
        allTransitiveDependencies:
            ChurchSchedulesViewModelFamily._allTransitiveDependencies,
        churchId: churchId,
      );

  ChurchSchedulesViewModelProvider._internal(
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
  FutureOr<ChurchSchedulesState> runNotifierBuild(
    covariant ChurchSchedulesViewModel notifier,
  ) {
    return notifier.build(churchId);
  }

  @override
  Override overrideWith(ChurchSchedulesViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChurchSchedulesViewModelProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<
    ChurchSchedulesViewModel,
    ChurchSchedulesState
  >
  createElement() {
    return _ChurchSchedulesViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChurchSchedulesViewModelProvider &&
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
mixin ChurchSchedulesViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<ChurchSchedulesState> {
  /// The parameter `churchId` of this provider.
  String get churchId;
}

class _ChurchSchedulesViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ChurchSchedulesViewModel,
          ChurchSchedulesState
        >
    with ChurchSchedulesViewModelRef {
  _ChurchSchedulesViewModelProviderElement(super.provider);

  @override
  String get churchId => (origin as ChurchSchedulesViewModelProvider).churchId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
