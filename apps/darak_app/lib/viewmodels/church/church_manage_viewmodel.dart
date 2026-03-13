import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repositories/church_repository.dart';
import '../../repositories/church_member_repository.dart';
import '../../repositories/church_role_repository.dart';

part 'church_manage_viewmodel.g.dart';

/// 교회 관리 화면(관리자 전용)의 상태를 관리하는 ViewModel.
/// 교회 기본 정보 수정, 관리자 추가/제거, 멤버 역할 변경, 역할 이름 변경을 담당합니다.
@riverpod
class ChurchManageViewModel extends _$ChurchManageViewModel {
  @override
  FutureOr<void> build(String churchId) {}

  /// 교회 이름, 주소, 담임목사, 교단 정보를 수정합니다.
  Future<bool> updateChurchInfo({
    required String name,
    required String address,
    required String seniorPastor,
    required String denomination,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(churchRepositoryProvider).updateChurchInfo(
            churchId: churchId,
            name: name,
            address: address,
            seniorPastor: seniorPastor,
            denomination: denomination,
          );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// [userId]를 교회 관리자(adminIds)에 추가합니다.
  Future<bool> addAdmin({required String userId}) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(churchRepositoryProvider).addAdminId(
            churchId: churchId,
            userId: userId,
          );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// [userId]를 교회 관리자(adminIds)에서 제거합니다.
  /// 마지막 관리자는 제거할 수 없습니다 (ChurchRepository에서 검증).
  Future<bool> removeAdmin({required String userId}) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(churchRepositoryProvider).removeAdminId(
            churchId: churchId,
            userId: userId,
          );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// 특정 멤버의 교회 내 역할을 변경합니다.
  Future<bool> updateMemberRole({
    required String userId,
    required String newRoleId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(churchMemberRepositoryProvider).updateMemberRole(
            churchId: churchId,
            userId: userId,
            newRoleId: newRoleId,
          );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// 역할의 표시 이름을 변경합니다.
  Future<bool> updateRoleName({
    required String roleId,
    required String newName,
  }) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(churchRoleRepositoryProvider).updateRoleName(
            churchId: churchId,
            roleId: roleId,
            newName: newName,
          );
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}
