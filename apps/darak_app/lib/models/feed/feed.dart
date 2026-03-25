import 'package:freezed_annotation/freezed_annotation.dart';

import 'feed_content_type.dart';
import 'feed_visibility.dart';

part 'feed.freezed.dart';
part 'feed.g.dart';

// ─── JSON Converter: FeedContentType ─────────────────────────────────────────

class FeedContentTypeConverter
    implements JsonConverter<FeedContentType, String> {
  const FeedContentTypeConverter();

  @override
  FeedContentType fromJson(String json) => FeedContentTypeX.fromJson(json);

  @override
  String toJson(FeedContentType object) => object.toJson();
}

// ─── JSON Converter: FeedVisibility ──────────────────────────────────────────

class FeedVisibilityConverter implements JsonConverter<FeedVisibility, String> {
  const FeedVisibilityConverter();

  @override
  FeedVisibility fromJson(String json) => FeedVisibilityX.fromJson(json);

  @override
  String toJson(FeedVisibility object) => object.toJson();
}

// ─── Feed 모델 ────────────────────────────────────────────────────────────────

@freezed
class Feed with _$Feed {
  const factory Feed({
    required String id, // 고유 ID (Firestore document ID)
    required String userId, // 작성자 ID
    required String churchId, // 소속 교회 ID
    String? groupId, // 소속 다락방 ID
    @FeedContentTypeConverter() required FeedContentType contentType, // 콘텐츠 유형
    String? text, // 본문 텍스트 (최대 500자)
    @Default([]) List<String> imageUrls, // 첨부 사진 URL (v2)
    String? linkedPrayerId, // 연결된 기도제목 ID
    @FeedVisibilityConverter() required FeedVisibility visibility, // 공개 범위
    // reactions: Map<반응타입, userId 배열> — Firestore에서 직접 Map으로 저장
    @Default({}) Map<String, List<String>> reactions,
    @Default(0) int encouragementCount, // 격려 메시지 수 (비정규화 캐시)
    @Default([]) List<String> reportedBy, // 신고한 사용자 ID 배열
    required DateTime createdAt, // 생성일시
    required DateTime updatedAt, // 수정일시
    DateTime? deletedAt, // 삭제일시 (Soft Delete)
  }) = _Feed;

  factory Feed.fromJson(Map<String, dynamic> json) => _$FeedFromJson(json);
}
