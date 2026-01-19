import 'package:freezed_annotation/freezed_annotation.dart';
import 'club_status.dart';

part 'club.freezed.dart';
part 'club.g.dart';

@freezed
class Club with _$Club {
  const factory Club({
    required String id, // 고유 ID
    required String name, // 클럽 이름
    String? clubLeaderId, // 클럽 리더 ID (User 참조)
    List<String>? clubMemberIds, // 클럽 멤버 ID 리스트
    String? description, // 클럽 설명
    required ClubStatus status, // 승인 상태 (대기/승인/거부)
    required DateTime createdAt, // 생성일시
    required DateTime updatedAt, // 수정일시
    DateTime? deletedAt, // 삭제일시 (Soft Delete)
  }) = _Club;

  factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);
}
