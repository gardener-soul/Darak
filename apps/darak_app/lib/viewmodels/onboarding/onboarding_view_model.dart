import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/constants/firestore_paths.dart';
import '../../core/providers/firebase_providers.dart';
import '../../core/providers/user_providers.dart';
import '../../core/utils/string_utils.dart';
import '../../repositories/user_repository.dart';
import 'onboarding_state.dart';

part 'onboarding_view_model.g.dart';

/// 온보딩 과정을 관리하는 ViewModel입니다.
/// 사용자가 입력한 프로필 정보와 선택한 그룹 정보를 메모리에 보관하다가,
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

  /// 그룹(다락방)을 선택합니다 (로컬 상태만 변경).
  /// Firestore 호출 없이 메모리 상태만 변경됩니다.
  void selectGroup({
    required String groupId,
    required String groupName,
    String? groupImageUrl,
  }) {
    state = state.copyWith(
      selectedGroupId: groupId,
      selectedGroupName: groupName,
      selectedGroupImageUrl: groupImageUrl,
    );
  }

  /// 온보딩을 최종 제출합니다.
  /// WriteBatch를 사용하여 User 문서 업데이트와 Group memberIds 업데이트를
  /// 원자적(Atomic)으로 처리하여 데이터 불일치를 방지합니다.
  ///
  /// 성공 시 true를 반환합니다.
  /// 실패 시 예외를 던지므로, UI에서 try-catch로 처리해야 합니다.
  Future<bool> submitOnboarding() async {
    // 중복 제출 방어
    if (state.isSubmitting) {
      throw Exception('이미 제출 중입니다. 잠시만 기다려주세요.');
    }

    try {
      // 제출 중 플래그 설정
      state = state.copyWith(isSubmitting: true);

      // 1. 현재 로그인된 유저의 uid 가져오기
      final uid = ref.read(currentUserIdProvider);
      if (uid == null) {
        throw Exception('로그인 정보를 찾을 수 없습니다. 다시 로그인해주세요.');
      }

      // 2. 필수 입력값 검증
      if (state.name.trim().isEmpty) {
        throw Exception('이름을 입력해주세요.');
      }

      if (state.phone.trim().isEmpty) {
        throw Exception('전화번호를 입력해주세요.');
      }

      // 3. 전화번호 형식 검증 (WARNING #4)
      if (!StringUtils.isValidKoreanPhone(state.phone)) {
        throw Exception('올바른 전화번호 형식을 입력해주세요. (예: 010-1234-5678)');
      }

      // 4. 생년월일 유효성 검증 (WARNING #5)
      if (!StringUtils.isValidBirthDate(state.birthDate)) {
        throw Exception('올바른 생년월일을 입력해주세요.');
      }

      // 5. Firestore 인스턴스 가져오기
      final firestore = ref.read(firestoreProvider);
      final batch = firestore.batch();

      // 6. User 문서 업데이트 준비
      final userRef = firestore.collection(FirestorePaths.users).doc(uid);
      final userUpdates = <String, dynamic>{
        'name': StringUtils.sanitize(state.name, maxLength: 50),
        'phone': StringUtils.sanitize(state.phone, maxLength: 20),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (state.birthDate != null) {
        userUpdates['birthDate'] = Timestamp.fromDate(state.birthDate!);
      }

      // 그룹 가입 처리 (선택된 경우만)
      if (state.selectedGroupId != null) {
        userUpdates['groupId'] = state.selectedGroupId;
        userUpdates['groupName'] =
            StringUtils.sanitize(state.selectedGroupName ?? '', maxLength: 100);
        userUpdates['groupImageUrl'] = state.selectedGroupImageUrl;

        // Group 문서의 memberIds 배열에 userId 추가
        final groupRef =
            firestore.collection(FirestorePaths.groups).doc(state.selectedGroupId);
        batch.update(groupRef, {
          'memberIds': FieldValue.arrayUnion([uid]),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // User 문서 업데이트 배치에 추가
      batch.update(userRef, userUpdates);

      // 7. 배치 커밋 (원자적 실행)
      await batch.commit();

      return true;
    } catch (e) {
      // 에러를 다시 던져서 UI에서 사용자에게 알릴 수 있게 함
      rethrow;
    } finally {
      // 제출 완료 후 플래그 해제
      state = state.copyWith(isSubmitting: false);
    }
  }

  /// 그룹 선택을 건너뛰고 온보딩을 완료합니다.
  /// 프로필 정보만 저장하고 그룹 가입은 나중에 할 수 있습니다.
  Future<bool> skipGroupSelection() async {
    // 중복 제출 방어
    if (state.isSubmitting) {
      throw Exception('이미 제출 중입니다. 잠시만 기다려주세요.');
    }

    try {
      // 제출 중 플래그 설정
      state = state.copyWith(isSubmitting: true);

      // 1. 현재 로그인된 유저의 uid 가져오기
      final uid = ref.read(currentUserIdProvider);
      if (uid == null) {
        throw Exception('로그인 정보를 찾을 수 없습니다. 다시 로그인해주세요.');
      }

      // 2. 필수 입력값 검증
      if (state.name.trim().isEmpty) {
        throw Exception('이름을 입력해주세요.');
      }

      if (state.phone.trim().isEmpty) {
        throw Exception('전화번호를 입력해주세요.');
      }

      // 3. 전화번호 형식 검증
      if (!StringUtils.isValidKoreanPhone(state.phone)) {
        throw Exception('올바른 전화번호 형식을 입력해주세요. (예: 010-1234-5678)');
      }

      // 4. 생년월일 유효성 검증
      if (!StringUtils.isValidBirthDate(state.birthDate)) {
        throw Exception('올바른 생년월일을 입력해주세요.');
      }

      // 5. Repository 가져오기
      final userRepo = ref.read(userRepositoryProvider);

      // 6. 프로필만 완성 (그룹 가입 제외)
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
      // 제출 완료 후 플래그 해제
      state = state.copyWith(isSubmitting: false);
    }
  }

  /// 온보딩 상태를 초기화합니다.
  void reset() {
    state = const OnboardingState();
  }
}
