import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers/user_providers.dart';
import '../../models/prayer.dart';
import '../../models/prayer_period_type.dart';
import '../../models/prayer_visibility.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/user/prayer_archive_viewmodel.dart';
import '../../widgets/common/core/app_bottom_sheet.dart';
import '../../widgets/common/clay_card.dart';
import '../../widgets/common/core/soft_chip.dart';
import '../prayer/widgets/prayer_detail_sheet.dart';

class PrayerArchiveScreen extends ConsumerStatefulWidget {
  const PrayerArchiveScreen({super.key});

  @override
  ConsumerState<PrayerArchiveScreen> createState() =>
      _PrayerArchiveScreenState();
}

class _PrayerArchiveScreenState extends ConsumerState<PrayerArchiveScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUserProvider).valueOrNull;
      if (user != null) {
        ref
            .read(prayerArchiveViewModelProvider.notifier)
            .loadInitial(userId: user.id);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final user = ref.read(currentUserProvider).valueOrNull;
      if (user != null) {
        ref
            .read(prayerArchiveViewModelProvider.notifier)
            .loadMore(userId: user.id);
      }
    }
  }

  void _showPrayerDetail(BuildContext context, Prayer prayer) {
    AppBottomSheet.show(
      context: context,
      child: PrayerDetailSheet(prayer: prayer),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy.MM.dd').format(date);
  }

  /// 기도 기간 표시 문자열 생성 (기획서 §3-3)
  ///
  /// - indefinite: "기간 없음"
  /// - 그 외: "yyyy.MM.dd ~ yyyy.MM.dd" 형식
  String _periodText(Prayer prayer) {
    if (prayer.periodType == PrayerPeriodType.indefinite) {
      return '기간 없음';
    }
    final start = _formatDate(prayer.startDate);
    final end = prayer.endDate != null ? _formatDate(prayer.endDate!) : '-';
    return '$start ~ $end';
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final userId = userAsync.valueOrNull?.id;
    if (userId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final archiveState = ref.watch(prayerArchiveViewModelProvider);
    final countAsync = ref.watch(answeredPrayerCountProvider(userId));

    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        title: const Text(
          '기도 응답 아카이브',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        centerTitle: true,
      ),
      body: archiveState.isLoading && archiveState.prayers.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.sageGreen),
            )
          : archiveState.error != null
          ? Center(child: Text('응답 목록을 불러올 수 없어요: ${archiveState.error}'))
          : _buildList(archiveState, countAsync, userId),
    );
  }

  Widget _buildList(
    PrayerArchiveState state,
    AsyncValue<int> countAsync,
    String userId,
  ) {
    final prayers = state.prayers;

    if (prayers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.softLavender,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              '아직 응답된 기도제목이 없어요',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(answeredPrayerCountProvider(userId));
        await ref
            .read(prayerArchiveViewModelProvider.notifier)
            .loadInitial(userId: userId);
      },
      color: AppColors.sageGreen,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(24),
        itemCount:
            prayers.length + (state.isLoadingMore ? 1 : 0) + 1, // +1 for header
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                '총 ${countAsync.valueOrNull ?? 0}건의 기도 응답',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.sageGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }

          if (index - 1 == prayers.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.sageGreen),
              ),
            );
          }

          final prayer = prayers[index - 1];
          final answeredDate = prayer.answeredAt;
          if (answeredDate == null) {
            debugPrint('[WARN] prayerId=${prayer.id} has no answeredAt');
          }
          final displayDate = answeredDate ?? prayer.updatedAt;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onTap: () => _showPrayerDetail(context, prayer),
              child: ClayCard(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(color: AppColors.sageGreen, width: 3),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prayer.content,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // 기도 기간 표시 (기획서 §3-3)
                      Text(
                        _periodText(prayer),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textGrey,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          SoftChip(
                            label: prayer.visibility.label,
                            color: AppColors.softLavender,
                            isSelected: true,
                          ),
                          const Spacer(),
                          Text(
                            '응답 ${_formatDate(displayDate)}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
