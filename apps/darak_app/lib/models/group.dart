import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

@freezed
class Group with _$Group {
  const factory Group({
    required String id, // 고유 ID
    required String name, // 다락방 이름
    String? imageUrl, // 다락방 이미지 URL
    String? leaderId, // 다락방 리더 ID (User 참조)
    List<String>? memberIds, // 다락방 구성원 ID 리스트
    String? villageId, // 소속 마을 ID (Village 참조)
    String? description, // 다락방 설명
    required DateTime createdAt, // 생성일시
    required DateTime updatedAt, // 수정일시
    DateTime? deletedAt, // 삭제일시 (Soft Delete)
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
