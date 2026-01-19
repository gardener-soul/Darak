import 'package:freezed_annotation/freezed_annotation.dart';

/// 사용자 역할 enum
enum UserRole {
  @JsonValue('member')
  member, // 순원

  @JsonValue('darak_leader')
  darakLeader, // 다락방 순장

  @JsonValue('village_leader')
  villageLeader, // 마을장

  @JsonValue('evangelist')
  evangelist, // 전도사

  @JsonValue('preacher')
  preacher, // 강도사

  @JsonValue('pastor')
  pastor, // 목사

  @JsonValue('admin')
  admin, // 관리자
}
