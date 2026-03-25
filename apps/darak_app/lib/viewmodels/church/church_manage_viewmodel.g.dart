// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_manage_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$churchManageViewModelHash() =>
    r'9974cacab4d4a9a4c5c39c52db234d57233a2712';

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

abstract class _$ChurchManageViewModel
    extends BuildlessAutoDisposeAsyncNotifier<void> {
  late final String churchId;

  FutureOr<void> build(String churchId);
}

/// 교회 관리 화면(관리자 전용)의 상태를 관리하는 ViewModel.
/// 교회 기본 정보 수정, 관리자 추가/제거, 멤버 역할 변경, 역할 이름 변경을 담당합니다.
///
/// Copied from [ChurchManageViewModel].
@ProviderFor(ChurchManageViewModel)
const churchManageViewModelProvider = ChurchManageViewModelFamily();

/// 교회 관리 화면(관리자 전용)의 상태를 관리하는 ViewModel.
/// 교회 기본 정보 수정, 관리자 추가/제거, 멤버 역할 변경, 역할 이름 변경을 담당합니다.
///
/// Copied from [ChurchManageViewModel].
class ChurchManageViewModelFamily extends Family<AsyncValue<void>> {
  /// 교회 관리 화면(관리자 전용)의 상태를 관리하는 ViewModel.
  /// 교회 기본 정보 수정, 관리자 추가/제거, 멤버 역할 변경, 역할 이름 변경을 담당합니다.
  ///
  /// Copied from [ChurchManageViewModel].
  const ChurchManageViewModelFamily();

  /// 교회 관리 화면(관리자 전용)의 상태를 관리하는 ViewModel.
  /// 교회 기본 정보 수정, 관리자 추가/제거, 멤버 역할 변경, 역할 이름 변경을 담당합니다.
  ///
  /// Copied from [ChurchManageViewModel].
  ChurchManageViewModelProvider call(String churchId) {
    return ChurchManageViewModelProvider(churchId);
  }

  @override
  ChurchManageViewModelProvider getProviderOverride(
    covariant ChurchManageViewModelProvider provider,
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
  String? get name => r'churchManageViewModelProvider';
}

/// 교회 관리 화면(관리자 전용)의 상태를 관리하는 ViewModel.
/// 교회 기본 정보 수정, 관리자 추가/제거, 멤버 역할 변경, 역할 이름 변경을 담당합니다.
///
/// Copied from [ChurchManageViewModel].
class ChurchManageViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ChurchManageViewModel, void> {
  /// 교회 관리 화면(관리자 전용)의 상태를 관리하는 ViewModel.
  /// 교회 기본 정보 수정, 관리자 추가/제거, 멤버 역할 변경, 역할 이름 변경을 담당합니다.
  ///
  /// Copied from [ChurchManageViewModel].
  ChurchManageViewModelProvider(String churchId)
    : this._internal(
        () => ChurchManageViewModel()..churchId = churchId,
        from: churchManageViewModelProvider,
        name: r'churchManageViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$churchManageViewModelHash,
        dependencies: ChurchManageViewModelFamily._dependencies,
        allTransitiveDependencies:
            ChurchManageViewModelFamily._allTransitiveDependencies,
        churchId: churchId,
      );

  ChurchManageViewModelProvider._internal(
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
  FutureOr<void> runNotifierBuild(covariant ChurchManageViewModel notifier) {
    return notifier.build(churchId);
  }

  @override
  Override overrideWith(ChurchManageViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChurchManageViewModelProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<ChurchManageViewModel, void>
  createElement() {
    return _ChurchManageViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChurchManageViewModelProvider && other.churchId == churchId;
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
mixin ChurchManageViewModelRef on AutoDisposeAsyncNotifierProviderRef<void> {
  /// The parameter `churchId` of this provider.
  String get churchId;
}

class _ChurchManageViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ChurchManageViewModel, void>
    with ChurchManageViewModelRef {
  _ChurchManageViewModelProviderElement(super.provider);

  @override
  String get churchId => (origin as ChurchManageViewModelProvider).churchId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
