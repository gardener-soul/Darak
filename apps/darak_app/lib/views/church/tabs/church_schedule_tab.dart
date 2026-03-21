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
import '../../../viewmodels/church/church_detail_viewmodel.dart';
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

    // 월 전환 시 invalidateSelf()로 AsyncLoading이 되더라도 이전 데이터를 유지하여
    // 캘린더가 스피너로 교체되는 플리커 현상을 방지합니다.
    return schedulesAsync.when(
      skipLoadingOnRefresh: true,
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.softCoral),
      ),
      error: (e, stack) {
        // 쿼리 오류 시에도 빈 캘린더 표시 (이전 상태의 focusedMonth 보존)
        final prev = schedulesAsync.valueOrNull;
        final now = DateTime.now();
        return _CalendarBody(
          churchId: churchId,
          schedules: prev?.schedules ?? const [],
          focusedMonth: prev?.focusedMonth ?? DateTime(now.year, now.month),
          selectedDate: prev?.selectedDate ?? now,
        );
      },
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

    // 관리자(adminIds) 여부를 churchDetailViewModelProvider에서 직접 조회
    final detailAsync = ref.watch(churchDetailViewModelProvider(churchId));
    final isAdmin = detailAsync.valueOrNull?.isAdmin ?? false;
    if (isAdmin) return true;

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

    // 마을장(roleLevel=3) 이상 또는 사역자(roleLevel=99)는 일정 작성 가능
    return roleLevel >= 3;
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
                      // BoxDecoration.lerp() 시 shape 불일치 assertion 방지:
                      // 모든 셀 데코레이션을 rectangle(기본값)로 통일합니다.
                      defaultDecoration: const BoxDecoration(),
                      weekendDecoration: const BoxDecoration(),
                      outsideDecoration: const BoxDecoration(),
                      disabledDecoration: const BoxDecoration(),
                      todayDecoration: BoxDecoration(
                        color: AppColors.softLavender.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.softLavender,
                          width: 1.5,
                        ),
                      ),
                      selectedDecoration: BoxDecoration(
                        color: AppColors.softCoral,
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

    // 모든 사용자가 탭하여 일정 정보를 확인할 수 있음
    return GestureDetector(
      onTap: () => _showOptions(context, ref, canModify: canModify),
      child: ScheduleCard(schedule: schedule),
    );
  }

  void _showOptions(BuildContext context, WidgetRef ref, {required bool canModify}) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text('일정 정보'),
              onTap: () {
                Navigator.pop(ctx);
                _showScheduleInfo(context);
              },
            ),
            if (canModify) ...[
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
          ],
        ),
      ),
    );
  }

  void _showScheduleInfo(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => _ScheduleInfoSheet(schedule: schedule),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

/// 일정 상세 정보 바텀시트 (제목, 카테고리, 일시, 장소, 설명)
class _ScheduleInfoSheet extends StatelessWidget {
  final ChurchSchedule schedule;

  const _ScheduleInfoSheet({required this.schedule});

  String _formatDateTime(DateTime dt) {
    return DateFormat('yyyy년 M월 d일 (E) HH:mm', 'ko_KR').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(schedule.title, style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            _InfoRow(
              icon: Icons.access_time_rounded,
              text: _formatDateTime(schedule.startAt),
            ),
            if (schedule.location != null &&
                schedule.location!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.location_on_rounded,
                text: schedule.location!,
              ),
            ],
            if (schedule.description != null &&
                schedule.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('설명', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey)),
              const SizedBox(height: 4),
              Text(schedule.description!, style: AppTextStyles.bodyMedium),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: AppTextStyles.bodyMedium),
        ),
      ],
    );
  }
}
