// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_announcements_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$churchRecentAnnouncementsHash() =>
    r'7ca44b6aa409090cc7a524bf246318b67cd6bdc5';

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

/// 교회 상세 화면의 최근 공지사항 3건을 실시간 구독하는 Provider.
/// 홈 미리보기 및 공지 탭 상단 섹션에서 사용합니다.
///
/// Copied from [churchRecentAnnouncements].
@ProviderFor(churchRecentAnnouncements)
const churchRecentAnnouncementsProvider = ChurchRecentAnnouncementsFamily();

/// 교회 상세 화면의 최근 공지사항 3건을 실시간 구독하는 Provider.
/// 홈 미리보기 및 공지 탭 상단 섹션에서 사용합니다.
///
/// Copied from [churchRecentAnnouncements].
class ChurchRecentAnnouncementsFamily
    extends Family<AsyncValue<List<Announcement>>> {
  /// 교회 상세 화면의 최근 공지사항 3건을 실시간 구독하는 Provider.
  /// 홈 미리보기 및 공지 탭 상단 섹션에서 사용합니다.
  ///
  /// Copied from [churchRecentAnnouncements].
  const ChurchRecentAnnouncementsFamily();

  /// 교회 상세 화면의 최근 공지사항 3건을 실시간 구독하는 Provider.
  /// 홈 미리보기 및 공지 탭 상단 섹션에서 사용합니다.
  ///
  /// Copied from [churchRecentAnnouncements].
  ChurchRecentAnnouncementsProvider call(String churchId) {
    return ChurchRecentAnnouncementsProvider(churchId);
  }

  @override
  ChurchRecentAnnouncementsProvider getProviderOverride(
    covariant ChurchRecentAnnouncementsProvider provider,
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
  String? get name => r'churchRecentAnnouncementsProvider';
}

/// 교회 상세 화면의 최근 공지사항 3건을 실시간 구독하는 Provider.
/// 홈 미리보기 및 공지 탭 상단 섹션에서 사용합니다.
///
/// Copied from [churchRecentAnnouncements].
class ChurchRecentAnnouncementsProvider
    extends AutoDisposeStreamProvider<List<Announcement>> {
  /// 교회 상세 화면의 최근 공지사항 3건을 실시간 구독하는 Provider.
  /// 홈 미리보기 및 공지 탭 상단 섹션에서 사용합니다.
  ///
  /// Copied from [churchRecentAnnouncements].
  ChurchRecentAnnouncementsProvider(String churchId)
    : this._internal(
        (ref) => churchRecentAnnouncements(
          ref as ChurchRecentAnnouncementsRef,
          churchId,
        ),
        from: churchRecentAnnouncementsProvider,
        name: r'churchRecentAnnouncementsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$churchRecentAnnouncementsHash,
        dependencies: ChurchRecentAnnouncementsFamily._dependencies,
        allTransitiveDependencies:
            ChurchRecentAnnouncementsFamily._allTransitiveDependencies,
        churchId: churchId,
      );

  ChurchRecentAnnouncementsProvider._internal(
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
    Stream<List<Announcement>> Function(ChurchRecentAnnouncementsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChurchRecentAnnouncementsProvider._internal(
        (ref) => create(ref as ChurchRecentAnnouncementsRef),
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
  AutoDisposeStreamProviderElement<List<Announcement>> createElement() {
    return _ChurchRecentAnnouncementsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChurchRecentAnnouncementsProvider &&
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
mixin ChurchRecentAnnouncementsRef
    on AutoDisposeStreamProviderRef<List<Announcement>> {
  /// The parameter `churchId` of this provider.
  String get churchId;
}

class _ChurchRecentAnnouncementsProviderElement
    extends AutoDisposeStreamProviderElement<List<Announcement>>
    with ChurchRecentAnnouncementsRef {
  _ChurchRecentAnnouncementsProviderElement(super.provider);

  @override
  String get churchId => (origin as ChurchRecentAnnouncementsProvider).churchId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
