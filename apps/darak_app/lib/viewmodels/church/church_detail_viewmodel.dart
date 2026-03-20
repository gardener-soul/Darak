import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/church_detail_state.dart';
import '../../repositories/church_repository.dart';
import '../../repositories/church_member_repository.dart';
import '../../core/providers/user_providers.dart';

part 'church_detail_viewmodel.g.dart';

/// 교회 상세 화면의 상태를 관리하는 ViewModel.
/// Church 실시간 스트림 구독 + 현재 유저의 멤버십 정보 + 관리자 여부를 조립합니다.
@riverpod
class ChurchDetailViewModel extends _$ChurchDetailViewModel {
  @override
  Stream<ChurchDetailState> build(String churchId) async* {
    final churchRepo = ref.watch(churchRepositoryProvider);
    final memberRepo = ref.watch(churchMemberRepositoryProvider);
    final userId = ref.watch(currentUserIdProvider);

    if (userId == null) {
      throw Exception('로그인이 필요합니다.');
    }

    await for (final church in churchRepo.watchChurch(churchId)) {
      final member = await memberRepo.getMember(
        churchId: churchId,
        userId: userId,
      );
      final isAdmin = church.adminIds?.contains(userId) ?? false;
      yield ChurchDetailState(
        church: church,
        currentMember: member,
        isAdmin: isAdmin,
      );
    }
  }
}
