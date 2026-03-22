import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_note.freezed.dart';
part 'member_note.g.dart';

/// 순장이 순원에 대해 작성하는 비공개 메모 모델
/// Firestore 경로: users/{userId}/notes/{noteId}
///
/// [createdAt], [updatedAt]이 nullable인 이유:
/// serverTimestamp()로 저장 직후 스냅샷을 수신하면 Firestore가
/// 아직 서버 시각을 확정하지 않아 null을 내려보낼 수 있습니다.
/// 해당 상황에서 현재 시각으로 대체하면 데이터 오염이 발생하므로
/// UI 레이어에서 null을 안전하게 처리합니다.
@freezed
class MemberNote with _$MemberNote {
  const factory MemberNote({
    required String id, // Firestore document ID
    required String userId, // 메모 대상 순원의 userId
    required String content, // 메모 본문 (최대 500자)
    required String createdBy, // 메모 작성자 userId
    DateTime? createdAt, // serverTimestamp 대기 중 null 가능
    DateTime? updatedAt, // serverTimestamp 대기 중 null 가능
    DateTime? deletedAt, // Soft Delete 기준 필드
  }) = _MemberNote;

  factory MemberNote.fromJson(Map<String, dynamic> json) =>
      _$MemberNoteFromJson(json);
}
