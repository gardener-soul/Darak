import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required String id, // 고유 ID
    required String userId, // 연결된 사용자 ID (User 참조)
    required String content, // 메모 내용
    required String createdBy, // 작성자 ID (User 참조)
    required DateTime createdAt, // 작성일시
    required DateTime updatedAt, // 수정일시
    DateTime? deletedAt, // 삭제일시 (Soft Delete)
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
