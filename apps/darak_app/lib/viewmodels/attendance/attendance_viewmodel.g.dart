// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$groupAttendanceByMonthHash() =>
    r'e5cb42b7a4f19a6402e8cd0a5fd247a2a6496904';

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

/// 다락방별 월별 출석 스트림 Provider (AttendanceHistorySheet용)
///
/// Copied from [groupAttendanceByMonth].
@ProviderFor(groupAttendanceByMonth)
const groupAttendanceByMonthProvider = GroupAttendanceByMonthFamily();

/// 다락방별 월별 출석 스트림 Provider (AttendanceHistorySheet용)
///
/// Copied from [groupAttendanceByMonth].
class GroupAttendanceByMonthFamily
    extends Family<AsyncValue<List<Attendance>>> {
  /// 다락방별 월별 출석 스트림 Provider (AttendanceHistorySheet용)
  ///
  /// Copied from [groupAttendanceByMonth].
  const GroupAttendanceByMonthFamily();

  /// 다락방별 월별 출석 스트림 Provider (AttendanceHistorySheet용)
  ///
  /// Copied from [groupAttendanceByMonth].
  GroupAttendanceByMonthProvider call(String groupId, int year, int month) {
    return GroupAttendanceByMonthProvider(groupId, year, month);
  }

  @override
  GroupAttendanceByMonthProvider getProviderOverride(
    covariant GroupAttendanceByMonthProvider provider,
  ) {
    return call(provider.groupId, provider.year, provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'groupAttendanceByMonthProvider';
}

/// 다락방별 월별 출석 스트림 Provider (AttendanceHistorySheet용)
///
/// Copied from [groupAttendanceByMonth].
class GroupAttendanceByMonthProvider
    extends AutoDisposeStreamProvider<List<Attendance>> {
  /// 다락방별 월별 출석 스트림 Provider (AttendanceHistorySheet용)
  ///
  /// Copied from [groupAttendanceByMonth].
  GroupAttendanceByMonthProvider(String groupId, int year, int month)
    : this._internal(
        (ref) => groupAttendanceByMonth(
          ref as GroupAttendanceByMonthRef,
          groupId,
          year,
          month,
        ),
        from: groupAttendanceByMonthProvider,
        name: r'groupAttendanceByMonthProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$groupAttendanceByMonthHash,
        dependencies: GroupAttendanceByMonthFamily._dependencies,
        allTransitiveDependencies:
            GroupAttendanceByMonthFamily._allTransitiveDependencies,
        groupId: groupId,
        year: year,
        month: month,
      );

  GroupAttendanceByMonthProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
    required this.year,
    required this.month,
  }) : super.internal();

  final String groupId;
  final int year;
  final int month;

  @override
  Override overrideWith(
    Stream<List<Attendance>> Function(GroupAttendanceByMonthRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GroupAttendanceByMonthProvider._internal(
        (ref) => create(ref as GroupAttendanceByMonthRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Attendance>> createElement() {
    return _GroupAttendanceByMonthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GroupAttendanceByMonthProvider &&
        other.groupId == groupId &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GroupAttendanceByMonthRef
    on AutoDisposeStreamProviderRef<List<Attendance>> {
  /// The parameter `groupId` of this provider.
  String get groupId;

  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _GroupAttendanceByMonthProviderElement
    extends AutoDisposeStreamProviderElement<List<Attendance>>
    with GroupAttendanceByMonthRef {
  _GroupAttendanceByMonthProviderElement(super.provider);

  @override
  String get groupId => (origin as GroupAttendanceByMonthProvider).groupId;
  @override
  int get year => (origin as GroupAttendanceByMonthProvider).year;
  @override
  int get month => (origin as GroupAttendanceByMonthProvider).month;
}

String _$villageAttendanceSummaryHash() =>
    r'e33b7a06c42cd92d71e93361ee0aa7646d26ee9c';

/// 마을 전체 출석 현황 Provider (VillageAttendanceSheet용)
///
/// Copied from [villageAttendanceSummary].
@ProviderFor(villageAttendanceSummary)
const villageAttendanceSummaryProvider = VillageAttendanceSummaryFamily();

/// 마을 전체 출석 현황 Provider (VillageAttendanceSheet용)
///
/// Copied from [villageAttendanceSummary].
class VillageAttendanceSummaryFamily
    extends Family<AsyncValue<List<Attendance>>> {
  /// 마을 전체 출석 현황 Provider (VillageAttendanceSheet용)
  ///
  /// Copied from [villageAttendanceSummary].
  const VillageAttendanceSummaryFamily();

  /// 마을 전체 출석 현황 Provider (VillageAttendanceSheet용)
  ///
  /// Copied from [villageAttendanceSummary].
  VillageAttendanceSummaryProvider call(
    List<String> groupIds,
    DateTime startDate,
    DateTime endDate,
  ) {
    return VillageAttendanceSummaryProvider(groupIds, startDate, endDate);
  }

  @override
  VillageAttendanceSummaryProvider getProviderOverride(
    covariant VillageAttendanceSummaryProvider provider,
  ) {
    return call(provider.groupIds, provider.startDate, provider.endDate);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'villageAttendanceSummaryProvider';
}

/// 마을 전체 출석 현황 Provider (VillageAttendanceSheet용)
///
/// Copied from [villageAttendanceSummary].
class VillageAttendanceSummaryProvider
    extends AutoDisposeFutureProvider<List<Attendance>> {
  /// 마을 전체 출석 현황 Provider (VillageAttendanceSheet용)
  ///
  /// Copied from [villageAttendanceSummary].
  VillageAttendanceSummaryProvider(
    List<String> groupIds,
    DateTime startDate,
    DateTime endDate,
  ) : this._internal(
        (ref) => villageAttendanceSummary(
          ref as VillageAttendanceSummaryRef,
          groupIds,
          startDate,
          endDate,
        ),
        from: villageAttendanceSummaryProvider,
        name: r'villageAttendanceSummaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$villageAttendanceSummaryHash,
        dependencies: VillageAttendanceSummaryFamily._dependencies,
        allTransitiveDependencies:
            VillageAttendanceSummaryFamily._allTransitiveDependencies,
        groupIds: groupIds,
        startDate: startDate,
        endDate: endDate,
      );

  VillageAttendanceSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupIds,
    required this.startDate,
    required this.endDate,
  }) : super.internal();

  final List<String> groupIds;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Override overrideWith(
    FutureOr<List<Attendance>> Function(VillageAttendanceSummaryRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VillageAttendanceSummaryProvider._internal(
        (ref) => create(ref as VillageAttendanceSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupIds: groupIds,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Attendance>> createElement() {
    return _VillageAttendanceSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VillageAttendanceSummaryProvider &&
        other.groupIds == groupIds &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupIds.hashCode);
    hash = _SystemHash.combine(hash, startDate.hashCode);
    hash = _SystemHash.combine(hash, endDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VillageAttendanceSummaryRef
    on AutoDisposeFutureProviderRef<List<Attendance>> {
  /// The parameter `groupIds` of this provider.
  List<String> get groupIds;

  /// The parameter `startDate` of this provider.
  DateTime get startDate;

  /// The parameter `endDate` of this provider.
  DateTime get endDate;
}

class _VillageAttendanceSummaryProviderElement
    extends AutoDisposeFutureProviderElement<List<Attendance>>
    with VillageAttendanceSummaryRef {
  _VillageAttendanceSummaryProviderElement(super.provider);

  @override
  List<String> get groupIds =>
      (origin as VillageAttendanceSummaryProvider).groupIds;
  @override
  DateTime get startDate =>
      (origin as VillageAttendanceSummaryProvider).startDate;
  @override
  DateTime get endDate => (origin as VillageAttendanceSummaryProvider).endDate;
}

String _$myAttendanceHistoryHash() =>
    r'06766bfadf24dd4c782b9d775a6ae912cdb5f103';

/// 마이페이지용 내 출석 이력 Provider
///
/// Copied from [myAttendanceHistory].
@ProviderFor(myAttendanceHistory)
const myAttendanceHistoryProvider = MyAttendanceHistoryFamily();

/// 마이페이지용 내 출석 이력 Provider
///
/// Copied from [myAttendanceHistory].
class MyAttendanceHistoryFamily extends Family<AsyncValue<List<Attendance>>> {
  /// 마이페이지용 내 출석 이력 Provider
  ///
  /// Copied from [myAttendanceHistory].
  const MyAttendanceHistoryFamily();

  /// 마이페이지용 내 출석 이력 Provider
  ///
  /// Copied from [myAttendanceHistory].
  MyAttendanceHistoryProvider call(String userId) {
    return MyAttendanceHistoryProvider(userId);
  }

  @override
  MyAttendanceHistoryProvider getProviderOverride(
    covariant MyAttendanceHistoryProvider provider,
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
  String? get name => r'myAttendanceHistoryProvider';
}

/// 마이페이지용 내 출석 이력 Provider
///
/// Copied from [myAttendanceHistory].
class MyAttendanceHistoryProvider
    extends AutoDisposeFutureProvider<List<Attendance>> {
  /// 마이페이지용 내 출석 이력 Provider
  ///
  /// Copied from [myAttendanceHistory].
  MyAttendanceHistoryProvider(String userId)
    : this._internal(
        (ref) => myAttendanceHistory(ref as MyAttendanceHistoryRef, userId),
        from: myAttendanceHistoryProvider,
        name: r'myAttendanceHistoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$myAttendanceHistoryHash,
        dependencies: MyAttendanceHistoryFamily._dependencies,
        allTransitiveDependencies:
            MyAttendanceHistoryFamily._allTransitiveDependencies,
        userId: userId,
      );

  MyAttendanceHistoryProvider._internal(
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
    FutureOr<List<Attendance>> Function(MyAttendanceHistoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MyAttendanceHistoryProvider._internal(
        (ref) => create(ref as MyAttendanceHistoryRef),
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
  AutoDisposeFutureProviderElement<List<Attendance>> createElement() {
    return _MyAttendanceHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyAttendanceHistoryProvider && other.userId == userId;
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
mixin MyAttendanceHistoryRef on AutoDisposeFutureProviderRef<List<Attendance>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _MyAttendanceHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Attendance>>
    with MyAttendanceHistoryRef {
  _MyAttendanceHistoryProviderElement(super.provider);

  @override
  String get userId => (origin as MyAttendanceHistoryProvider).userId;
}

String _$recentGroupAttendancesHash() =>
    r'68c9c4fa54fd106b1710e5222ca186fa395bd755';

/// 그룹 최근 출석 요약 Provider (GroupDetailBottomSheet용)
///
/// Copied from [recentGroupAttendances].
@ProviderFor(recentGroupAttendances)
const recentGroupAttendancesProvider = RecentGroupAttendancesFamily();

/// 그룹 최근 출석 요약 Provider (GroupDetailBottomSheet용)
///
/// Copied from [recentGroupAttendances].
class RecentGroupAttendancesFamily
    extends Family<AsyncValue<List<Attendance>>> {
  /// 그룹 최근 출석 요약 Provider (GroupDetailBottomSheet용)
  ///
  /// Copied from [recentGroupAttendances].
  const RecentGroupAttendancesFamily();

  /// 그룹 최근 출석 요약 Provider (GroupDetailBottomSheet용)
  ///
  /// Copied from [recentGroupAttendances].
  RecentGroupAttendancesProvider call(String groupId) {
    return RecentGroupAttendancesProvider(groupId);
  }

  @override
  RecentGroupAttendancesProvider getProviderOverride(
    covariant RecentGroupAttendancesProvider provider,
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
  String? get name => r'recentGroupAttendancesProvider';
}

/// 그룹 최근 출석 요약 Provider (GroupDetailBottomSheet용)
///
/// Copied from [recentGroupAttendances].
class RecentGroupAttendancesProvider
    extends AutoDisposeFutureProvider<List<Attendance>> {
  /// 그룹 최근 출석 요약 Provider (GroupDetailBottomSheet용)
  ///
  /// Copied from [recentGroupAttendances].
  RecentGroupAttendancesProvider(String groupId)
    : this._internal(
        (ref) =>
            recentGroupAttendances(ref as RecentGroupAttendancesRef, groupId),
        from: recentGroupAttendancesProvider,
        name: r'recentGroupAttendancesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$recentGroupAttendancesHash,
        dependencies: RecentGroupAttendancesFamily._dependencies,
        allTransitiveDependencies:
            RecentGroupAttendancesFamily._allTransitiveDependencies,
        groupId: groupId,
      );

  RecentGroupAttendancesProvider._internal(
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
    FutureOr<List<Attendance>> Function(RecentGroupAttendancesRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecentGroupAttendancesProvider._internal(
        (ref) => create(ref as RecentGroupAttendancesRef),
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
  AutoDisposeFutureProviderElement<List<Attendance>> createElement() {
    return _RecentGroupAttendancesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentGroupAttendancesProvider && other.groupId == groupId;
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
mixin RecentGroupAttendancesRef
    on AutoDisposeFutureProviderRef<List<Attendance>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _RecentGroupAttendancesProviderElement
    extends AutoDisposeFutureProviderElement<List<Attendance>>
    with RecentGroupAttendancesRef {
  _RecentGroupAttendancesProviderElement(super.provider);

  @override
  String get groupId => (origin as RecentGroupAttendancesProvider).groupId;
}

String _$attendanceCheckViewModelHash() =>
    r'f5ad965af91f3b2c1b68321021ea71c8f75af685';

/// See also [AttendanceCheckViewModel].
@ProviderFor(AttendanceCheckViewModel)
final attendanceCheckViewModelProvider =
    AutoDisposeNotifierProvider<
      AttendanceCheckViewModel,
      AttendanceCheckState
    >.internal(
      AttendanceCheckViewModel.new,
      name: r'attendanceCheckViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$attendanceCheckViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AttendanceCheckViewModel = AutoDisposeNotifier<AttendanceCheckState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
