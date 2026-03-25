import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/string_utils.dart';
import '../../../models/group.dart';
import '../../../repositories/user_repository.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/church/church_community_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';
import '../../../widgets/common/core/clay_avatar.dart';
import '../../../widgets/common/soft_text_field.dart';

/// 다락방 수정 바텀시트
/// 이름(필수), 설명(선택), 순장(선택)을 수정할 수 있습니다.
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
  String? _selectedLeaderId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group.name);
    _descController = TextEditingController(
      text: widget.group.description ?? '',
    );
    _selectedLeaderId = widget.group.leaderId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _onLeaderPickTap() async {
    final memberIds = widget.group.memberIds ?? [];
    if (memberIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('다락방에 순원을 먼저 추가한 후 순장을 지정해주세요.')),
      );
      return;
    }

    if (!mounted) return;
    final selectedUserId = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: AppColors.creamWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) => _LeaderPickerSheet(
        group: widget.group,
        currentLeaderId: _selectedLeaderId,
      ),
    );

    if (selectedUserId == null || !mounted) return;
    setState(() {
      _selectedLeaderId = selectedUserId == 'remove' ? null : selectedUserId;
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final sanitizedName = _nameController.text.trim().replaceAll(
      RegExp(r'\s+'),
      ' ',
    );
    final rawDesc =
        _descController.text.trim().replaceAll(RegExp(r'\s+'), ' ');
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

      // 순장이 변경된 경우에만 updateGroupLeader 호출
      if (_selectedLeaderId != widget.group.leaderId) {
        await ref
            .read(churchCommunityViewModelProvider(widget.churchId).notifier)
            .updateGroupLeader(
              groupId: widget.group.id,
              leaderId: _selectedLeaderId,
            );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('다락방 정보가 수정되었어요!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(StringUtils.cleanExceptionMessage(e)),
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

          // ── 다락방 이름 ───────────────────────────────────────────
          const Text('다락방 이름', style: AppTextStyles.bodySmall),
          const SizedBox(height: 6),
          SoftTextField(
            controller: _nameController,
            hintText: '다락방 이름을 입력해주세요',
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? '다락방 이름을 입력해주세요.' : null,
          ),
          const SizedBox(height: 16),

          // ── 다락방 설명 ───────────────────────────────────────────
          const Text('다락방 설명', style: AppTextStyles.bodySmall),
          const SizedBox(height: 6),
          SoftTextField(
            controller: _descController,
            hintText: '다락방 설명 (선택)',
            maxLines: 3,
            minLines: 2,
          ),
          const SizedBox(height: 16),

          // ── 순장 ─────────────────────────────────────────────────
          const Text('순장', style: AppTextStyles.bodySmall),
          const SizedBox(height: 6),
          _LeaderSelector(
            selectedLeaderId: _selectedLeaderId,
            onTap: _onLeaderPickTap,
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

// ──────────────────────────────────────────────────────────────────────────────

/// 순장 선택 탭 영역 (현재 선택된 순장을 표시하고 탭 시 선택 시트 오픈)
class _LeaderSelector extends ConsumerWidget {
  final String? selectedLeaderId;
  final VoidCallback onTap;

  const _LeaderSelector({
    required this.selectedLeaderId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderAsync = selectedLeaderId != null
        ? ref.watch(userByIdProvider(selectedLeaderId!))
        : null;
    final leaderName = leaderAsync?.valueOrNull?.name;
    final leaderPhotoUrl = leaderAsync?.valueOrNull?.profileImageUrl;

    final displayText = selectedLeaderId == null
        ? '순장 미지정 (탭하여 선택)'
        : (leaderName ?? '조회 중...');
    final hasLeader = selectedLeaderId != null;

    return BouncyTapWrapper(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: AppDecorations.defaultRadius,
          boxShadow: AppDecorations.innerInputShadow,
          border: Border.all(
            color: hasLeader
                ? AppColors.warmTangerine.withValues(alpha: 0.4)
                : AppColors.divider,
            width: hasLeader ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            if (hasLeader)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ClayAvatar(imageUrl: leaderPhotoUrl, size: AvatarSize.small),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.person_add_rounded,
                  size: 20,
                  color: AppColors.textGrey,
                ),
              ),
            Expanded(
              child: Text(
                displayText,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: hasLeader ? AppColors.textDark : AppColors.textGrey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textGrey,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 순장 선택 바텀시트
// ──────────────────────────────────────────────────────────────────────────────

/// 다락방 순원 목록 중에서 순장을 선택하는 바텀시트.
/// 반환값: 선택한 userId | 'remove' (순장 해제) | null (취소)
class _LeaderPickerSheet extends ConsumerWidget {
  final Group group;
  final String? currentLeaderId;

  const _LeaderPickerSheet({
    required this.group,
    required this.currentLeaderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberIds = group.memberIds ?? [];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.warmTangerine,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text('순장 선택', style: AppTextStyles.headlineMedium),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '새 순장으로 지정할 순원을 선택해주세요.',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.divider, height: 1),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: memberIds.length,
                itemBuilder: (ctx, i) {
                  final uid = memberIds[i];
                  final userAsync = ref.watch(userByIdProvider(uid));
                  final isCurrentLeader = uid == currentLeaderId;
                  final name = userAsync.valueOrNull?.name ?? uid;
                  final photoUrl = userAsync.valueOrNull?.profileImageUrl;

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 4),
                    leading: ClayAvatar(
                      imageUrl: photoUrl,
                      size: AvatarSize.small,
                    ),
                    title: Text(name, style: AppTextStyles.bodyMedium),
                    trailing: isCurrentLeader
                        ? const Icon(
                            Icons.star_rounded,
                            color: AppColors.warmTangerine,
                            size: 18,
                          )
                        : null,
                    onTap: () => Navigator.pop(context, uid),
                  );
                },
              ),
            ),
            // 순장 해제 버튼 (현재 순장이 있을 때만)
            if (currentLeaderId != null) ...[
              const Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => Navigator.pop(context, 'remove'),
                icon: const Icon(
                  Icons.person_remove_rounded,
                  color: AppColors.softCoral,
                  size: 18,
                ),
                label: Text(
                  '순장 해제',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.softCoral),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
