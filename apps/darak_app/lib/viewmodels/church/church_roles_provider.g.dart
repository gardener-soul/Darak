// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_roles_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$churchRolesHash() => r'518e4fb5cc97d35a6d53bdcacf1b11a454a7ae7b';

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

/// 교회 역할 목록을 level 순으로 실시간 구독하는 Provider.
/// 구성원 탭의 역할 필터 UI 및 역할 배지 표시에서 사용합니다.
///
/// Copied from [churchRoles].
@ProviderFor(churchRoles)
const churchRolesProvider = ChurchRolesFamily();

/// 교회 역할 목록을 level 순으로 실시간 구독하는 Provider.
/// 구성원 탭의 역할 필터 UI 및 역할 배지 표시에서 사용합니다.
///
/// Copied from [churchRoles].
class ChurchRolesFamily extends Family<AsyncValue<List<ChurchRole>>> {
  /// 교회 역할 목록을 level 순으로 실시간 구독하는 Provider.
  /// 구성원 탭의 역할 필터 UI 및 역할 배지 표시에서 사용합니다.
  ///
  /// Copied from [churchRoles].
  const ChurchRolesFamily();

  /// 교회 역할 목록을 level 순으로 실시간 구독하는 Provider.
  /// 구성원 탭의 역할 필터 UI 및 역할 배지 표시에서 사용합니다.
  ///
  /// Copied from [churchRoles].
  ChurchRolesProvider call(String churchId) {
    return ChurchRolesProvider(churchId);
  }

  @override
  ChurchRolesProvider getProviderOverride(
    covariant ChurchRolesProvider provider,
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
  String? get name => r'churchRolesProvider';
}

/// 교회 역할 목록을 level 순으로 실시간 구독하는 Provider.
/// 구성원 탭의 역할 필터 UI 및 역할 배지 표시에서 사용합니다.
///
/// Copied from [churchRoles].
class ChurchRolesProvider extends AutoDisposeStreamProvider<List<ChurchRole>> {
  /// 교회 역할 목록을 level 순으로 실시간 구독하는 Provider.
  /// 구성원 탭의 역할 필터 UI 및 역할 배지 표시에서 사용합니다.
  ///
  /// Copied from [churchRoles].
  ChurchRolesProvider(String churchId)
    : this._internal(
        (ref) => churchRoles(ref as ChurchRolesRef, churchId),
        from: churchRolesProvider,
        name: r'churchRolesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$churchRolesHash,
        dependencies: ChurchRolesFamily._dependencies,
        allTransitiveDependencies: ChurchRolesFamily._allTransitiveDependencies,
        churchId: churchId,
      );

  ChurchRolesProvider._internal(
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
  Override overrideWith(
    Stream<List<ChurchRole>> Function(ChurchRolesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChurchRolesProvider._internal(
        (ref) => create(ref as ChurchRolesRef),
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
  AutoDisposeStreamProviderElement<List<ChurchRole>> createElement() {
    return _ChurchRolesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChurchRolesProvider && other.churchId == churchId;
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
mixin ChurchRolesRef on AutoDisposeStreamProviderRef<List<ChurchRole>> {
  /// The parameter `churchId` of this provider.
  String get churchId;
}

class _ChurchRolesProviderElement
    extends AutoDisposeStreamProviderElement<List<ChurchRole>>
    with ChurchRolesRef {
  _ChurchRolesProviderElement(super.provider);

  @override
  String get churchId => (origin as ChurchRolesProvider).churchId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
