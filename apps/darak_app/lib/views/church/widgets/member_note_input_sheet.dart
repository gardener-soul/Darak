import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/string_utils.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/member/member_detail_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';

/// 비공개 메모 작성/수정 바텀시트
class MemberNoteInputSheet extends ConsumerStatefulWidget {
  final String targetUserId;
  final String currentUserId;
  final String? noteId; // null이면 신규 작성, 있으면 수정
  final String? initialContent;

  const MemberNoteInputSheet({
    super.key,
    required this.targetUserId,
    required this.currentUserId,
    this.noteId,
    this.initialContent,
  });

  @override
  ConsumerState<MemberNoteInputSheet> createState() =>
      _MemberNoteInputSheetState();
}

class _MemberNoteInputSheetState extends ConsumerState<MemberNoteInputSheet> {
  late final TextEditingController _controller;
  bool _isLoading = false;

  bool get _isEdit => widget.noteId != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final vm = ref.read(
        memberDetailViewModelProvider(widget.targetUserId).notifier,
      );
      if (_isEdit) {
        await vm.updateNote(noteId: widget.noteId!, content: content);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('메모가 수정되었어요'),
            backgroundColor: AppColors.sageGreen,
          ),
        );
      } else {
        await vm.addNote(
          content: content,
          createdBy: widget.currentUserId,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('메모가 저장되었어요'),
            backgroundColor: AppColors.sageGreen,
          ),
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(StringUtils.cleanExceptionMessage(e)),
          backgroundColor: AppColors.softCoral,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEdit ? '메모 수정' : '새 메모 작성',
            style: AppTextStyles.bodyLarge,
          ),
          const SizedBox(height: 4),
          Text(
            '순원에게 보이지 않는 비공개 메모입니다',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 16),

          // 입력 필드
          Container(
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppDecorations.innerInputShadow,
            ),
            child: TextField(
              controller: _controller,
              maxLines: 5,
              maxLength: 500,
              autofocus: true,
              decoration: InputDecoration(
                hintText: '순원에 대한 메모를 입력하세요',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.disabled,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              style: AppTextStyles.bodyMedium,
            ),
          ),
          const SizedBox(height: 20),

          BouncyButton(
            text: _isEdit ? '수정하기' : '저장하기',
            icon: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.pureWhite,
                      strokeWidth: 2,
                    ),
                  )
                : null,
            onPressed: _isLoading ? null : _onSave,
          ),
        ],
      ),
    );
  }
}
