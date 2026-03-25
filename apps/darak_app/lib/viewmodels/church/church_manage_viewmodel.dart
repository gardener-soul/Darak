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

  /// 비동기 작업을 실행하고 AsyncValue 상태를 관리하는 공통 헬퍼.
  /// 성공 시 true, 실패 시 false를 반환합니다.
  Future<bool> _executeAsync(Future<void> Function() action) async {
    state = const AsyncValue.loading();
    try {
      await action();
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// 교회 이름, 주소, 담임목사, 교단 정보를 수정합니다.
  Future<bool> updateChurchInfo({
    required String name,
    required String address,
    required String seniorPastor,
    required String denomination,
  }) =>
      _executeAsync(
        () => ref.read(churchRepositoryProvider).updateChurchInfo(
              churchId: churchId,
              name: name,
              address: address,
              seniorPastor: seniorPastor,
              denomination: denomination,
            ),
      );

  /// [userId]를 교회 관리자(adminIds)에 추가합니다.
  Future<bool> addAdmin({required String userId}) => _executeAsync(
        () => ref.read(churchRepositoryProvider).addAdminId(
              churchId: churchId,
              userId: userId,
            ),
      );

  /// [userId]를 교회 관리자(adminIds)에서 제거합니다.
  /// 마지막 관리자는 제거할 수 없습니다 (ChurchRepository에서 검증).
  Future<bool> removeAdmin({required String userId}) => _executeAsync(
        () => ref.read(churchRepositoryProvider).removeAdminId(
              churchId: churchId,
              userId: userId,
            ),
      );

  /// 특정 멤버의 교회 내 역할을 변경합니다.
  Future<bool> updateMemberRole({
    required String userId,
    required String newRoleId,
  }) =>
      _executeAsync(
        () => ref.read(churchMemberRepositoryProvider).updateMemberRole(
              churchId: churchId,
              userId: userId,
              newRoleId: newRoleId,
            ),
      );

  /// 역할의 표시 이름을 변경합니다.
  Future<bool> updateRoleName({
    required String roleId,
    required String newName,
  }) =>
      _executeAsync(
        () => ref.read(churchRoleRepositoryProvider).updateRoleName(
              churchId: churchId,
              roleId: roleId,
              newName: newName,
            ),
      );
}
