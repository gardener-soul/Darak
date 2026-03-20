import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/church_role.dart';
import '../../repositories/church_role_repository.dart';

part 'church_roles_provider.g.dart';

/// 교회 역할 목록을 level 순으로 실시간 구독하는 Provider.
/// 구성원 탭의 역할 필터 UI 및 역할 배지 표시에서 사용합니다.
@riverpod
Stream<List<ChurchRole>> churchRoles(Ref ref, String churchId) {
  return ref
      .watch(churchRoleRepositoryProvider)
      .watchRoles(churchId: churchId);
}
