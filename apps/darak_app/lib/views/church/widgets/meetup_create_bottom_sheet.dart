import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/user_providers.dart';
import '../../../core/utils/string_utils.dart';
import '../../../models/meetup.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/meetup/meetup_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';
import '../../../widgets/common/soft_text_field.dart';

/// 번개 모임 생성 바텀시트
class MeetupCreateBottomSheet extends ConsumerStatefulWidget {
  final String churchId;
  final DateTime? initialDate;

  const MeetupCreateBottomSheet({
    super.key,
    required this.churchId,
    this.initialDate,
  });

  static Future<void> show(
    BuildContext context, {
    required String churchId,
    DateTime? initialDate,
  }) {
    return AppBottomSheet.show(
      context: context,
      child: MeetupCreateBottomSheet(
        churchId: churchId,
        initialDate: initialDate,
      ),
    );
  }

  @override
  ConsumerState<MeetupCreateBottomSheet> createState() =>
      _MeetupCreateBottomSheetState();
}

class _MeetupCreateBottomSheetState
    extends ConsumerState<MeetupCreateBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();

  DateTime? _scheduledAt;
  bool _isUnlimited = true;
  int _maxParticipants = 4;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scheduledAt = widget.initialDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt ?? DateTime.now()),
    );
    if (time == null || !mounted) return;

    setState(() {
      _scheduledAt = DateTime(
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
    if (_scheduledAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모임 일시를 선택해주세요.')),
      );
      return;
    }

    final currentUserId = ref.read(currentUserIdProvider);
    if (currentUserId == null) return;

    setState(() => _isLoading = true);
    try {
      final now = DateTime.now();
      final meetup = MeetUp(
        id: '',
        name: _nameController.text.trim(),
        churchId: widget.churchId,
        meetLeaderId: currentUserId,
        createdAt: now,
        updatedAt: now,
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        scheduledAt: _scheduledAt,
        maxParticipants: _isUnlimited ? null : _maxParticipants,
        participantIds: [currentUserId],
      );

      await ref
          .read(meetupViewModelProvider(widget.churchId).notifier)
          .createMeetup(churchId: widget.churchId, meetup: meetup);

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('번개 모임이 생성되었어요! ⚡')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            StringUtils.cleanExceptionMessage(e),
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
            Text('번개 열기', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 24),

            // ── 모임 이름 ─────────────────────────────────────────
            SoftTextField(
              controller: _nameController,
              hintText: '모임 이름 (필수)',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '모임 이름을 입력해주세요.' : null,
            ),
            const SizedBox(height: 12),

            // ── 일시 선택 ─────────────────────────────────────────
            _DateTimeField(
              value: _scheduledAt,
              hint: '모임 일시 선택 (필수)',
              onTap: _pickDateTime,
            ),
            const SizedBox(height: 12),

            // ── 설명 ──────────────────────────────────────────────
            SoftTextField(
              controller: _descController,
              hintText: '모임 설명 (선택)',
              maxLines: 3,
              minLines: 2,
            ),
            const SizedBox(height: 20),

            // ── 최대 인원 설정 ────────────────────────────────────
            Text(
              '최대 참여 인원',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            _MaxParticipantsStepper(
              isUnlimited: _isUnlimited,
              value: _maxParticipants,
              onUnlimitedChanged: (val) =>
                  setState(() => _isUnlimited = val),
              onValueChanged: (val) =>
                  setState(() => _maxParticipants = val),
            ),
            const SizedBox(height: 28),

            // ── 제출 버튼 ─────────────────────────────────────────
            BouncyButton(
              text: _isLoading ? '번개 생성 중...' : '번개 열기 ⚡',
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
              Icons.bolt_rounded,
              color: AppColors.warmTangerine,
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

// ──────────────────────────────────────────────────────────────────────────────

/// [-] N명 [+] 형태의 스텝퍼 + '제한없음' 토글
class _MaxParticipantsStepper extends StatelessWidget {
  final bool isUnlimited;
  final int value;
  final ValueChanged<bool> onUnlimitedChanged;
  final ValueChanged<int> onValueChanged;

  const _MaxParticipantsStepper({
    required this.isUnlimited,
    required this.value,
    required this.onUnlimitedChanged,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 제한없음 토글
        GestureDetector(
          onTap: () => onUnlimitedChanged(!isUnlimited),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isUnlimited
                  ? AppColors.softCoral.withValues(alpha: 0.15)
                  : AppColors.pureWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isUnlimited
                    ? AppColors.softCoral
                    : AppColors.divider,
                width: 1.5,
              ),
            ),
            child: Text(
              '제한없음',
              style: AppTextStyles.bodySmall.copyWith(
                color: isUnlimited
                    ? AppColors.softCoral
                    : AppColors.textGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // 스텝퍼 (제한있을 때만 활성화)
        AnimatedOpacity(
          opacity: isUnlimited ? 0.4 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.divider, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepperButton(
                  icon: Icons.remove_rounded,
                  onTap: (!isUnlimited && value > 2)
                      ? () => onValueChanged(value - 1)
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '$value명',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _StepperButton(
                  icon: Icons.add_rounded,
                  onTap: (!isUnlimited && value < 50)
                      ? () => onValueChanged(value + 1)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: onTap != null
              ? AppColors.softCoral.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap != null ? AppColors.softCoral : AppColors.disabled,
        ),
      ),
    );
  }
}
