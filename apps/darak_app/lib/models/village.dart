import 'package:freezed_annotation/freezed_annotation.dart';

part 'village.freezed.dart';
part 'village.g.dart';

@freezed
class Village with _$Village {
  const factory Village({
    required String id, // 고유 ID
    required String name, // 마을 이름
    String? leaderId, // 마을장 ID (User 참조)
    List<String>? darakLeaderIds, // 마을 소속 다락방 리더 ID 리스트
    List<String>? memberIds, // 마을 소속 순원 ID 리스트
    String? description, // 마을 설명
    String? churchId, // 소속 교회 ID (마이그레이션 기간 동안 null 허용)
    required DateTime createdAt, // 생성일시
    required DateTime updatedAt, // 수정일시
    DateTime? deletedAt, // 삭제일시 (Soft Delete)
  }) = _Village;

  factory Village.fromJson(Map<String, dynamic> json) =>
      _$VillageFromJson(json);
}
