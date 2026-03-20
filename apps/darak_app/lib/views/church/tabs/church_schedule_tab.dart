import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/providers/user_providers.dart';
import '../../../models/church_member.dart';
import '../../../models/church_schedule.dart';
import '../../../repositories/church_member_repository.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/church/church_roles_provider.dart';
import '../../../viewmodels/church/church_schedules_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/core/soft_dialog.dart';
import '../widgets/schedule_card.dart';
import '../widgets/schedule_create_bottom_sheet.dart';

/// 단일 교회 멤버 정보 조회 Provider (일정 탭 권한 확인용)
final churchMemberSingleProvider = FutureProvider.family<ChurchMember?,
    ({String churchId, String userId})>(
  (ref, params) => ref.watch(churchMemberRepositoryProvider).getMember(
        churchId: params.churchId,
        userId: params.userId,
      ),
);

/// 교회 상세 - 일정 탭 (캘린더 기반 UI)
class ChurchScheduleTab extends ConsumerWidget {
  final String churchId;

  const ChurchScheduleTab({super.key, required this.churchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync =
        ref.watch(churchSchedulesViewModelProvider(churchId));

    return schedulesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.softCoral),
      ),
      error: (e, stack) => Center(
        child: Text(
          '일정을 불러오지 못했어요.',
          style: AppTextStyles.bodySmall,
        ),
      ),
      data: (scheduleState) => _CalendarBody(
        churchId: churchId,
        schedules: scheduleState.schedules,
        focusedMonth: scheduleState.focusedMonth,
        selectedDate: scheduleState.selectedDate,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _CalendarBody extends ConsumerWidget {
  final String churchId;
  final List<ChurchSchedule> schedules;
  final DateTime focusedMonth;
  final DateTime selectedDate;

  const _CalendarBody({
    required this.churchId,
    required this.schedules,
    required this.focusedMonth,
    required this.selectedDate,
  });

  bool _canWriteSchedule(WidgetRef ref, String churchId) {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return false;

    final memberAsync = ref.watch(
      churchMemberSingleProvider((churchId: churchId, userId: userId)),
    );
    final member = memberAsync.valueOrNull;
    if (member == null) return false;

    final rolesAsync = ref.watch(churchRolesProvider(churchId));
    final roles = rolesAsync.valueOrNull ?? [];
    final roleLevel = roles
            .where((r) => r.id == member.roleId)
            .firstOrNull
            ?.level ??
        1;

    // 사역자(roleLevel=99), 마을장(roleLevel=3), 관리자는 일정 작성 가능
    return roleLevel >= 3 || roleLevel == 99;
  }

  Map<DateTime, List<ChurchSchedule>> _buildEventMap(
    List<ChurchSchedule> schedules,
  ) {
    final map = <DateTime, List<ChurchSchedule>>{};
    for (final s in schedules) {
      final day = DateTime(s.startAt.year, s.startAt.month, s.startAt.day);
      map.putIfAbsent(day, () => []).add(s);
    }
    return map;
  }

  List<ChurchSchedule> _getEventsForDay(
    DateTime day,
    Map<DateTime, List<ChurchSchedule>> eventMap,
  ) {
    return eventMap[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canWrite = _canWriteSchedule(ref, churchId);
    final eventMap = _buildEventMap(schedules);
    final selectedEvents = _getEventsForDay(selectedDate, eventMap);

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // ── 캘린더 영역 ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: ClayCard(
                  padding: const EdgeInsets.all(16),
                  child: TableCalendar<ChurchSchedule>(
                    locale: 'ko_KR',
                    focusedDay: focusedMonth,
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2030),
                    selectedDayPredicate: (day) =>
                        isSameDay(day, selectedDate),
                    eventLoader: (day) => _getEventsForDay(day, eventMap),
                    onDaySelected: (selected, focused) {
                      ref
                          .read(
                            churchSchedulesViewModelProvider(churchId)
                                .notifier,
                          )
                          .selectDate(selected);
                    },
                    onPageChanged: (focused) {
                      ref
                          .read(
                            churchSchedulesViewModelProvider(churchId)
                                .notifier,
                          )
                          .changeFocusedMonth(churchId, focused);
                    },
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      todayDecoration: BoxDecoration(
                        color: AppColors.softLavender.withValues(alpha: 0.4),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.softLavender,
                          width: 1.5,
                        ),
                      ),
                      selectedDecoration: BoxDecoration(
                        color: AppColors.softCoral,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      todayTextStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textDark,
                      ),
                      selectedTextStyle: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
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
                        color: AppColors.softCoral,
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

            // ── 선택 날짜 헤더 ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Text(
                  DateFormat('M월 d일 (E) 일정', 'ko_KR').format(selectedDate),
                  style: AppTextStyles.bodyLarge,
                ),
              ),
            ),

            // ── 일정 목록 ───────────────────────────────────────────
            if (selectedEvents.isEmpty)
              const SliverToBoxAdapter(child: _EmptyDayState())
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                    child: _ScheduleCardWithActions(
                      churchId: churchId,
                      schedule: selectedEvents[i],
                      canEdit: canWrite,
                    ),
                  ),
                  childCount: selectedEvents.length,
                ),
              ),

            // FAB 아래 여백
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),

        // ── FAB ───────────────────────────────────────────────────
        if (canWrite)
          Positioned(
            bottom: 24,
            right: 24,
            child: BouncyButton(
              text: '+ 일정 추가',
              isFullWidth: false,
              onPressed: () => ScheduleCreateBottomSheet.show(
                context,
                churchId: churchId,
              ),
            ),
          ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _EmptyDayState extends StatelessWidget {
  const _EmptyDayState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.event_busy_rounded,
              size: 56,
              color: AppColors.disabled,
            ),
            const SizedBox(height: 16),
            Text(
              '이 날에는 일정이 없어요.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleCardWithActions extends ConsumerWidget {
  final String churchId;
  final ChurchSchedule schedule;
  final bool canEdit;

  const _ScheduleCardWithActions({
    required this.churchId,
    required this.schedule,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final canModify = canEdit || schedule.createdBy == currentUserId;

    return GestureDetector(
      onTap: canModify ? () => _showOptions(context, ref) : null,
      child: ScheduleCard(schedule: schedule),
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('수정'),
              onTap: () {
                Navigator.pop(ctx);
                ScheduleCreateBottomSheet.show(
                  context,
                  churchId: churchId,
                  existingSchedule: schedule,
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_rounded,
                color: AppColors.softCoral,
              ),
              title: const Text(
                '삭제',
                style: TextStyle(color: AppColors.softCoral),
              ),
              onTap: () async {
                Navigator.pop(ctx);
                final confirmed = await SoftDialog.show<bool>(
                  context: context,
                  title: '일정 삭제',
                  content: '정말 이 일정을 삭제하시겠어요?',
                  actions: [
                    SoftDialogAction(
                      label: '취소',
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    SoftDialogAction(
                      label: '삭제',
                      isDestructive: true,
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                );
                if (confirmed != true || !context.mounted) return;
                try {
                  await ref
                      .read(
                        churchSchedulesViewModelProvider(churchId).notifier,
                      )
                      .deleteSchedule(
                        churchId: churchId,
                        scheduleId: schedule.id,
                      );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('일정이 삭제되었어요.')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          e
                              .toString()
                              .replaceAll(RegExp(r'^Exception:\s*'), ''),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
