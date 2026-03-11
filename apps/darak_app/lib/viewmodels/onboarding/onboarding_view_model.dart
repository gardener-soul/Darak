import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/providers/user_providers.dart';
import '../../core/utils/string_utils.dart';
import '../../repositories/user_repository.dart';
import 'onboarding_state.dart';

part 'onboarding_view_model.g.dart';

/// 온보딩 과정을 관리하는 ViewModel입니다.
/// 사용자가 입력한 프로필 정보를 메모리에 보관하다가,
/// 최종 제출 시점에 한 번에 Firestore에 저장합니다.
@riverpod
class OnboardingViewModel extends _$OnboardingViewModel {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  /// 프로필 데이터를 업데이트합니다 (로컬 상태만 변경).
  /// Firestore 호출 없이 메모리 상태만 변경됩니다.
  void updateProfileData({
    String? name,
    String? phone,
    DateTime? birthDate,
  }) {
    // 생년월일 유효성 검증 (미래 날짜 및 120년 이상 과거 방어)
    if (birthDate != null && !StringUtils.isValidBirthDate(birthDate)) {
      throw Exception('올바른 생년월일을 입력해주세요.');
    }

    state = state.copyWith(
      name: name ?? state.name,
      phone: phone ?? state.phone,
      birthDate: birthDate ?? state.birthDate,
    );
  }

  /// 공통 검증 로직
  void _validateOnboardingData() {
    if (state.name.trim().isEmpty) {
      throw Exception('이름을 입력해주세요.');
    }

    if (state.phone.trim().isEmpty) {
      throw Exception('전화번호를 입력해주세요.');
    }

    if (!StringUtils.isValidKoreanPhone(state.phone)) {
      throw Exception('올바른 전화번호 형식을 입력해주세요. (예: 010-1234-5678)');
    }

    if (!StringUtils.isValidBirthDate(state.birthDate)) {
      throw Exception('올바른 생년월일을 입력해주세요.');
    }
  }

  /// 온보딩을 최종 제출합니다.
  /// 프로필 정보(이름, 전화번호, 생년월일)를 Firestore에 저장합니다.
  ///
  /// 성공 시 true를 반환합니다.
  /// 실패 시 예외를 던지므로, UI에서 try-catch로 처리해야 합니다.
  Future<bool> submitOnboarding() async {
    if (state.isSubmitting) {
      throw Exception('이미 제출 중입니다. 잠시만 기다려주세요.');
    }

    try {
      state = state.copyWith(isSubmitting: true);

      final uid = ref.read(currentUserIdProvider);
      if (uid == null) {
        throw Exception('로그인 정보를 찾을 수 없습니다. 다시 로그인해주세요.');
      }

      _validateOnboardingData();

      final userRepo = ref.read(userRepositoryProvider);
      await userRepo.completeProfile(
        uid,
        name: state.name,
        phone: state.phone,
        birthDate: state.birthDate,
      );

      return true;
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }

  /// 온보딩 상태를 초기화합니다.
  void reset() {
    state = const OnboardingState();
  }
}
