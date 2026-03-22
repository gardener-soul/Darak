/// 기도 기간 유형
enum PrayerPeriodType {
  /// 매일 (사용자가 시작~종료일 직접 지정)
  daily,

  /// 주 단위
  weekly,

  /// 월 단위
  monthly,

  /// 기간 없음 (계속 기도)
  indefinite,
}

extension PrayerPeriodTypeX on PrayerPeriodType {
  String get label {
    switch (this) {
      case PrayerPeriodType.daily:
        return '매일';
      case PrayerPeriodType.weekly:
        return '이번 주';
      case PrayerPeriodType.monthly:
        return '이번 달';
      case PrayerPeriodType.indefinite:
        return '기간 없음';
    }
  }

  String toJson() {
    switch (this) {
      case PrayerPeriodType.daily:
        return 'daily';
      case PrayerPeriodType.weekly:
        return 'weekly';
      case PrayerPeriodType.monthly:
        return 'monthly';
      case PrayerPeriodType.indefinite:
        return 'indefinite';
    }
  }

  static PrayerPeriodType fromJson(String value) {
    switch (value) {
      case 'weekly':
        return PrayerPeriodType.weekly;
      case 'monthly':
        return PrayerPeriodType.monthly;
      case 'indefinite':
        return PrayerPeriodType.indefinite;
      default:
        return PrayerPeriodType.daily;
    }
  }
}
