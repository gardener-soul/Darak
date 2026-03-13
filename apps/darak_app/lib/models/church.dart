import 'package:freezed_annotation/freezed_annotation.dart';
import 'church_status.dart';

part 'church.freezed.dart';
part 'church.g.dart';

/// 교회 등록 정보 모델
/// Firestore `churches` 컬렉션의 문서 구조를 반영합니다.
@freezed
class Church with _$Church {
  const factory Church({
    required String id, // 고유 ID (Firestore document ID)
    required String name, // 교회 이름
    required String address, // 도로명 주소 (카카오 API 반환값)
    String? addressDetail, // 상세 주소 (선택)
    double? latitude, // 위도 (추후 지도 연동용)
    double? longitude, // 경도
    required String seniorPastor, // 담임목사 성함
    required String denomination, // 교단
    required String requestMemo, // 신청 메모
    required String requestedBy, // 신청자 userId
    required ChurchStatus status, // pending | approved | rejected
    String? rejectionReason, // 거절 사유
    required DateTime createdAt, // 생성일시
    required DateTime updatedAt, // 수정일시
    DateTime? approvedAt, // 승인일시
  }) = _Church;

  factory Church.fromJson(Map<String, dynamic> json) => _$ChurchFromJson(json);
}
