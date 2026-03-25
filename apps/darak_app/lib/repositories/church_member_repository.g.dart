// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_member_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$churchMemberRepositoryHash() =>
    r'0b90f77fc737b4dca872e42cd8d7eee8e42d9a2c';

/// Firestore `churches/{churchId}/members` 서브컬렉션 전담 Repository
///
/// Copied from [churchMemberRepository].
@ProviderFor(churchMemberRepository)
final churchMemberRepositoryProvider =
    AutoDisposeProvider<ChurchMemberRepository>.internal(
      churchMemberRepository,
      name: r'churchMemberRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$churchMemberRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChurchMemberRepositoryRef =
    AutoDisposeProviderRef<ChurchMemberRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
