/// 피드 게시물 공개 범위
enum FeedVisibility {
  /// 같은 다락방 구성원에게 공개
  group,

  /// 팔로워에게 공개
  followers,
}

extension FeedVisibilityX on FeedVisibility {
  String get label {
    switch (this) {
      case FeedVisibility.group:
        return '다락방 공개';
      case FeedVisibility.followers:
        return '팔로워 공개';
    }
  }

  String toJson() {
    switch (this) {
      case FeedVisibility.group:
        return 'group';
      case FeedVisibility.followers:
        return 'followers';
    }
  }

  static FeedVisibility fromJson(String value) {
    switch (value) {
      case 'followers':
        return FeedVisibility.followers;
      default:
        return FeedVisibility.group;
    }
  }
}
