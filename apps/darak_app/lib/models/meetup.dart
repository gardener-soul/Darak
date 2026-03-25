import 'package:freezed_annotation/freezed_annotation.dart';

part 'meetup.freezed.dart';
part 'meetup.g.dart';

@freezed
class MeetUp with _$MeetUp {
  const factory MeetUp({
    required String id, // 고유 ID
    required String name, // 모임 이름
    required String churchId, // 소속 교회 ID
    required String meetLeaderId, // 모임 주최자 ID (User 참조)
    required DateTime createdAt, // 생성일시
    required DateTime updatedAt, // 수정일시
    @Default([]) List<String> participantIds, // 참여자 ID 리스트
    String? description, // 모임 설명
    DateTime? scheduledAt, // 모임 예정 일시
    int? maxParticipants, // 최대 참여 인원 (null = 무제한)
    @Default([]) List<String> reportedBy, // 신고한 사용자 ID 배열
    @Default(false) bool notificationSent, // 푸시 알림 발송 여부 (추후 확장용)
    DateTime? deletedAt, // 삭제일시 (Soft Delete)
  }) = _MeetUp;

  factory MeetUp.fromJson(Map<String, dynamic> json) => _$MeetUpFromJson(json);
}
