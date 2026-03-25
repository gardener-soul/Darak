import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement.freezed.dart';
part 'announcement.g.dart';

/// 교회 공지사항 모델
/// Firestore: churches/{churchId}/announcements/{announcementId}
@freezed
class Announcement with _$Announcement {
  const factory Announcement({
    required String id,
    required String title,
    required String content,
    required String authorId,
    required bool isPinned,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,
  }) = _Announcement;

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);
}
