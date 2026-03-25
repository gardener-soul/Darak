// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$onboardingViewModelHash() =>
    r'ec1156efbef4d89039f302b0673e4572848e43e4';

/// 온보딩 과정을 관리하는 ViewModel입니다.
/// 사용자가 입력한 프로필 정보를 메모리에 보관하다가,
/// 최종 제출 시점에 한 번에 Firestore에 저장합니다.
///
/// Copied from [OnboardingViewModel].
@ProviderFor(OnboardingViewModel)
final onboardingViewModelProvider =
    AutoDisposeNotifierProvider<OnboardingViewModel, OnboardingState>.internal(
      OnboardingViewModel.new,
      name: r'onboardingViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$onboardingViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$OnboardingViewModel = AutoDisposeNotifier<OnboardingState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
