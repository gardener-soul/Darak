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

  // ─── 교회 서브컬렉션 경로 헬퍼 ──────────────────────────────────
  /// 교회별 역할 서브컬렉션 경로
  static String churchRoles(String churchId) => 'churches/$churchId/roles';

  /// 교회별 구성원 서브컬렉션 경로
  static String churchMembers(String churchId) => 'churches/$churchId/members';

  /// 교회별 공지사항 서브컬렉션 경로
  static String churchAnnouncements(String churchId) =>
      'churches/$churchId/announcements';

  /// 교회별 일정 서브컬렉션 경로
  static String churchSchedules(String churchId) =>
      'churches/$churchId/schedules';

  /// 교회별 초대 서브컬렉션 경로
  static String churchInvitations(String churchId) =>
      'churches/$churchId/invitations';

  /// 교회별 번개 모임 서브컬렉션 경로
  static String churchMeetups(String churchId) =>
      'churches/$churchId/meetups';

  /// 기도 제목 컬렉션
  static const prayers = 'prayers';

  /// 팔로우 관계 컬렉션
  static const follows = 'follows';

  /// 피드 게시물 컬렉션
  static const feeds = 'feeds';

  /// 피드 게시물 격려 메시지 서브컬렉션 경로
  static String feedEncouragements(String feedId) =>
      'feeds/$feedId/encouragements';

  /// 순원 비공개 메모 서브컬렉션 경로
  static String userNotes(String userId) => 'users/$userId/notes';
}
