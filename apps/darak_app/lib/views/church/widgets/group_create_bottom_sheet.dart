import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme.dart';
import '../../../viewmodels/church/church_community_viewmodel.dart';
import '../../../viewmodels/church/church_detail_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';
import '../../../widgets/common/soft_text_field.dart';

/// 다락방 생성 바텀시트
/// 다락방 이름(필수) + 설명(선택) 입력 후 createGroup 호출
class GroupCreateBottomSheet extends ConsumerStatefulWidget {
  final String churchId;
  final String villageId;

  const GroupCreateBottomSheet({
    super.key,
    required this.churchId,
    required this.villageId,
  });

  /// 바텀시트를 표시하는 정적 헬퍼
  static Future<void> show(
    BuildContext context, {
    required String churchId,
    required String villageId,
  }) {
    return AppBottomSheet.show(
      context: context,
      child: GroupCreateBottomSheet(
        churchId: churchId,
        villageId: villageId,
      ),
    );
  }

  @override
  ConsumerState<GroupCreateBottomSheet> createState() =>
      _GroupCreateBottomSheetState();
}

class _GroupCreateBottomSheetState
    extends ConsumerState<GroupCreateBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // 현재 유저 ID 확인 (leaderId 필수)
    final detailAsync =
        ref.read(churchDetailViewModelProvider(widget.churchId));
    final currentMember = detailAsync.valueOrNull?.currentMember;
    if (currentMember == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('교회 멤버만 다락방을 생성할 수 있습니다.')),
      );
      return;
    }

    // 저장 전 최종 sanitize: 앞뒤 공백 및 연속 공백 정규화
    final sanitizedName = _nameController.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    final rawDesc = _descController.text.trim().replaceAll(RegExp(r'\s+'), ' ');
    final sanitizedDesc = rawDesc.isEmpty ? null : rawDesc;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(churchCommunityViewModelProvider(widget.churchId).notifier)
          .createGroup(
            churchId: widget.churchId,
            villageId: widget.villageId,
            name: sanitizedName,
            description: sanitizedDesc,
            leaderId: currentMember.userId,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('\'$sanitizedName\' 다락방이 생성되었어요!'),
        ),
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
          const Text('다락방 만들기', style: AppTextStyles.headlineMedium),
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
            text: '만들기',
            onPressed: _isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }
}
