import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/user_providers.dart';
import '../../../models/church_schedule.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/church/church_schedules_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';
import '../../../widgets/common/core/soft_chip.dart';
import '../../../widgets/common/soft_text_field.dart';

/// 일정 작성/수정 바텀시트
/// 관리자/사역자(roleLevel=99)/마을장(roleLevel=3)만 접근 가능
class ScheduleCreateBottomSheet extends ConsumerStatefulWidget {
  final String churchId;
  final ChurchSchedule? existingSchedule; // null이면 생성, 있으면 수정

  const ScheduleCreateBottomSheet({
    super.key,
    required this.churchId,
    this.existingSchedule,
  });

  static Future<void> show(
    BuildContext context, {
    required String churchId,
    ChurchSchedule? existingSchedule,
  }) {
    return AppBottomSheet.show(
      context: context,
      child: ScheduleCreateBottomSheet(
        churchId: churchId,
        existingSchedule: existingSchedule,
      ),
    );
  }

  @override
  ConsumerState<ScheduleCreateBottomSheet> createState() =>
      _ScheduleCreateBottomSheetState();
}

class _ScheduleCreateBottomSheetState
    extends ConsumerState<ScheduleCreateBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descController = TextEditingController();

  ScheduleCategory _category = ScheduleCategory.worship;
  DateTime? _startAt;
  bool _isLoading = false;

  bool get _isEdit => widget.existingSchedule != null;

  @override
  void initState() {
    super.initState();
    final s = widget.existingSchedule;
    if (s != null) {
      _titleController.text = s.title;
      _locationController.text = s.location ?? '';
      _descController.text = s.description ?? '';
      _category = s.category;
      _startAt = s.startAt;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startAt ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startAt ?? DateTime.now()),
    );
    if (time == null || !mounted) return;

    setState(() {
      _startAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_startAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('시작 일시를 선택해주세요.')),
      );
      return;
    }
    final currentUserId = ref.read(currentUserIdProvider);
    if (currentUserId == null) return;

    setState(() => _isLoading = true);
    try {
      final vm = ref.read(
        churchSchedulesViewModelProvider(widget.churchId).notifier,
      );

      if (_isEdit) {
        final data = <String, dynamic>{
          'title': _titleController.text.trim(),
          'category': _category.name,
          'startAt': _startAt!,
          'location': _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
          'description': _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
        };

        await vm.updateSchedule(
          churchId: widget.churchId,
          scheduleId: widget.existingSchedule!.id,
          data: data,
        );
      } else {
        final schedule = ChurchSchedule(
          id: '',
          title: _titleController.text.trim(),
          category: _category,
          startAt: _startAt!,
          location: _locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim(),
          description: _descController.text.trim().isEmpty
              ? null
              : _descController.text.trim(),
          isRecurring: false,
          createdBy: currentUserId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await vm.createSchedule(
          churchId: widget.churchId,
          schedule: schedule,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEdit ? '일정이 수정되었어요!' : '일정이 등록되었어요!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll(RegExp(r'^Exception:\s*'), ''),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isEdit ? '일정 수정' : '일정 추가',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 24),

            // ── 카테고리 선택 ───────────────────────────────────────
            Row(
              children: [
                SoftChip(
                  label: '예배',
                  icon: Icons.church_rounded,
                  color: AppColors.softCoral,
                  isSelected: _category == ScheduleCategory.worship,
                  onTap: () =>
                      setState(() => _category = ScheduleCategory.worship),
                ),
                const SizedBox(width: 8),
                SoftChip(
                  label: '행사',
                  icon: Icons.celebration_rounded,
                  color: AppColors.warmTangerine,
                  isSelected: _category == ScheduleCategory.event,
                  onTap: () =>
                      setState(() => _category = ScheduleCategory.event),
                ),
                const SizedBox(width: 8),
                SoftChip(
                  label: '모임',
                  icon: Icons.groups_rounded,
                  color: AppColors.sageGreen,
                  isSelected: _category == ScheduleCategory.meeting,
                  onTap: () =>
                      setState(() => _category = ScheduleCategory.meeting),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── 제목 ───────────────────────────────────────────────
            SoftTextField(
              controller: _titleController,
              hintText: '일정 제목 (필수)',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '일정 제목을 입력해주세요.' : null,
            ),
            const SizedBox(height: 12),

            // ── 시작 일시 ──────────────────────────────────────────
            _DateTimeField(
              value: _startAt,
              hint: '시작 일시 선택 (필수)',
              onTap: _pickStartDateTime,
            ),
            const SizedBox(height: 12),

            // ── 장소 ───────────────────────────────────────────────
            SoftTextField(
              controller: _locationController,
              hintText: '장소 (선택)',
              prefixIcon: const Icon(
                Icons.location_on_rounded,
                color: AppColors.textGrey,
                size: 20,
              ),
            ),
            const SizedBox(height: 12),

            // ── 설명 ───────────────────────────────────────────────
            SoftTextField(
              controller: _descController,
              hintText: '설명 (선택)',
              maxLines: 3,
              minLines: 2,
            ),
            const SizedBox(height: 24),

            BouncyButton(
              text: _isLoading
                  ? '저장 중...'
                  : (_isEdit ? '수정하기' : '저장하기'),
              onPressed: _isLoading ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _DateTimeField extends StatelessWidget {
  final DateTime? value;
  final String hint;
  final VoidCallback onTap;

  const _DateTimeField({
    required this.value,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy.MM.dd (E) HH:mm', 'ko');
    final isSelected = value != null;

    return BouncyTapWrapper(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: AppDecorations.defaultRadius,
          boxShadow: AppDecorations.innerInputShadow,
          border: isSelected
              ? Border.all(color: AppColors.softCoral, width: 2)
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              color: AppColors.textGrey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              isSelected ? formatter.format(value!) : hint,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.textDark : AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
