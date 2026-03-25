import 'package:freezed_annotation/freezed_annotation.dart';

part 'encouragement.freezed.dart';
part 'encouragement.g.dart';

// ─── Encouragement 모델 ───────────────────────────────────────────────────────

@freezed
class Encouragement with _$Encouragement {
  const factory Encouragement({
    required String id, // 고유 ID
    required String userId, // 작성자 ID
    required String text, // 격려 메시지 (최대 100자)
    required DateTime createdAt, // 작성일시
    DateTime? deletedAt, // 삭제일시 (Soft Delete)
  }) = _Encouragement;

  factory Encouragement.fromJson(Map<String, dynamic> json) =>
      _$EncouragementFromJson(json);
}
