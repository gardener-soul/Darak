// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$churchRepositoryHash() => r'0da8a61cb0eb17eea72d692f19f40e335fd5482e';

/// Firestore `churches` 컬렉션 전담 Repository
/// UI 레이어는 이 Repository를 통해서만 교회 데이터에 접근해야 합니다.
///
/// Copied from [churchRepository].
@ProviderFor(churchRepository)
final churchRepositoryProvider = AutoDisposeProvider<ChurchRepository>.internal(
  churchRepository,
  name: r'churchRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$churchRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChurchRepositoryRef = AutoDisposeProviderRef<ChurchRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
