import 'package:freezed_annotation/freezed_annotation.dart';

part 'meetup.freezed.dart';
part 'meetup.g.dart';

@freezed
class MeetUp with _$MeetUp {
  const factory MeetUp({
    required String id, // 고유 ID
    required String name, // 모임 이름
    required int participantCount, // 참여 인원 수
    required String meetLeaderId, // 모임 주최자 ID (User 참조)
    List<String>? participantIds, // 모임 참여자 ID 리스트
    String? description, // 모임 설명
    DateTime? scheduledAt, // 모임 예정 일시
    required DateTime createdAt, // 생성일시
    required DateTime updatedAt, // 수정일시
    DateTime? deletedAt, // 삭제일시 (Soft Delete)
  }) = _MeetUp;

  factory MeetUp.fromJson(Map<String, dynamic> json) => _$MeetUpFromJson(json);
}
