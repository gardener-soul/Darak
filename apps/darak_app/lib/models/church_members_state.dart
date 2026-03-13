import 'package:freezed_annotation/freezed_annotation.dart';

import 'church_member_profile.dart';

part 'church_members_state.freezed.dart';

/// 구성원 탭 ViewModel 상태 모델
@freezed
class ChurchMembersState with _$ChurchMembersState {
  const factory ChurchMembersState({
    required List<ChurchMemberProfile> members,
    required bool hasMore,
    @Default(null) String? filterRoleId,
    @Default('') String searchQuery,
  }) = _ChurchMembersState;
}
