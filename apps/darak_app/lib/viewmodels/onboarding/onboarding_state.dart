import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

/// 온보딩 과정에서 사용자가 입력한 데이터를 메모리에 임시 보관하는 상태 객체입니다.
/// 최종 제출 시점에 한 번만 Firestore에 Write하여 네트워크 비용을 절감하고
/// 부분 실패(Partial Failure)로 인한 데이터 불일치를 방지합니다.
@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    /// 사용자 이름
    @Default('') String name,

    /// 전화번호
    @Default('') String phone,

    /// 생년월일 (선택)
    DateTime? birthDate,

    /// 온보딩 제출 중 여부 (중복 제출 방어)
    @Default(false) bool isSubmitting,
  }) = _OnboardingState;
}
