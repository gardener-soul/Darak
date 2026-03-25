// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_schedule_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$churchScheduleRepositoryHash() =>
    r'd628b3b8adbb0286f14b0a25d9758ad3944e76a8';

/// Firestore `churches/{churchId}/schedules` 서브컬렉션 전담 Repository
///
/// Copied from [churchScheduleRepository].
@ProviderFor(churchScheduleRepository)
final churchScheduleRepositoryProvider =
    AutoDisposeProvider<ChurchScheduleRepository>.internal(
      churchScheduleRepository,
      name: r'churchScheduleRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$churchScheduleRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChurchScheduleRepositoryRef =
    AutoDisposeProviderRef<ChurchScheduleRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
