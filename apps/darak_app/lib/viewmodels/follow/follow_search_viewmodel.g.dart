// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_search_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$followSearchViewModelHash() =>
    r'3ce1a5b5eb11a9c8cc0036e0d5e722e926f80bf6';

/// 같은 교회 내 교인 검색 + 팔로우 상태 표시 + 팔로우 요청 전송 ViewModel
///
/// Copied from [FollowSearchViewModel].
@ProviderFor(FollowSearchViewModel)
final followSearchViewModelProvider =
    AutoDisposeAsyncNotifierProvider<
      FollowSearchViewModel,
      List<FollowSearchResult>
    >.internal(
      FollowSearchViewModel.new,
      name: r'followSearchViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$followSearchViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FollowSearchViewModel =
    AutoDisposeAsyncNotifier<List<FollowSearchResult>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
