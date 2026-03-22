// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_detail_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$memberAttendanceHistoryHash() =>
    r'45e3bc8db08ce16752e3fc7a503125d119d40b87';

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

/// See also [memberAttendanceHistory].
@ProviderFor(memberAttendanceHistory)
const memberAttendanceHistoryProvider = MemberAttendanceHistoryFamily();

/// See also [memberAttendanceHistory].
class MemberAttendanceHistoryFamily
    extends Family<AsyncValue<List<Attendance>>> {
  /// See also [memberAttendanceHistory].
  const MemberAttendanceHistoryFamily();

  /// See also [memberAttendanceHistory].
  MemberAttendanceHistoryProvider call(String userId) {
    return MemberAttendanceHistoryProvider(userId);
  }

  @override
  MemberAttendanceHistoryProvider getProviderOverride(
    covariant MemberAttendanceHistoryProvider provider,
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
  String? get name => r'memberAttendanceHistoryProvider';
}

/// See also [memberAttendanceHistory].
class MemberAttendanceHistoryProvider
    extends AutoDisposeFutureProvider<List<Attendance>> {
  /// See also [memberAttendanceHistory].
  MemberAttendanceHistoryProvider(String userId)
    : this._internal(
        (ref) =>
            memberAttendanceHistory(ref as MemberAttendanceHistoryRef, userId),
        from: memberAttendanceHistoryProvider,
        name: r'memberAttendanceHistoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$memberAttendanceHistoryHash,
        dependencies: MemberAttendanceHistoryFamily._dependencies,
        allTransitiveDependencies:
            MemberAttendanceHistoryFamily._allTransitiveDependencies,
        userId: userId,
      );

  MemberAttendanceHistoryProvider._internal(
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
    FutureOr<List<Attendance>> Function(MemberAttendanceHistoryRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MemberAttendanceHistoryProvider._internal(
        (ref) => create(ref as MemberAttendanceHistoryRef),
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
    return _MemberAttendanceHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberAttendanceHistoryProvider && other.userId == userId;
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
mixin MemberAttendanceHistoryRef
    on AutoDisposeFutureProviderRef<List<Attendance>> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _MemberAttendanceHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Attendance>>
    with MemberAttendanceHistoryRef {
  _MemberAttendanceHistoryProviderElement(super.provider);

  @override
  String get userId => (origin as MemberAttendanceHistoryProvider).userId;
}

String _$memberDetailViewModelHash() =>
    r'2ed3f0942ad3fc8c0333e7479a07dff8b86f75d8';

abstract class _$MemberDetailViewModel
    extends BuildlessAutoDisposeNotifier<MemberDetailState> {
  late final String userId;

  MemberDetailState build(String userId);
}

/// See also [MemberDetailViewModel].
@ProviderFor(MemberDetailViewModel)
const memberDetailViewModelProvider = MemberDetailViewModelFamily();

/// See also [MemberDetailViewModel].
class MemberDetailViewModelFamily extends Family<MemberDetailState> {
  /// See also [MemberDetailViewModel].
  const MemberDetailViewModelFamily();

  /// See also [MemberDetailViewModel].
  MemberDetailViewModelProvider call(String userId) {
    return MemberDetailViewModelProvider(userId);
  }

  @override
  MemberDetailViewModelProvider getProviderOverride(
    covariant MemberDetailViewModelProvider provider,
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
  String? get name => r'memberDetailViewModelProvider';
}

/// See also [MemberDetailViewModel].
class MemberDetailViewModelProvider
    extends
        AutoDisposeNotifierProviderImpl<
          MemberDetailViewModel,
          MemberDetailState
        > {
  /// See also [MemberDetailViewModel].
  MemberDetailViewModelProvider(String userId)
    : this._internal(
        () => MemberDetailViewModel()..userId = userId,
        from: memberDetailViewModelProvider,
        name: r'memberDetailViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$memberDetailViewModelHash,
        dependencies: MemberDetailViewModelFamily._dependencies,
        allTransitiveDependencies:
            MemberDetailViewModelFamily._allTransitiveDependencies,
        userId: userId,
      );

  MemberDetailViewModelProvider._internal(
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
  MemberDetailState runNotifierBuild(covariant MemberDetailViewModel notifier) {
    return notifier.build(userId);
  }

  @override
  Override overrideWith(MemberDetailViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: MemberDetailViewModelProvider._internal(
        () => create()..userId = userId,
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
  AutoDisposeNotifierProviderElement<MemberDetailViewModel, MemberDetailState>
  createElement() {
    return _MemberDetailViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MemberDetailViewModelProvider && other.userId == userId;
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
mixin MemberDetailViewModelRef
    on AutoDisposeNotifierProviderRef<MemberDetailState> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _MemberDetailViewModelProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          MemberDetailViewModel,
          MemberDetailState
        >
    with MemberDetailViewModelRef {
  _MemberDetailViewModelProviderElement(super.provider);

  @override
  String get userId => (origin as MemberDetailViewModelProvider).userId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
