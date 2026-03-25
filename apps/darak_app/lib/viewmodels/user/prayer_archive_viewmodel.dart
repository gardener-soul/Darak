import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/prayer.dart';
import '../../repositories/prayer_repository.dart';

// ═══════════════════════════════════════════════════════════════
// 기도 응답 아카이브 상태 모델
// ═══════════════════════════════════════════════════════════════

class PrayerArchiveState {
  final List<Prayer> prayers;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;
  final DocumentSnapshot? lastDoc;

  const PrayerArchiveState({
    this.prayers = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.error,
    this.lastDoc,
  });

  PrayerArchiveState copyWith({
    List<Prayer>? prayers,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    DocumentSnapshot? lastDoc,
    bool clearError = false,
    bool clearLastDoc = false,
  }) {
    return PrayerArchiveState(
      prayers: prayers ?? this.prayers,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: clearError ? null : (error ?? this.error),
      lastDoc: clearLastDoc ? null : (lastDoc ?? this.lastDoc),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PrayerArchiveViewModel — 기도 응답 아카이브 상태 관리
// ═══════════════════════════════════════════════════════════════

class PrayerArchiveViewModel extends Notifier<PrayerArchiveState> {
  @override
  PrayerArchiveState build() => const PrayerArchiveState();

  static const int _pageSize = 20;

  /// 초기 데이터 로드 (화면 진입 시 호출)
  Future<void> loadInitial({required String userId}) async {
    if (state.isLoading) return;
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      clearLastDoc: true,
      prayers: [],
      hasMore: true,
    );

    try {
      final result = await ref
          .read(prayerRepositoryProvider)
          .getAnsweredPrayers(userId: userId, pageSize: _pageSize);

      state = state.copyWith(
        prayers: result.prayers,
        lastDoc: result.lastDoc,
        hasMore: result.prayers.length >= _pageSize,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      debugPrint('기도 응답 아카이브 초기 로드 실패: $e');
      state = state.copyWith(
        isLoading: false,
        error: '기도 응답 목록을 불러오지 못했어요.',
      );
    }
  }

  /// 다음 페이지 로드 (무한 스크롤)
  Future<void> loadMore({required String userId}) async {
    if (state.isLoadingMore || !state.hasMore || state.lastDoc == null) return;
    state = state.copyWith(isLoadingMore: true);

    try {
      final result = await ref
          .read(prayerRepositoryProvider)
          .getAnsweredPrayers(
            userId: userId,
            lastDoc: state.lastDoc,
            pageSize: _pageSize,
          );

      state = state.copyWith(
        prayers: [...state.prayers, ...result.prayers],
        lastDoc: result.lastDoc,
        hasMore: result.prayers.length >= _pageSize,
        isLoadingMore: false,
      );
    } catch (e) {
      debugPrint('기도 응답 아카이브 추가 로드 실패: $e');
      state = state.copyWith(
        isLoadingMore: false,
        error: '추가 목록을 불러오지 못했어요.',
      );
    }
  }
}

/// [PrayerArchiveViewModel] Provider
final prayerArchiveViewModelProvider =
    NotifierProvider<PrayerArchiveViewModel, PrayerArchiveState>(
  PrayerArchiveViewModel.new,
);

// ═══════════════════════════════════════════════════════════════
// 마이페이지 미리보기용 Provider
// ═══════════════════════════════════════════════════════════════

/// 응답된 기도 미리보기 3건 Provider
final answeredPrayerPreviewProvider =
    FutureProvider.family<List<Prayer>, String>(
  (ref, userId) async {
    return ref
        .watch(prayerRepositoryProvider)
        .getAnsweredPrayerPreview(userId: userId);
  },
);

/// 응답된 기도 건수 Provider
final answeredPrayerCountProvider =
    FutureProvider.family<int, String>(
  (ref, userId) async {
    return ref
        .watch(prayerRepositoryProvider)
        .getAnsweredPrayerCount(userId: userId);
  },
);
