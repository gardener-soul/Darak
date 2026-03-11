import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/church.dart';
import '../../repositories/church_repository.dart';

part 'church_list_viewmodel.g.dart';

/// 교회 목록 화면의 상태를 관리하는 ViewModel.
/// 교회 목록 스트림 구독 및 교인 등록(joinChurch) 액션을 담당합니다.
@riverpod
class ChurchListViewModel extends _$ChurchListViewModel {
  String? _searchQuery;

  @override
  Stream<List<Church>> build() {
    return ref
        .watch(churchRepositoryProvider)
        .watchApprovedChurches(searchQuery: _searchQuery);
  }

  /// 검색어를 업데이트하고 교회 목록 스트림을 재구독합니다.
  /// 빈 문자열이 입력되면 검색 해제(전체 목록) 상태로 돌아갑니다.
  void updateSearch(String query) {
    _searchQuery = query.trim().isEmpty ? null : query.trim();
    ref.invalidateSelf();
  }

  /// 현재 사용자를 선택한 교회에 교인으로 등록합니다.
  /// 실패 시 정제된 메시지로 Exception을 rethrow하여 View가 에러 타입에 무관하게 처리합니다.
  Future<void> joinChurch({
    required String churchId,
    required String churchName,
  }) async {
    try {
      await ref.read(churchRepositoryProvider).joinChurch(
            churchId: churchId,
            churchName: churchName,
          );
    } on Exception catch (e) {
      // 정제된 메시지로 rethrow — View에서 에러 타입별 분기 불필요
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
