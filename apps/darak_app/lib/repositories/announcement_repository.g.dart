// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$announcementRepositoryHash() =>
    r'ec99d2edbef374f3415058b55f32e90d39f1095d';

/// Firestore `churches/{churchId}/announcements` 서브컬렉션 전담 Repository
///
/// Copied from [announcementRepository].
@ProviderFor(announcementRepository)
final announcementRepositoryProvider =
    AutoDisposeProvider<AnnouncementRepository>.internal(
      announcementRepository,
      name: r'announcementRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$announcementRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnnouncementRepositoryRef =
    AutoDisposeProviderRef<AnnouncementRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
