import 'package:freezed_annotation/freezed_annotation.dart';

/// 출석 상태 enum
enum AttendanceStatus {
  @JsonValue('present')
  present, // 출석

  @JsonValue('absent')
  absent, // 결석

  @JsonValue('late')
  late, // 지각

  @JsonValue('excused')
  excused, // 사유 결석

  @JsonValue('etc')
  etc, // 기타
}
