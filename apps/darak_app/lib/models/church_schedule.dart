import 'package:freezed_annotation/freezed_annotation.dart';

part 'church_schedule.freezed.dart';
part 'church_schedule.g.dart';

/// 교회 일정 카테고리
enum ScheduleCategory {
  @JsonValue('worship')
  worship, // 예배

  @JsonValue('event')
  event, // 행사

  @JsonValue('meeting')
  meeting, // 모임
}

/// 교회 일정 모델
/// Firestore: churches/{churchId}/schedules/{scheduleId}
@freezed
class ChurchSchedule with _$ChurchSchedule {
  const factory ChurchSchedule({
    required String id,
    required String title,
    String? description,
    required ScheduleCategory category,
    required DateTime startAt,
    DateTime? endAt,
    String? location,
    required bool isRecurring,
    String? recurringRule, // "WEEKLY" 등. isRecurring == true이면 필수.
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _ChurchSchedule;

  factory ChurchSchedule.fromJson(Map<String, dynamic> json) =>
      _$ChurchScheduleFromJson(json);
}
