import 'package:freezed_annotation/freezed_annotation.dart';

/// 교회 등록 신청 상태 enum
enum ChurchStatus {
  @JsonValue('pending')
  pending, // 검토 중

  @JsonValue('approved')
  approved, // 승인됨

  @JsonValue('rejected')
  rejected, // 거절됨
}
