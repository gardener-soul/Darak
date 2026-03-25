import 'package:freezed_annotation/freezed_annotation.dart';

/// 출석 유형 enum
enum AttendanceType {
  @JsonValue('onlySundayService')
  onlySundayService, // 주일예배만

  @JsonValue('prayer_meeting')
  prayerMeeting, // 기도회

  @JsonValue('special_event')
  specialEvent, // 집회
}

/// 출석 유형 한국어 레이블 SSoT
extension AttendanceTypeLabel on AttendanceType {
  String get label {
    switch (this) {
      case AttendanceType.onlySundayService:
        return '주일예배';
      case AttendanceType.prayerMeeting:
        return '기도회';
      case AttendanceType.specialEvent:
        return '집회';
    }
  }
}
