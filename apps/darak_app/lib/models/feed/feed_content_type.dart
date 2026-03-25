/// 피드 게시물 콘텐츠 유형
enum FeedContentType {
  /// 일반 나눔 (일상, 감사 일기 등)
  general,

  /// 기도 공유 (기존 Prayer 연동)
  prayerShare,

  /// 간증/은혜 나눔
  testimony,
}

extension FeedContentTypeX on FeedContentType {
  String get label {
    switch (this) {
      case FeedContentType.general:
        return '일반';
      case FeedContentType.prayerShare:
        return '기도 공유';
      case FeedContentType.testimony:
        return '간증';
    }
  }

  String toJson() {
    switch (this) {
      case FeedContentType.general:
        return 'general';
      case FeedContentType.prayerShare:
        return 'prayer_share';
      case FeedContentType.testimony:
        return 'testimony';
    }
  }

  static FeedContentType fromJson(String value) {
    switch (value) {
      case 'prayer_share':
        return FeedContentType.prayerShare;
      case 'testimony':
        return FeedContentType.testimony;
      default:
        return FeedContentType.general;
    }
  }
}
