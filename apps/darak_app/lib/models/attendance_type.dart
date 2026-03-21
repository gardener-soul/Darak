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

/// 출석 유형 한국어 레이블 SSoT
extension AttendanceTypeLabel on AttendanceType {
  String get label {
    switch (this) {
      case AttendanceType.onlySundayService:
        return '주일예배';
      case AttendanceType.onlyDarak:
        return '다락방';
      case AttendanceType.both:
        return '예배+다락방';
      case AttendanceType.specialEvent:
        return '특별집회';
    }
  }
}
