import 'package:freezed_annotation/freezed_annotation.dart';

part 'church_member.freezed.dart';
part 'church_member.g.dart';

/// 교회별 교인 매핑 모델
/// Firestore: churches/{churchId}/members/{userId}
/// 문서 ID == userId
@freezed
class ChurchMember with _$ChurchMember {
  const factory ChurchMember({
    required String userId,
    required String roleId, // 교회 내 역할 ID (ChurchRole 참조)
    String? villageId,
    String? groupId,
    required DateTime joinedAt,
    required DateTime updatedAt,
  }) = _ChurchMember;

  factory ChurchMember.fromJson(Map<String, dynamic> json) =>
      _$ChurchMemberFromJson(json);
}
