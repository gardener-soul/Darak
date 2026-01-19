import 'package:freezed_annotation/freezed_annotation.dart';

/// 클럽 승인 상태 enum
enum ClubStatus {
  @JsonValue('pending')
  pending, // 승인 대기

  @JsonValue('approved')
  approved, // 승인 완료

  @JsonValue('rejected')
  rejected, // 승인 거부
}
