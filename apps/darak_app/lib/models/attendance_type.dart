import 'package:freezed_annotation/freezed_annotation.dart';

/// 출석 유형 enum
enum AttendanceType {
  @JsonValue('onlySundayService')
  onlySundayService, // 주일예배만

  @JsonValue('onlyDarak')
  onlyDarak, // 다락방만

  @JsonValue('both')
  both, // 주일예배 + 다락방

  @JsonValue('special_event')
  specialEvent, // 특별 행사
}
