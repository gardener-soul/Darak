import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_role.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id, // 고유 ID (Firestore document ID)
    required String name, // 이름
    required String phone, // 핸드폰 번호
    String? email, // 이메일 (선택)
    required UserRole role, // 역할 (순원, 순장, 마을장 등)
    DateTime? birthDate, // 생년월일
    DateTime? registerDate, // 교회 등록일
    String? groupId, // 소속 다락방 ID
    String? groupName, // 소속 다락방 이름 (비정규화)
    String? groupImageUrl, // 소속 다락방 이미지 URL (비정규화)
    List<String>? clubIds, // 소속 클럽/동아리 ID 리스트 (여러 개 가능)
    String? profileImageUrl, // 프로필 이미지 URL
    String? bio, // 상태 메시지 (마이페이지)
    List<String>? prayerRequests, // 개인 기도 제목 리스트
    Map<String, dynamic>? attendanceStats, // 출석 통계 캐시 (예: {"total": 12, "attended": 10})
    required DateTime createdAt, // 생성일시
    required DateTime updatedAt, // 수정일시
    DateTime? deletedAt, // 삭제일시 (Soft Delete)
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
