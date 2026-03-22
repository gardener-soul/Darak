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

extension UserRoleX on UserRole {
  /// 역할 계층 레벨 (1 = 순원, 4 = 목사/관리자)
  int get level {
    switch (this) {
      case UserRole.member:
        return 1;
      case UserRole.darakLeader:
        return 2;
      case UserRole.villageLeader:
        return 3;
      case UserRole.evangelist:
      case UserRole.preacher:
      case UserRole.pastor:
      case UserRole.admin:
        return 4;
    }
  }

  /// 화면에 표시할 역할 이름
  String get displayName {
    switch (this) {
      case UserRole.member:
        return '순원';
      case UserRole.darakLeader:
        return '순장';
      case UserRole.villageLeader:
        return '마을장';
      case UserRole.evangelist:
        return '전도사';
      case UserRole.preacher:
        return '강도사';
      case UserRole.pastor:
        return '목사';
      case UserRole.admin:
        return '관리자';
    }
  }

  /// 순장 이상 권한 여부 (메모 열람 등 리더 전용 기능에 사용)
  bool get isLeaderOrAbove => this != UserRole.member;
}
