/// Firestore 컬렉션 경로 상수
/// 모든 Firestore 컬렉션 경로를 한 곳에서 관리하여 오타 방지 및 유지보수 용이성 확보
class FirestorePaths {
  FirestorePaths._();

  /// 사용자 컬렉션
  static const users = 'users';

  /// 다락방(소그룹) 컬렉션
  static const groups = 'groups';

  /// 마을 컬렉션
  static const villages = 'villages';

  /// 동아리 컬렉션
  static const clubs = 'clubs';

  /// 번개 모임 컬렉션
  static const meetups = 'meetups';

  /// 메모/특이사항 컬렉션
  static const notes = 'notes';

  /// 출석 기록 컬렉션
  static const attendances = 'attendances';

  /// 교회 컬렉션
  static const churches = 'churches';
}
