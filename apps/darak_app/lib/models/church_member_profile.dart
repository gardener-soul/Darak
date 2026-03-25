import 'package:freezed_annotation/freezed_annotation.dart';

part 'church_member_profile.freezed.dart';

/// 구성원 탭 UI 표시용 복합 DTO
/// ChurchMember + User 정보를 ViewModel에서 조립하여 생성
/// Firestore에 직접 저장하지 않음 → fromJson 없음
@freezed
class ChurchMemberProfile with _$ChurchMemberProfile {
  const factory ChurchMemberProfile({
    required String userId,
    required String name,
    String? profileImageUrl,
    required String roleId,
    required String roleName, // ChurchRole.name (UI 표시용)
    required int roleLevel, // ChurchRole.level (권한 비교용)
    String? villageId,
    String? villageName,
    String? groupId,
    String? groupName,
    required DateTime joinedAt,
  }) = _ChurchMemberProfile;
}
