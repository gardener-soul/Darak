// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_members_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$churchMembersViewModelHash() =>
    r'42bdec410b5d7b8cd62ab89dc18b106c305e6aaf';

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

abstract class _$ChurchMembersViewModel
    extends BuildlessAutoDisposeAsyncNotifier<ChurchMembersState> {
  late final String churchId;

  FutureOr<ChurchMembersState> build(String churchId);
}

/// 구성원 탭의 상태를 관리하는 ViewModel.
/// ChurchMember + User + ChurchRole 데이터를 조립하여 ChurchMemberProfile 목록을 제공합니다.
/// 역할 필터링 및 이름 검색을 지원합니다.
///
/// Copied from [ChurchMembersViewModel].
@ProviderFor(ChurchMembersViewModel)
const churchMembersViewModelProvider = ChurchMembersViewModelFamily();

/// 구성원 탭의 상태를 관리하는 ViewModel.
/// ChurchMember + User + ChurchRole 데이터를 조립하여 ChurchMemberProfile 목록을 제공합니다.
/// 역할 필터링 및 이름 검색을 지원합니다.
///
/// Copied from [ChurchMembersViewModel].
class ChurchMembersViewModelFamily
    extends Family<AsyncValue<ChurchMembersState>> {
  /// 구성원 탭의 상태를 관리하는 ViewModel.
  /// ChurchMember + User + ChurchRole 데이터를 조립하여 ChurchMemberProfile 목록을 제공합니다.
  /// 역할 필터링 및 이름 검색을 지원합니다.
  ///
  /// Copied from [ChurchMembersViewModel].
  const ChurchMembersViewModelFamily();

  /// 구성원 탭의 상태를 관리하는 ViewModel.
  /// ChurchMember + User + ChurchRole 데이터를 조립하여 ChurchMemberProfile 목록을 제공합니다.
  /// 역할 필터링 및 이름 검색을 지원합니다.
  ///
  /// Copied from [ChurchMembersViewModel].
  ChurchMembersViewModelProvider call(String churchId) {
    return ChurchMembersViewModelProvider(churchId);
  }

  @override
  ChurchMembersViewModelProvider getProviderOverride(
    covariant ChurchMembersViewModelProvider provider,
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
  String? get name => r'churchMembersViewModelProvider';
}

/// 구성원 탭의 상태를 관리하는 ViewModel.
/// ChurchMember + User + ChurchRole 데이터를 조립하여 ChurchMemberProfile 목록을 제공합니다.
/// 역할 필터링 및 이름 검색을 지원합니다.
///
/// Copied from [ChurchMembersViewModel].
class ChurchMembersViewModelProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ChurchMembersViewModel,
          ChurchMembersState
        > {
  /// 구성원 탭의 상태를 관리하는 ViewModel.
  /// ChurchMember + User + ChurchRole 데이터를 조립하여 ChurchMemberProfile 목록을 제공합니다.
  /// 역할 필터링 및 이름 검색을 지원합니다.
  ///
  /// Copied from [ChurchMembersViewModel].
  ChurchMembersViewModelProvider(String churchId)
    : this._internal(
        () => ChurchMembersViewModel()..churchId = churchId,
        from: churchMembersViewModelProvider,
        name: r'churchMembersViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$churchMembersViewModelHash,
        dependencies: ChurchMembersViewModelFamily._dependencies,
        allTransitiveDependencies:
            ChurchMembersViewModelFamily._allTransitiveDependencies,
        churchId: churchId,
      );

  ChurchMembersViewModelProvider._internal(
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
  FutureOr<ChurchMembersState> runNotifierBuild(
    covariant ChurchMembersViewModel notifier,
  ) {
    return notifier.build(churchId);
  }

  @override
  Override overrideWith(ChurchMembersViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChurchMembersViewModelProvider._internal(
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
    ChurchMembersViewModel,
    ChurchMembersState
  >
  createElement() {
    return _ChurchMembersViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChurchMembersViewModelProvider &&
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
mixin ChurchMembersViewModelRef
    on AutoDisposeAsyncNotifierProviderRef<ChurchMembersState> {
  /// The parameter `churchId` of this provider.
  String get churchId;
}

class _ChurchMembersViewModelProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ChurchMembersViewModel,
          ChurchMembersState
        >
    with ChurchMembersViewModelRef {
  _ChurchMembersViewModelProviderElement(super.provider);

  @override
  String get churchId => (origin as ChurchMembersViewModelProvider).churchId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
