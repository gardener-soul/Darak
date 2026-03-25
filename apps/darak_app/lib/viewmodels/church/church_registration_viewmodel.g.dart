// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_registration_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$churchRegistrationViewModelHash() =>
    r'f0b39f71fe9159c41a324d4ceeb783d7bac35a92';

/// 교회 등록 신청 화면의 상태를 관리하는 ViewModel.
/// 폼 제출 및 Firestore 저장을 담당합니다.
///
/// Copied from [ChurchRegistrationViewModel].
@ProviderFor(ChurchRegistrationViewModel)
final churchRegistrationViewModelProvider =
    AutoDisposeAsyncNotifierProvider<
      ChurchRegistrationViewModel,
      void
    >.internal(
      ChurchRegistrationViewModel.new,
      name: r'churchRegistrationViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$churchRegistrationViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChurchRegistrationViewModel = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
