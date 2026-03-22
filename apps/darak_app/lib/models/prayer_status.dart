/// 기도 제목 상태
enum PrayerStatus {
  /// 기도 진행중
  active,

  /// 기도 응답됨
  answered,
}

extension PrayerStatusX on PrayerStatus {
  String get label {
    switch (this) {
      case PrayerStatus.active:
        return '진행중';
      case PrayerStatus.answered:
        return '응답됨';
    }
  }

  String toJson() {
    switch (this) {
      case PrayerStatus.active:
        return 'active';
      case PrayerStatus.answered:
        return 'answered';
    }
  }

  static PrayerStatus fromJson(String value) {
    switch (value) {
      case 'answered':
        return PrayerStatus.answered;
      default:
        return PrayerStatus.active;
    }
  }
}
