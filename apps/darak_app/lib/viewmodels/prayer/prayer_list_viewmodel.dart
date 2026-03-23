import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/prayer.dart';
import '../../models/prayer_period_type.dart';
import '../../models/prayer_visibility.dart';
import '../../repositories/prayer_repository.dart';

part 'prayer_list_viewmodel.g.dart';

// ─── 기도 액션 ViewModel (수정 / 응답 / 삭제) ─────────────────────────────────
// Riverpod 어노테이션 없이 수동 정의하여 build_runner 재실행 불필요

/// 기도 수정/응답/삭제 액션을 ViewModel 계층에서 처리하는 Notifier
class PrayerListViewModel extends Notifier<void> {
  @override
  void build() {}

  /// 기도 제목 수정
  Future<void> editPrayer(
    String prayerId, {
    required String content,
    PrayerPeriodType? periodType,
    DateTime? startDate,
    DateTime? endDate,
    PrayerVisibility? visibility,
  }) async {
    try {
      await ref.read(prayerRepositoryProvider).updatePrayer(
            prayerId: prayerId,
            content: content,
            periodType: periodType,
            startDate: startDate,
            endDate: endDate,
            visibility: visibility,
          );
    } catch (e) {
      debugPrint('기도 수정 실패: $e');
      rethrow;
    }
  }

  /// 기도 상태를 응답됨으로 변경
  Future<void> markAsAnswered(String prayerId) async {
    try {
      await ref
          .read(prayerRepositoryProvider)
          .markAsAnswered(prayerId: prayerId);
    } catch (e) {
      debugPrint('기도 응답 처리 실패: $e');
      rethrow;
    }
  }

  /// 기도 제목 삭제 (Soft Delete)
  Future<void> deletePrayer(String prayerId) async {
    try {
      await ref
          .read(prayerRepositoryProvider)
          .deletePrayer(prayerId: prayerId);
    } catch (e) {
      debugPrint('기도 삭제 실패: $e');
      rethrow;
    }
  }
}

/// [PrayerListViewModel] Provider — 기도 수정/응답/삭제 액션 위임
final prayerListViewModelProvider =
    NotifierProvider<PrayerListViewModel, void>(PrayerListViewModel.new);

/// 내 기도 목록 — 실시간 스트림 Provider
@riverpod
Stream<List<Prayer>> myPrayerList(Ref ref, String userId) {
  return ref.watch(prayerRepositoryProvider).watchMyPrayers(userId: userId);
}

/// 캘린더에서 선택된 날짜 Provider
@riverpod
class SelectedPrayerDate extends _$SelectedPrayerDate {
  @override
  DateTime build() => DateTime.now();

  void select(DateTime date) {
    state = date;
  }
}

/// 선택된 날짜에 활성화된 기도 제목 필터링 (클라이언트 사이드)
///
/// startDate ≤ selectedDate ≤ endDate (endDate가 null이면 무기한으로 포함)
@riverpod
List<Prayer> filteredPrayerList(
  Ref ref,
  String userId,
) {
  final selectedDate = ref.watch(selectedPrayerDateProvider);
  final prayersAsync = ref.watch(myPrayerListProvider(userId));

  return prayersAsync.when(
    data: (prayers) => prayers.where((p) {
      final start = DateTime(
        p.startDate.year,
        p.startDate.month,
        p.startDate.day,
      );
      final selected = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      if (selected.isBefore(start)) return false;
      final end = p.endDate;
      if (end == null) return true; // 무기한
      final endDay = DateTime(end.year, end.month, end.day);
      return !selected.isAfter(endDay);
    }).toList(),
    loading: () => [],
    error: (_, _) => [],
  );
}
