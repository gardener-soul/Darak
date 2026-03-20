import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/group.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/church/church_community_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';
import '../../../widgets/common/soft_text_field.dart';

/// 다락방 수정 바텀시트
/// 이름(필수)과 설명(선택)을 수정할 수 있습니다.
class GroupEditBottomSheet extends ConsumerStatefulWidget {
  final String churchId;
  final Group group;

  const GroupEditBottomSheet({
    super.key,
    required this.churchId,
    required this.group,
  });

  static Future<void> show(
    BuildContext context, {
    required String churchId,
    required Group group,
  }) {
    return AppBottomSheet.show(
      context: context,
      child: GroupEditBottomSheet(churchId: churchId, group: group),
    );
  }

  @override
  ConsumerState<GroupEditBottomSheet> createState() =>
      _GroupEditBottomSheetState();
}

class _GroupEditBottomSheetState extends ConsumerState<GroupEditBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group.name);
    _descController = TextEditingController(
      text: widget.group.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final sanitizedName = _nameController.text.trim().replaceAll(
      RegExp(r'\s+'),
      ' ',
    );
    final rawDesc = _descController.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    final sanitizedDesc = rawDesc.isEmpty ? null : rawDesc;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(churchCommunityViewModelProvider(widget.churchId).notifier)
          .updateGroup(
            groupId: widget.group.id,
            name: sanitizedName,
            description: sanitizedDesc,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('다락방 정보가 수정되었어요!')),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('다락방 수정', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 20),
          SoftTextField(
            controller: _nameController,
            hintText: '다락방 이름 (필수)',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? '다락방 이름을 입력해주세요.' : null,
          ),
          const SizedBox(height: 12),
          SoftTextField(
            controller: _descController,
            hintText: '다락방 설명 (선택)',
            maxLines: 3,
            minLines: 2,
          ),
          const SizedBox(height: 24),
          BouncyButton(
            text: _isLoading ? '저장 중...' : '저장하기',
            onPressed: _isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }
}
