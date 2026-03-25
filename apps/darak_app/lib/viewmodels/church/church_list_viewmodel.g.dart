// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_list_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$churchListViewModelHash() =>
    r'5346ff422174a2164876689c254a7c731221e40f';

/// 교회 목록 화면의 상태를 관리하는 ViewModel.
/// 교회 목록 스트림 구독 및 교인 등록(joinChurch) 액션을 담당합니다.
///
/// Copied from [ChurchListViewModel].
@ProviderFor(ChurchListViewModel)
final churchListViewModelProvider =
    AutoDisposeStreamNotifierProvider<
      ChurchListViewModel,
      List<Church>
    >.internal(
      ChurchListViewModel.new,
      name: r'churchListViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$churchListViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChurchListViewModel = AutoDisposeStreamNotifier<List<Church>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
