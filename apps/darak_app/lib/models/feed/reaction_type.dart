/// 피드 반응 타입
enum ReactionType {
  /// 기도해요
  pray,

  /// 아멘
  amen,

  /// 응원해요
  cheer,

  /// 사랑해요
  love,

  /// 감사해요
  thanks,
}

extension ReactionTypeX on ReactionType {
  String get label {
    switch (this) {
      case ReactionType.pray:
        return '기도해요';
      case ReactionType.amen:
        return '아멘';
      case ReactionType.cheer:
        return '응원해요';
      case ReactionType.love:
        return '사랑해요';
      case ReactionType.thanks:
        return '감사해요';
    }
  }

  String get emoji {
    switch (this) {
      case ReactionType.pray:
        return '🙏';
      case ReactionType.amen:
        return '🙌';
      case ReactionType.cheer:
        return '👏';
      case ReactionType.love:
        return '❤️';
      case ReactionType.thanks:
        return '🌸';
    }
  }

  String toJson() {
    switch (this) {
      case ReactionType.pray:
        return 'pray';
      case ReactionType.amen:
        return 'amen';
      case ReactionType.cheer:
        return 'cheer';
      case ReactionType.love:
        return 'love';
      case ReactionType.thanks:
        return 'thanks';
    }
  }

  static ReactionType fromJson(String value) {
    switch (value) {
      case 'amen':
        return ReactionType.amen;
      case 'cheer':
        return ReactionType.cheer;
      case 'love':
        return ReactionType.love;
      case 'thanks':
        return ReactionType.thanks;
      default:
        return ReactionType.pray;
    }
  }
}
