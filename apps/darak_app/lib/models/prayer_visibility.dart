/// 기도 제목 공개 범위
enum PrayerVisibility {
  /// 본인만 열람 (기본값)
  private,

  /// 같은 다락방 구성원 열람
  group,

  /// 팔로워에게 공개
  followers,
}

extension PrayerVisibilityX on PrayerVisibility {
  String get label {
    switch (this) {
      case PrayerVisibility.private:
        return '나만 보기';
      case PrayerVisibility.group:
        return '다락방 공개';
      case PrayerVisibility.followers:
        return '팔로워 공개';
    }
  }

  String toJson() {
    switch (this) {
      case PrayerVisibility.private:
        return 'private';
      case PrayerVisibility.group:
        return 'group';
      case PrayerVisibility.followers:
        return 'followers';
    }
  }

  static PrayerVisibility fromJson(String value) {
    switch (value) {
      case 'group':
        return PrayerVisibility.group;
      case 'followers':
        return PrayerVisibility.followers;
      default:
        return PrayerVisibility.private;
    }
  }
}
