import 'package:freezed_annotation/freezed_annotation.dart';
import 'attendance_type.dart';
import 'attendance_status.dart';

part 'attendance.freezed.dart';
part 'attendance.g.dart';

@freezed
class Attendance with _$Attendance {
  const factory Attendance({
    required String id, // 고유 ID
    required String userId, // 사용자 ID (User 참조)
    required AttendanceType type, // 출석 유형 (주일예배, 다락방 등)
    required DateTime date, // 출석 날짜
    required AttendanceStatus status, // 출석 상태 (출석, 결석, 지각)
    String? note, // 비고 (예: 결석 사유)
    String? groupId, // 다락방 출석일 경우 그룹 ID
    required DateTime createdAt, // 생성일시
    required DateTime updatedAt, // 수정일시
    DateTime? deletedAt, // 삭제일시 (Soft Delete)
  }) = _Attendance;

  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);
}
