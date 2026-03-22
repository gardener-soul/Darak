import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../models/prayer.dart';
import '../../../models/prayer_status.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/prayer/prayer_list_viewmodel.dart';

/// 내 기도 탭 캘린더 위젯
///
/// - 기본: 주간 뷰 (CalendarFormat.week)
/// - 월간 토글 가능
/// - 기도 있는 날짜에 마커 표시 (진행중: softCoral, 응답됨: sageGreen)
/// - 날짜 탭 → selectedPrayerDateProvider 업데이트
class PrayerCalendar extends ConsumerStatefulWidget {
  final List<Prayer> prayers;

  const PrayerCalendar({super.key, required this.prayers});

  @override
  ConsumerState<PrayerCalendar> createState() => _PrayerCalendarState();
}

class _PrayerCalendarState extends ConsumerState<PrayerCalendar> {
  CalendarFormat _format = CalendarFormat.week;

  @override
  Widget build(BuildContext context) {
    final selectedDay = ref.watch(selectedPrayerDateProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: AppDecorations.cardRadius,
        boxShadow: AppDecorations.clayShadow,
      ),
      child: TableCalendar<Prayer>(
        firstDay: DateTime(2020),
        lastDay: DateTime(2030),
        focusedDay: selectedDay,
        selectedDayPredicate: (day) => isSameDay(day, selectedDay),
        calendarFormat: _format,
        onFormatChanged: (f) => setState(() => _format = f),
        onDaySelected: (selected, focused) {
          ref.read(selectedPrayerDateProvider.notifier).select(selected);
        },
        eventLoader: _eventLoader,
        availableCalendarFormats: const {
          CalendarFormat.month: '월간',
          CalendarFormat.week: '주간',
        },
        calendarStyle: CalendarStyle(
          selectedDecoration: const BoxDecoration(
            color: AppColors.softCoral,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.softCoral.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          todayTextStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.softCoral,
            fontWeight: FontWeight.w700,
          ),
          selectedTextStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.pureWhite,
            fontWeight: FontWeight.w700,
          ),
          defaultTextStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textDark,
          ),
          weekendTextStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textDark,
          ),
          outsideTextStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textGrey,
          ),
          markerDecoration: const BoxDecoration(
            color: AppColors.softCoral,
            shape: BoxShape.circle,
          ),
          markersMaxCount: 2,
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            if (events.isEmpty) return const SizedBox.shrink();
            final hasAnswered =
                events.any((p) => p.status == PrayerStatus.answered);
            final hasActive =
                events.any((p) => p.status == PrayerStatus.active);
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasActive)
                  _Dot(color: AppColors.softCoral),
                if (hasAnswered)
                  _Dot(color: AppColors.sageGreen),
              ],
            );
          },
        ),
        headerStyle: HeaderStyle(
          formatButtonTextStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.softCoral,
          ),
          formatButtonDecoration: BoxDecoration(
            border: Border.all(color: AppColors.softCoral),
            borderRadius: BorderRadius.circular(12),
          ),
          titleTextStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left_rounded,
            color: AppColors.textDark,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textDark,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
          weekendStyle: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// 해당 날짜에 활성화된 기도 제목 반환 (startDate ≤ day ≤ endDate)
  List<Prayer> _eventLoader(DateTime day) {
    final d = DateTime(day.year, day.month, day.day);
    return widget.prayers.where((p) {
      final start = DateTime(
          p.startDate.year, p.startDate.month, p.startDate.day);
      if (d.isBefore(start)) return false;
      final end = p.endDate;
      if (end == null) return true;
      final endDay = DateTime(end.year, end.month, end.day);
      return !d.isAfter(endDay);
    }).toList();
  }
}

class _Dot extends StatelessWidget {
  final Color color;

  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
