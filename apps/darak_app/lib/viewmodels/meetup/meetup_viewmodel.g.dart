// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meetup_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$meetupViewModelHash() => r'c5c3aed6c84ea7b5f10683435e48a239083873dc';

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

abstract class _$MeetupViewModel
    extends BuildlessAutoDisposeStreamNotifier<MeetupState> {
  late final String churchId;

  Stream<MeetupState> build(String churchId);
}

/// 번개 모임 탭의 상태를 관리하는 ViewModel.
/// 월 단위 스트림 기반으로 캘린더 이벤트 마커 및 날짜 선택 상태를 제공합니다.
///
/// Copied from [MeetupViewModel].
@ProviderFor(MeetupViewModel)
const meetupViewModelProvider = MeetupViewModelFamily();

/// 번개 모임 탭의 상태를 관리하는 ViewModel.
/// 월 단위 스트림 기반으로 캘린더 이벤트 마커 및 날짜 선택 상태를 제공합니다.
///
/// Copied from [MeetupViewModel].
class MeetupViewModelFamily extends Family<AsyncValue<MeetupState>> {
  /// 번개 모임 탭의 상태를 관리하는 ViewModel.
  /// 월 단위 스트림 기반으로 캘린더 이벤트 마커 및 날짜 선택 상태를 제공합니다.
  ///
  /// Copied from [MeetupViewModel].
  const MeetupViewModelFamily();

  /// 번개 모임 탭의 상태를 관리하는 ViewModel.
  /// 월 단위 스트림 기반으로 캘린더 이벤트 마커 및 날짜 선택 상태를 제공합니다.
  ///
  /// Copied from [MeetupViewModel].
  MeetupViewModelProvider call(String churchId) {
    return MeetupViewModelProvider(churchId);
  }

  @override
  MeetupViewModelProvider getProviderOverride(
    covariant MeetupViewModelProvider provider,
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
  String? get name => r'meetupViewModelProvider';
}

/// 번개 모임 탭의 상태를 관리하는 ViewModel.
/// 월 단위 스트림 기반으로 캘린더 이벤트 마커 및 날짜 선택 상태를 제공합니다.
///
/// Copied from [MeetupViewModel].
class MeetupViewModelProvider
    extends
        AutoDisposeStreamNotifierProviderImpl<MeetupViewModel, MeetupState> {
  /// 번개 모임 탭의 상태를 관리하는 ViewModel.
  /// 월 단위 스트림 기반으로 캘린더 이벤트 마커 및 날짜 선택 상태를 제공합니다.
  ///
  /// Copied from [MeetupViewModel].
  MeetupViewModelProvider(String churchId)
    : this._internal(
        () => MeetupViewModel()..churchId = churchId,
        from: meetupViewModelProvider,
        name: r'meetupViewModelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$meetupViewModelHash,
        dependencies: MeetupViewModelFamily._dependencies,
        allTransitiveDependencies:
            MeetupViewModelFamily._allTransitiveDependencies,
        churchId: churchId,
      );

  MeetupViewModelProvider._internal(
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
  Stream<MeetupState> runNotifierBuild(covariant MeetupViewModel notifier) {
    return notifier.build(churchId);
  }

  @override
  Override overrideWith(MeetupViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: MeetupViewModelProvider._internal(
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
  AutoDisposeStreamNotifierProviderElement<MeetupViewModel, MeetupState>
  createElement() {
    return _MeetupViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MeetupViewModelProvider && other.churchId == churchId;
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
mixin MeetupViewModelRef on AutoDisposeStreamNotifierProviderRef<MeetupState> {
  /// The parameter `churchId` of this provider.
  String get churchId;
}

class _MeetupViewModelProviderElement
    extends
        AutoDisposeStreamNotifierProviderElement<MeetupViewModel, MeetupState>
    with MeetupViewModelRef {
  _MeetupViewModelProviderElement(super.provider);

  @override
  String get churchId => (origin as MeetupViewModelProvider).churchId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
