import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/utils/string_utils.dart';
import '../../../models/meetup.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/meetup/meetup_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/clay_card.dart';
import '../widgets/meetup_card.dart';
import '../widgets/meetup_create_bottom_sheet.dart';
import '../widgets/meetup_detail_bottom_sheet.dart';
import '../../../core/providers/user_providers.dart';

/// 번개 모임 탭 (캘린더 기반)
class ChurchMeetupTab extends ConsumerWidget {
  final String churchId;

  const ChurchMeetupTab({super.key, required this.churchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetupAsync = ref.watch(meetupViewModelProvider(churchId));

    return meetupAsync.when(
      skipLoadingOnRefresh: true,
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.warmTangerine),
      ),
      error: (e, _) {
        final prev = meetupAsync.valueOrNull;
        final now = DateTime.now();
        return _MeetupCalendarBody(
          churchId: churchId,
          meetups: prev?.meetups ?? const [],
          focusedMonth: prev?.focusedMonth ?? DateTime(now.year, now.month),
          selectedDate: prev?.selectedDate ?? now,
        );
      },
      data: (state) => _MeetupCalendarBody(
        churchId: churchId,
        meetups: state.meetups,
        focusedMonth: state.focusedMonth,
        selectedDate: state.selectedDate,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _MeetupCalendarBody extends ConsumerWidget {
  final String churchId;
  final List<MeetUp> meetups;
  final DateTime focusedMonth;
  final DateTime selectedDate;

  const _MeetupCalendarBody({
    required this.churchId,
    required this.meetups,
    required this.focusedMonth,
    required this.selectedDate,
  });

  Map<DateTime, List<MeetUp>> _buildEventMap(List<MeetUp> meetups) {
    final map = <DateTime, List<MeetUp>>{};
    for (final m in meetups) {
      if (m.scheduledAt == null) continue;
      final day = DateTime(
        m.scheduledAt!.year,
        m.scheduledAt!.month,
        m.scheduledAt!.day,
      );
      map.putIfAbsent(day, () => []).add(m);
    }
    return map;
  }

  List<MeetUp> _getEventsForDay(
    DateTime day,
    Map<DateTime, List<MeetUp>> eventMap,
  ) {
    return eventMap[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final eventMap = _buildEventMap(meetups);
    final selectedEvents = _getEventsForDay(selectedDate, eventMap);

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // ── 캘린더 ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: ClayCard(
                  padding: const EdgeInsets.all(16),
                  child: TableCalendar<MeetUp>(
                    locale: 'ko_KR',
                    focusedDay: focusedMonth,
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2030),
                    selectedDayPredicate: (day) =>
                        isSameDay(day, selectedDate),
                    eventLoader: (day) => _getEventsForDay(day, eventMap),
                    onDaySelected: (selected, focused) {
                      ref
                          .read(meetupViewModelProvider(churchId).notifier)
                          .selectDate(selected);
                    },
                    onPageChanged: (focused) {
                      ref
                          .read(meetupViewModelProvider(churchId).notifier)
                          .changeFocusedMonth(focused);
                    },
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      defaultDecoration: const BoxDecoration(),
                      weekendDecoration: const BoxDecoration(),
                      outsideDecoration: const BoxDecoration(),
                      disabledDecoration: const BoxDecoration(),
                      todayDecoration: BoxDecoration(
                        color: AppColors.warmTangerine.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.warmTangerine,
                          width: 1.5,
                        ),
                      ),
                      selectedDecoration: BoxDecoration(
                        color: AppColors.warmTangerine,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      todayTextStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textDark,
                      ),
                      selectedTextStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.pureWhite,
                      ),
                      defaultTextStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textDark,
                      ),
                      outsideTextStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.disabled,
                      ),
                      weekendTextStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.softCoral,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: AppColors.warmTangerine,
                        shape: BoxShape.circle,
                      ),
                      markerSize: 6,
                      markersMaxCount: 3,
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: AppTextStyles.headlineMedium,
                      leftChevronIcon: const Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.textGrey,
                      ),
                      rightChevronIcon: const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textGrey,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders<MeetUp>(
                      dowBuilder: (ctx, day) {
                        if (day.weekday == DateTime.saturday) {
                          return Center(
                            child: Text(
                              DateFormat.E('ko_KR').format(day),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.skyBlue,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                      defaultBuilder: (ctx, day, focusedDay) {
                        if (day.weekday == DateTime.saturday) {
                          return Center(
                            child: Text(
                              '${day.day}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.skyBlue,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textGrey,
                      ),
                      weekendStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.softCoral,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── 날짜 헤더 ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Text(
                  DateFormat('M월 d일 (E) 번개', 'ko_KR').format(selectedDate),
                  style: AppTextStyles.bodyLarge,
                ),
              ),
            ),

            // ── 번개 목록 ─────────────────────────────────────────────
            if (selectedEvents.isEmpty)
              const SliverToBoxAdapter(child: _EmptyMeetupState())
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final meetup = selectedEvents[i];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                      child: MeetupCard(
                        meetup: meetup,
                        currentUserId: currentUserId,
                        onTap: () => MeetupDetailBottomSheet.show(
                          context,
                          meetup: meetup,
                          churchId: churchId,
                        ),
                        onReport: () => _onQuickReport(
                          context,
                          ref,
                          meetup: meetup,
                          currentUserId: currentUserId,
                        ),
                      ),
                    );
                  },
                  childCount: selectedEvents.length,
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),

        // ── FAB ─────────────────────────────────────────────────────
        Positioned(
          bottom: 24,
          right: 24,
          child: BouncyButton(
            text: '+ 번개 추가',
            isFullWidth: false,
            onPressed: () => MeetupCreateBottomSheet.show(
              context,
              churchId: churchId,
              initialDate: selectedDate,
            ),
          ),
        ),
      ],
    );
  }

  /// 카드 신고 아이콘 탭 시 즉시 신고 다이얼로그 표시
  Future<void> _onQuickReport(
    BuildContext context,
    WidgetRef ref, {
    required MeetUp meetup,
    required String? currentUserId,
  }) async {
    if (currentUserId == null) return;
    if (meetup.reportedBy.contains(currentUserId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미 신고한 모임이에요.')),
      );
      return;
    }
    if (meetup.meetLeaderId == currentUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('본인이 만든 모임은 신고할 수 없어요.')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('모임 신고'),
        content: const Text('이 모임을 신고하시겠어요?\n신고된 모임은 다른 참여자에게 경고가 표시됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('신고하기'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref
          .read(meetupViewModelProvider(churchId).notifier)
          .reportMeetup(churchId: churchId, meetupId: meetup.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('신고가 접수되었어요.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              StringUtils.cleanExceptionMessage(e),
            ),
          ),
        );
      }
    }
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _EmptyMeetupState extends StatelessWidget {
  const _EmptyMeetupState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.bolt_rounded,
              size: 56,
              color: AppColors.disabled,
            ),
            const SizedBox(height: 16),
            Text(
              '이 날에는 번개 모임이 없어요.\n먼저 번개를 열어보세요!',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
