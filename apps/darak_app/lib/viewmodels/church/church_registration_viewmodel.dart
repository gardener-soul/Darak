import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/church.dart';
import '../../models/church_status.dart';
import '../../repositories/church_repository.dart';
import '../../repositories/church_role_repository.dart';

part 'church_registration_viewmodel.g.dart';

/// 교회 등록 신청 화면의 상태를 관리하는 ViewModel.
/// 폼 제출 및 Firestore 저장을 담당합니다.
@riverpod
class ChurchRegistrationViewModel extends _$ChurchRegistrationViewModel {
  @override
  FutureOr<void> build() {
    // 초기 상태: 아무것도 하지 않음
  }

  /// 교회 등록 신청을 제출합니다.
  /// 성공 시 true를 반환하며, 실패 시 AsyncError 상태로 전환하고 false를 반환합니다.
  Future<bool> submit({
    required String name,
    required String address,
    String? addressDetail,
    required String seniorPastor,
    required String denomination,
    required String requestMemo,
  }) async {
    // 이미 진행 중인 경우 중복 호출 방어 (더블 탭 Race Condition 방지)
    if (state is AsyncLoading) return false;
    state = const AsyncLoading();

    try {
      final now = DateTime.now();
      final church = Church(
        id: '', // Firestore가 자동 생성
        name: name,
        address: address,
        addressDetail: addressDetail,
        seniorPastor: seniorPastor,
        denomination: denomination,
        requestMemo: requestMemo,
        requestedBy: '', // Repository 내부에서 auth.currentUser.uid로 덮어씀
        status: ChurchStatus.pending,
        createdAt: now,
        updatedAt: now,
      );

      final churchId = await ref
          .read(churchRepositoryProvider)
          .requestChurchRegistration(church);

      // 기본 역할 4개(순원/순장/마을장/사역자) 초기화
      await ref
          .read(churchRoleRepositoryProvider)
          .seedDefaultRoles(churchId: churchId);

      state = const AsyncData(null);
      return true;
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
      return false;
    } catch (e, st) {
      state = AsyncError(Exception('교회 등록 신청 중 오류가 발생했습니다.'), st);
      return false;
    }
  }
}
