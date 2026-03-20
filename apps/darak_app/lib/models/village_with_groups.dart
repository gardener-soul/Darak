import 'package:freezed_annotation/freezed_annotation.dart';

import 'village.dart';
import 'group.dart';

part 'village_with_groups.freezed.dart';

/// 공동체 탭 트리 구조 표현용 DTO
/// VillageRepository + GroupRepository 데이터를 ViewModel에서 조립
@freezed
class VillageWithGroups with _$VillageWithGroups {
  const factory VillageWithGroups({
    required Village village,
    required List<Group> groups,
  }) = _VillageWithGroups;
}
