import 'package:freezed_annotation/freezed_annotation.dart';

part 'church_role.freezed.dart';
part 'church_role.g.dart';

/// 교회별 역할 정의 모델
/// Firestore: churches/{churchId}/roles/{roleId}
@freezed
class ChurchRole with _$ChurchRole {
  const factory ChurchRole({
    required String id,
    required String name, // 표시 이름 (예: "순장", "셀 리더")
    required int level, // 권한 레벨 (1: 순원 ~ 4: 사역자)
    required List<String> permissions,
    required bool isDefault, // true이면 삭제 불가, 이름 변경만 허용
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ChurchRole;

  factory ChurchRole.fromJson(Map<String, dynamic> json) =>
      _$ChurchRoleFromJson(json);
}
