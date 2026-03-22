import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/prayer.dart';
import '../../../models/prayer_period_type.dart';
import '../../../models/prayer_status.dart';
import '../../../models/prayer_visibility.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/prayer/prayer_list_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/soft_text_field.dart';

/// 기도 제목 상세/수정 바텀시트
class PrayerDetailSheet extends ConsumerStatefulWidget {
  final Prayer prayer;
  final String? groupId;

  const PrayerDetailSheet({
    super.key,
    required this.prayer,
    this.groupId,
  });

  @override
  ConsumerState<PrayerDetailSheet> createState() => _PrayerDetailSheetState();
}

class _PrayerDetailSheetState extends ConsumerState<PrayerDetailSheet> {
  late TextEditingController _contentController;
  late PrayerVisibility _visibility;
  bool _isEditMode = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _contentController =
        TextEditingController(text: widget.prayer.content);
    _visibility = widget.prayer.visibility;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prayer = widget.prayer;
    final isAnswered = prayer.status == PrayerStatus.answered;
    final fmt = DateFormat('yyyy.MM.dd');

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
          // 헤더 — 상태 뱃지 + 수정/삭제 버튼
          Row(
            children: [
              _StatusBadge(isAnswered: isAnswered),
              const Spacer(),
              if (!isAnswered) ...[
                IconButton(
                  icon: Icon(
                    _isEditMode
                        ? Icons.check_rounded
                        : Icons.edit_rounded,
                    color: AppColors.textDark,
                  ),
                  onPressed: _isEditMode ? _saveEdit : () {
                    setState(() => _isEditMode = true);
                  },
                ),
              ],
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.softCoral,
                ),
                onPressed: _confirmDelete,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 기도 제목 (읽기 / 수정 모드)
          if (_isEditMode)
            SoftTextField(
              controller: _contentController,
              hintText: '기도 제목을 입력하세요',
              maxLines: 4,
              minLines: 2,
            )
          else
            Text(
              prayer.content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textDark,
                height: 1.6,
              ),
            ),
          const SizedBox(height: 16),

          // 기간 정보
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            label: prayer.endDate != null
                ? '${fmt.format(prayer.startDate)} ~ ${fmt.format(prayer.endDate!)}'
                : '${fmt.format(prayer.startDate)} ~ (기간 없음)',
          ),
          const SizedBox(height: 8),
          // 기간 유형
          _InfoRow(
            icon: Icons.repeat_rounded,
            label: prayer.periodType.label,
          ),
          const SizedBox(height: 8),

          // 공개 범위 (수정 모드에서 변경 가능)
          if (_isEditMode)
            _VisibilitySelector(
              selected: _visibility,
              hasGroup: widget.groupId != null,
              onChanged: (v) => setState(() => _visibility = v),
            )
          else
            _InfoRow(
              icon: _visibility == PrayerVisibility.private
                  ? Icons.lock_rounded
                  : Icons.group_rounded,
              label: _visibility.label,
            ),

          // 응답됨 일시
          if (isAnswered && prayer.answeredAt != null) ...[
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.check_circle_rounded,
              label: '응답됨 · ${fmt.format(prayer.answeredAt!)}',
              color: AppColors.sageGreen,
            ),
          ],
          const SizedBox(height: 24),

          // 응답됨으로 변경 버튼 (진행중인 경우만)
          if (!isAnswered && !_isEditMode)
            BouncyButton(
              text: '🙏 응답됨으로 변경',
              color: AppColors.sageGreen,
              onPressed: _isLoading
                  ? null
                  : _confirmMarkAnswered,
            ),
        ],
      ),
    );
  }

  // ─── 액션 ──────────────────────────────────────────────────────────────────

  Future<void> _saveEdit() async {
    final newContent = _contentController.text.trim();
    if (newContent.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(prayerListViewModelProvider.notifier).editPrayer(
            widget.prayer.id,
            content: newContent,
            visibility: _visibility,
          );
      setState(() {
        _isEditMode = false;
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('수정되었어요'),
            backgroundColor: AppColors.sageGreen,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      debugPrint('기도 수정 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('저장에 실패했어요. 다시 시도해주세요.')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmMarkAnswered() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('기도 응답 확인'),
        content: const Text('이 기도 제목을 "응답됨"으로 변경할까요?\n감사한 마음을 기록해요 🙏'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              '응답됨으로 변경',
              style: TextStyle(color: AppColors.sageGreen),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await ref
            .read(prayerListViewModelProvider.notifier)
            .markAsAnswered(widget.prayer.id);
        if (mounted) Navigator.of(context).pop();
      } catch (e) {
        debugPrint('기도 응답 처리 실패: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('처리에 실패했어요. 다시 시도해주세요.')),
          );
        }
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('기도 제목 삭제'),
        content: const Text('이 기도 제목을 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              '삭제',
              style: TextStyle(color: AppColors.softCoral),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await ref
            .read(prayerListViewModelProvider.notifier)
            .deletePrayer(widget.prayer.id);
        if (mounted) Navigator.of(context).pop();
      } catch (e) {
        debugPrint('기도 삭제 실패: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('삭제에 실패했어요. 다시 시도해주세요.')),
          );
        }
        setState(() => _isLoading = false);
      }
    }
  }
}

// ─── 서브 위젯 ────────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final bool isAnswered;

  const _StatusBadge({required this.isAnswered});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isAnswered
            ? AppColors.sageGreen.withValues(alpha: 0.2)
            : AppColors.softCoral.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isAnswered ? '응답됨 ✨' : '기도 중 🙏',
        style: AppTextStyles.bodySmall.copyWith(
          color:
              isAnswered ? AppColors.sageGreen : AppColors.softCoral,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoRow({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color ?? AppColors.textGrey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: color ?? AppColors.textGrey,
            ),
          ),
        ),
      ],
    );
  }
}

class _VisibilitySelector extends StatelessWidget {
  final PrayerVisibility selected;
  final bool hasGroup;
  final ValueChanged<PrayerVisibility> onChanged;

  const _VisibilitySelector({
    required this.selected,
    required this.hasGroup,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: PrayerVisibility.values.map((v) {
        final isSelected = v == selected;
        final isDisabled = v == PrayerVisibility.group && !hasGroup;
        return GestureDetector(
          onTap: isDisabled ? null : () => onChanged(v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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
                fontSize: 13,
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
    );
  }
}
