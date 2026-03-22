import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/prayer_period_type.dart';
import '../../../models/prayer_visibility.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/prayer/prayer_create_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/soft_text_field.dart';

/// 기도 제목 등록 바텀시트
class PrayerCreateSheet extends ConsumerStatefulWidget {
  final String userId;
  final String churchId;
  final String? groupId;

  const PrayerCreateSheet({
    super.key,
    required this.userId,
    required this.churchId,
    this.groupId,
  });

  @override
  ConsumerState<PrayerCreateSheet> createState() => _PrayerCreateSheetState();
}

class _PrayerCreateSheetState extends ConsumerState<PrayerCreateSheet> {
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(prayerCreateViewModelProvider);
    final vm = ref.read(prayerCreateViewModelProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 핸들 바
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // 제목
          Text('새 기도 제목', style: AppTextStyles.bodyLarge),
          const SizedBox(height: 20),

          // 기도 제목 입력
          SoftTextField(
            controller: _contentController,
            hintText: '기도 제목을 입력하세요',
            maxLines: 3,
            minLines: 2,
            onChanged: vm.updateContent,
          ),
          // 글자 수 카운터 + 에러
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Row(
              children: [
                if (state.errorMessage != null)
                  Text(
                    state.errorMessage!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.softCoral,
                      fontSize: 12,
                    ),
                  ),
                const Spacer(),
                Text(
                  '${state.content.length}/200',
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 기간 유형 선택
          Text(
            '기도 기간',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _PeriodTypeChips(
            selected: state.periodType,
            onSelected: vm.updatePeriodType,
          ),

          // 날짜 범위 표시 (indefinite 제외)
          if (state.periodType != PrayerPeriodType.indefinite) ...[
            const SizedBox(height: 12),
            _DateRangeRow(
              start: state.startDate,
              end: state.endDate,
              periodType: state.periodType,
              onTap: () => _pickDateRange(context, state, vm),
            ),
          ],
          const SizedBox(height: 20),

          // 공개 범위 선택
          Text(
            '공개 범위',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          _VisibilityChips(
            selected: state.visibility,
            hasGroup: widget.groupId != null,
            onSelected: vm.updateVisibility,
          ),
          const SizedBox(height: 28),

          // 등록 버튼
          BouncyButton(
            text: '등록하기',
            onPressed: state.isLoading
                ? null
                : () async {
                    final ok = await vm.submit(
                      userId: widget.userId,
                      churchId: widget.churchId,
                      groupId: widget.groupId,
                    );
                    if (ok && context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('기도 제목이 등록되었어요 🙏'),
                          backgroundColor: AppColors.sageGreen,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }

  Future<void> _pickDateRange(
    BuildContext context,
    PrayerCreateState state,
    PrayerCreateViewModel vm,
  ) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: state.startDate,
        end: state.endDate ?? state.startDate.add(const Duration(days: 6)),
      ),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.softCoral,
              ),
        ),
        child: child ?? const SizedBox.shrink(),
      ),
    );
    if (picked != null) {
      vm.updateDateRange(picked.start, picked.end);
    }
  }
}

// ─── 기간 유형 칩 ─────────────────────────────────────────────────────────────

class _PeriodTypeChips extends StatelessWidget {
  final PrayerPeriodType selected;
  final ValueChanged<PrayerPeriodType> onSelected;

  const _PeriodTypeChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: PrayerPeriodType.values.map((type) {
        final isSelected = type == selected;
        return GestureDetector(
          onTap: () => onSelected(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.softCoral
                  : AppColors.pureWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.softCoral
                    : AppColors.divider,
              ),
              boxShadow: isSelected ? AppDecorations.floatingShadow : null,
            ),
            child: Text(
              type.label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.pureWhite : AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── 날짜 범위 표시 ───────────────────────────────────────────────────────────

class _DateRangeRow extends StatelessWidget {
  final DateTime start;
  final DateTime? end;
  final PrayerPeriodType periodType;
  final VoidCallback onTap;

  const _DateRangeRow({
    required this.start,
    required this.end,
    required this.periodType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('yyyy.MM.dd');
    final label = end != null
        ? '${fmt.format(start)} ~ ${fmt.format(end!)}'
        : fmt.format(start);

    return GestureDetector(
      onTap: periodType == PrayerPeriodType.daily ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.date_range_rounded,
              size: 18,
              color: AppColors.softCoral,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (periodType == PrayerPeriodType.daily) ...[
              const Spacer(),
              const Icon(
                Icons.edit_rounded,
                size: 16,
                color: AppColors.textGrey,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── 공개 범위 칩 ─────────────────────────────────────────────────────────────

class _VisibilityChips extends StatelessWidget {
  final PrayerVisibility selected;
  final bool hasGroup;
  final ValueChanged<PrayerVisibility> onSelected;

  const _VisibilityChips({
    required this.selected,
    required this.hasGroup,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: PrayerVisibility.values.map((v) {
            final isSelected = v == selected;
            final isDisabled =
                v == PrayerVisibility.group && !hasGroup;

            return GestureDetector(
              onTap: isDisabled ? null : () => onSelected(v),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDisabled
                      ? AppColors.disabled.withValues(alpha: 0.3)
                      : isSelected
                          ? AppColors.softCoral
                          : AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDisabled
                        ? AppColors.disabled
                        : isSelected
                            ? AppColors.softCoral
                            : AppColors.divider,
                  ),
                ),
                child: Text(
                  v.label,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDisabled
                        ? AppColors.textGrey
                        : isSelected
                            ? AppColors.pureWhite
                            : AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (!hasGroup) ...[
          const SizedBox(height: 6),
          Text(
            '다락방에 배정된 후 사용할 수 있어요',
            style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
          ),
        ],
      ],
    );
  }
}
