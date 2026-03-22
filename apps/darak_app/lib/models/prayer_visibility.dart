/// 기도 제목 공개 범위
enum PrayerVisibility {
  /// 본인만 열람 (기본값)
  private,

  /// 같은 다락방 구성원 열람
  group,
}

extension PrayerVisibilityX on PrayerVisibility {
  String get label {
    switch (this) {
      case PrayerVisibility.private:
        return '나만 보기';
      case PrayerVisibility.group:
        return '다락방 공개';
    }
  }

  String toJson() {
    switch (this) {
      case PrayerVisibility.private:
        return 'private';
      case PrayerVisibility.group:
        return 'group';
    }
  }

  static PrayerVisibility fromJson(String value) {
    switch (value) {
      case 'group':
        return PrayerVisibility.group;
      default:
        return PrayerVisibility.private;
    }
  }
}
