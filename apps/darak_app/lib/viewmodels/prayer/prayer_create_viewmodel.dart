import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/prayer_period_type.dart';
import '../../models/prayer_visibility.dart';
import '../../repositories/prayer_repository.dart';

part 'prayer_create_viewmodel.g.dart';

// ─── 기도 등록 폼 상태 ────────────────────────────────────────────────────────

class PrayerCreateState {
  final String content;
  final PrayerPeriodType periodType;
  final DateTime startDate;
  final DateTime? endDate;
  final PrayerVisibility visibility;
  final bool isLoading;
  final String? errorMessage;

  const PrayerCreateState({
    this.content = '',
    this.periodType = PrayerPeriodType.weekly,
    required this.startDate,
    this.endDate,
    this.visibility = PrayerVisibility.private,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isValid => content.trim().isNotEmpty && content.trim().length <= 200;

  PrayerCreateState copyWith({
    String? content,
    PrayerPeriodType? periodType,
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,
    PrayerVisibility? visibility,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PrayerCreateState(
      content: content ?? this.content,
      periodType: periodType ?? this.periodType,
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      visibility: visibility ?? this.visibility,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

// ─── PrayerCreateViewModel ────────────────────────────────────────────────────

@riverpod
class PrayerCreateViewModel extends _$PrayerCreateViewModel {
  @override
  PrayerCreateState build() {
    final now = DateTime.now();
    return PrayerCreateState(
      startDate: now,
      endDate: _defaultEndDate(PrayerPeriodType.weekly, now),
    );
  }

  void updateContent(String value) {
    state = state.copyWith(content: value, clearError: true);
  }

  void updatePeriodType(PrayerPeriodType type) {
    final now = DateTime.now();
    state = state.copyWith(
      periodType: type,
      startDate: now,
      endDate: _defaultEndDate(type, now),
      clearEndDate: type == PrayerPeriodType.indefinite,
    );
  }

  void updateDateRange(DateTime start, DateTime? end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void updateVisibility(PrayerVisibility visibility) {
    state = state.copyWith(visibility: visibility);
  }

  /// 기도 제목 등록 — 성공 시 true 반환
  Future<bool> submit({
    required String userId,
    required String churchId,
    String? groupId,
  }) async {
    if (!state.isValid) {
      state = state.copyWith(errorMessage: '기도 제목을 입력해주세요');
      return false;
    }
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await ref.read(prayerRepositoryProvider).createPrayer(
            userId: userId,
            churchId: churchId,
            groupId: groupId,
            content: state.content.trim(),
            visibility: state.visibility,
            periodType: state.periodType,
            startDate: state.startDate,
            endDate: state.endDate,
          );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '등록에 실패했어요. 다시 시도해주세요.',
      );
      return false;
    }
  }

  // ─── 내부 헬퍼 ──────────────────────────────────────────────────────────

  DateTime? _defaultEndDate(PrayerPeriodType type, DateTime from) {
    switch (type) {
      case PrayerPeriodType.daily:
        return from.add(const Duration(days: 6));
      case PrayerPeriodType.weekly:
        // 이번 주 일요일까지
        // 일요일 당일(weekday=7)이면 daysUntilSunday=0이 되어 오늘로 고정되는 버그 방지
        final daysUntilSunday = DateTime.sunday - from.weekday;
        return from.add(Duration(days: daysUntilSunday <= 0 ? 7 + daysUntilSunday : daysUntilSunday));
      case PrayerPeriodType.monthly:
        // 이번 달 말일까지
        return DateTime(from.year, from.month + 1, 0);
      case PrayerPeriodType.indefinite:
        return null;
    }
  }
}
