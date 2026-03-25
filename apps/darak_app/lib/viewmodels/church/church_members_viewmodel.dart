import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/church_members_state.dart';
import '../../models/church_member_profile.dart';
import '../../repositories/church_member_repository.dart';
import '../../repositories/church_role_repository.dart';
import '../../repositories/user_repository.dart';

part 'church_members_viewmodel.g.dart';

/// 구성원 탭의 상태를 관리하는 ViewModel.
/// ChurchMember + User + ChurchRole 데이터를 조립하여 ChurchMemberProfile 목록을 제공합니다.
/// 역할 필터링 및 이름 검색을 지원합니다.
@riverpod
class ChurchMembersViewModel extends _$ChurchMembersViewModel {
  String? _filterRoleId;
  String _searchQuery = '';

  @override
  Future<ChurchMembersState> build(String churchId) async {
    return _loadMembers(churchId: churchId);
  }

  Future<ChurchMembersState> _loadMembers({required String churchId}) async {
    final memberRepo = ref.read(churchMemberRepositoryProvider);
    final roleRepo = ref.read(churchRoleRepositoryProvider);
    final userRepo = ref.read(userRepositoryProvider);

    // 역할 목록을 Map으로 변환하여 O(1) 조회 가능하게 캐싱
    final roles = await roleRepo.getRoles(churchId: churchId);
    final roleMap = {for (final r in roles) r.id: r};

    // limit을 200으로 설정하여 일반적인 교회 규모에서 모든 멤버가 조회되도록 함
    // 관리자(adminIds 포함) 계정이 limit 초과로 누락되는 문제 방지
    final members = await memberRepo.getMembers(
      churchId: churchId,
      filterRoleId: _filterRoleId,
      limit: 200,
    );

    // N+1 방지: 모든 멤버의 유저 프로필을 병렬로 한 번에 조회
    final userFutures = members.map((m) => userRepo.getUserById(m.userId));
    final users = await Future.wait(userFutures);

    final profiles = <ChurchMemberProfile>[];
    for (var i = 0; i < members.length; i++) {
      final member = members[i];
      final user = users[i];

      // 유저 정보가 없으면 해당 멤버는 스킵 (Null-safety 방어)
      if (user == null) continue;

      // 검색어가 있으면 이름 포함 여부로 필터링 (대소문자 구분 없음)
      if (_searchQuery.isNotEmpty &&
          !user.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
        continue;
      }

      final role = roleMap[member.roleId];
      profiles.add(ChurchMemberProfile(
        userId: member.userId,
        name: user.name,
        profileImageUrl: user.profileImageUrl,
        roleId: member.roleId,
        roleName: role?.name ?? member.roleId,
        roleLevel: role?.level ?? 1,
        villageId: member.villageId,
        groupId: member.groupId,
        joinedAt: member.joinedAt,
      ));
    }

    return ChurchMembersState(
      members: profiles,
      hasMore: members.length >= 200,
      filterRoleId: _filterRoleId,
      searchQuery: _searchQuery,
    );
  }

  /// 역할 필터를 변경하고 목록을 재조회합니다.
  /// null을 전달하면 필터 해제(전체 보기) 상태로 돌아갑니다.
  void setFilter(String? roleId) {
    _filterRoleId = roleId;
    ref.invalidateSelf();
  }

  /// 검색어를 변경하고 목록을 재조회합니다.
  void setSearchQuery(String query) {
    _searchQuery = query;
    ref.invalidateSelf();
  }
}
