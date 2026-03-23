/// 팔로우 요청 상태
enum FollowStatus {
  /// 팔로우 요청 대기 중
  pending,

  /// 팔로우 수락됨
  accepted,

  /// 팔로우 거절됨
  rejected,
}

extension FollowStatusX on FollowStatus {
  String get label {
    switch (this) {
      case FollowStatus.pending:
        return '요청됨';
      case FollowStatus.accepted:
        return '팔로잉';
      case FollowStatus.rejected:
        return '거절됨';
    }
  }

  String toJson() {
    switch (this) {
      case FollowStatus.pending:
        return 'pending';
      case FollowStatus.accepted:
        return 'accepted';
      case FollowStatus.rejected:
        return 'rejected';
    }
  }

  static FollowStatus fromJson(String value) {
    switch (value) {
      case 'accepted':
        return FollowStatus.accepted;
      case 'rejected':
        return FollowStatus.rejected;
      default:
        return FollowStatus.pending;
    }
  }
}
