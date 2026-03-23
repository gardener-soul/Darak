import 'package:freezed_annotation/freezed_annotation.dart';

import 'follow_status.dart';

part 'follow.freezed.dart';
part 'follow.g.dart';

// ─── JSON Converter: FollowStatus ─────────────────────────────────────────────

class FollowStatusConverter implements JsonConverter<FollowStatus, String> {
  const FollowStatusConverter();

  @override
  FollowStatus fromJson(String json) => FollowStatusX.fromJson(json);

  @override
  String toJson(FollowStatus object) => object.toJson();
}

// ─── Follow 모델 ──────────────────────────────────────────────────────────────

/// 팔로우 관계를 나타내는 모델
///
/// 문서 ID 패턴: `{followerId}_{followeeId}` (중복 팔로우 방지)
@freezed
class Follow with _$Follow {
  const factory Follow({
    required String id, // 고유 ID: {followerId}_{followeeId}
    required String followerId, // 팔로우를 보낸 사용자 ID
    required String followeeId, // 팔로우를 받은 사용자 ID
    required String churchId, // 소속 교회 ID
    @FollowStatusConverter() required FollowStatus status, // 팔로우 상태
    required DateTime createdAt, // 팔로우 요청 생성일시
    DateTime? acceptedAt, // 팔로우 수락일시
    required DateTime updatedAt, // 수정일시
  }) = _Follow;

  factory Follow.fromJson(Map<String, dynamic> json) => _$FollowFromJson(json);
}
