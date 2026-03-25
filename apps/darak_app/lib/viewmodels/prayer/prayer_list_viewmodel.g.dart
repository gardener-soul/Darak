// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_list_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myPrayerListHash() => r'684808a42d3f061cf2e9bc7adf0a6d60ec057f63';

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

/// 내 기도 목록 — 실시간 스트림 Provider
///
/// Copied from [myPrayerList].
@ProviderFor(myPrayerList)
const myPrayerListProvider = MyPrayerListFamily();

/// 내 기도 목록 — 실시간 스트림 Provider
///
/// Copied from [myPrayerList].
class MyPrayerListFamily extends Family<AsyncValue<List<Prayer>>> {
  /// 내 기도 목록 — 실시간 스트림 Provider
  ///
  /// Copied from [myPrayerList].
  const MyPrayerListFamily();

  /// 내 기도 목록 — 실시간 스트림 Provider
  ///
  /// Copied from [myPrayerList].
  MyPrayerListProvider call(String userId) {
    return MyPrayerListProvider(userId);
  }

  @override
  MyPrayerListProvider getProviderOverride(
    covariant MyPrayerListProvider provider,
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
  String? get name => r'myPrayerListProvider';
}

/// 내 기도 목록 — 실시간 스트림 Provider
///
/// Copied from [myPrayerList].
class MyPrayerListProvider extends AutoDisposeStreamProvider<List<Prayer>> {
  /// 내 기도 목록 — 실시간 스트림 Provider
  ///
  /// Copied from [myPrayerList].
  MyPrayerListProvider(String userId)
    : this._internal(
        (ref) => myPrayerList(ref as MyPrayerListRef, userId),
        from: myPrayerListProvider,
        name: r'myPrayerListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$myPrayerListHash,
        dependencies: MyPrayerListFamily._dependencies,
        allTransitiveDependencies:
            MyPrayerListFamily._allTransitiveDependencies,
        userId: userId,
      );

  MyPrayerListProvider._internal(
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
    Stream<List<Prayer>> Function(MyPrayerListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MyPrayerListProvider._internal(
        (ref) => create(ref as MyPrayerListRef),
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
  AutoDisposeStreamProviderElement<List<Prayer>> createElement() {
    return _MyPrayerListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyPrayerListProvider && other.userId == userId;
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
mixin MyPrayerListRef on AutoDisposeStreamProviderRef<List<Prayer>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _MyPrayerListProviderElement
    extends AutoDisposeStreamProviderElement<List<Prayer>>
    with MyPrayerListRef {
  _MyPrayerListProviderElement(super.provider);

  @override
  String get userId => (origin as MyPrayerListProvider).userId;
}

String _$filteredPrayerListHash() =>
    r'5d34bc1163f74887afa4d364cf27175e5546400a';

/// 선택된 날짜에 활성화된 기도 제목 필터링 (클라이언트 사이드)
///
/// startDate ≤ selectedDate ≤ endDate (endDate가 null이면 무기한으로 포함)
///
/// Copied from [filteredPrayerList].
@ProviderFor(filteredPrayerList)
const filteredPrayerListProvider = FilteredPrayerListFamily();

/// 선택된 날짜에 활성화된 기도 제목 필터링 (클라이언트 사이드)
///
/// startDate ≤ selectedDate ≤ endDate (endDate가 null이면 무기한으로 포함)
///
/// Copied from [filteredPrayerList].
class FilteredPrayerListFamily extends Family<List<Prayer>> {
  /// 선택된 날짜에 활성화된 기도 제목 필터링 (클라이언트 사이드)
  ///
  /// startDate ≤ selectedDate ≤ endDate (endDate가 null이면 무기한으로 포함)
  ///
  /// Copied from [filteredPrayerList].
  const FilteredPrayerListFamily();

  /// 선택된 날짜에 활성화된 기도 제목 필터링 (클라이언트 사이드)
  ///
  /// startDate ≤ selectedDate ≤ endDate (endDate가 null이면 무기한으로 포함)
  ///
  /// Copied from [filteredPrayerList].
  FilteredPrayerListProvider call(String userId) {
    return FilteredPrayerListProvider(userId);
  }

  @override
  FilteredPrayerListProvider getProviderOverride(
    covariant FilteredPrayerListProvider provider,
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
  String? get name => r'filteredPrayerListProvider';
}

/// 선택된 날짜에 활성화된 기도 제목 필터링 (클라이언트 사이드)
///
/// startDate ≤ selectedDate ≤ endDate (endDate가 null이면 무기한으로 포함)
///
/// Copied from [filteredPrayerList].
class FilteredPrayerListProvider extends AutoDisposeProvider<List<Prayer>> {
  /// 선택된 날짜에 활성화된 기도 제목 필터링 (클라이언트 사이드)
  ///
  /// startDate ≤ selectedDate ≤ endDate (endDate가 null이면 무기한으로 포함)
  ///
  /// Copied from [filteredPrayerList].
  FilteredPrayerListProvider(String userId)
    : this._internal(
        (ref) => filteredPrayerList(ref as FilteredPrayerListRef, userId),
        from: filteredPrayerListProvider,
        name: r'filteredPrayerListProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$filteredPrayerListHash,
        dependencies: FilteredPrayerListFamily._dependencies,
        allTransitiveDependencies:
            FilteredPrayerListFamily._allTransitiveDependencies,
        userId: userId,
      );

  FilteredPrayerListProvider._internal(
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
    List<Prayer> Function(FilteredPrayerListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredPrayerListProvider._internal(
        (ref) => create(ref as FilteredPrayerListRef),
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
  AutoDisposeProviderElement<List<Prayer>> createElement() {
    return _FilteredPrayerListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredPrayerListProvider && other.userId == userId;
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
mixin FilteredPrayerListRef on AutoDisposeProviderRef<List<Prayer>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _FilteredPrayerListProviderElement
    extends AutoDisposeProviderElement<List<Prayer>>
    with FilteredPrayerListRef {
  _FilteredPrayerListProviderElement(super.provider);

  @override
  String get userId => (origin as FilteredPrayerListProvider).userId;
}

String _$selectedPrayerDateHash() =>
    r'c2449b774290bfbc4f84df31c03571d86571c731';

/// 캘린더에서 선택된 날짜 Provider
///
/// Copied from [SelectedPrayerDate].
@ProviderFor(SelectedPrayerDate)
final selectedPrayerDateProvider =
    AutoDisposeNotifierProvider<SelectedPrayerDate, DateTime>.internal(
      SelectedPrayerDate.new,
      name: r'selectedPrayerDateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedPrayerDateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedPrayerDate = AutoDisposeNotifier<DateTime>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
