import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user.dart';
import '../../../repositories/church_member_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/church/church_community_viewmodel.dart';
import '../../../viewmodels/church/church_detail_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';
import '../../../widgets/common/core/bouncy_icon_btn.dart';
import '../../../widgets/common/core/clay_avatar.dart';
import '../../../widgets/common/soft_text_field.dart';

/// 다락방 생성 바텀시트
/// 다락방 이름(필수) + 설명(선택) + 순장 지정(선택) 입력 후 createGroup 호출
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

  // 순장 선택 상태 (null = 선택 안 함)
  User? _selectedLeader;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // 현재 유저 ID 확인 (교회 멤버 검증)
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
            leaderId: _selectedLeader?.id, // 선택한 순장 또는 null
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

  /// 교회 멤버 중 순장을 선택하는 바텀시트를 표시합니다.
  Future<void> _showLeaderSelector() async {
    if (!mounted) return;

    // 교회 멤버 목록 조회 (한 번만)
    final members = await ref
        .read(churchMemberRepositoryProvider)
        .getMembers(churchId: widget.churchId, limit: 200);

    if (!mounted) return;

    final selectedUser = await showModalBottomSheet<User?>(
      context: context,
      backgroundColor: AppColors.creamWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      isScrollControlled: true,
      builder: (ctx) => _MemberSelectorSheet(
        churchId: widget.churchId,
        members: members.map((m) => m.userId).toList(),
        currentSelectedId: _selectedLeader?.id,
      ),
    );

    if (selectedUser != null) {
      setState(() => _selectedLeader = selectedUser);
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
          const SizedBox(height: 16),

          // ── 순장 지정 (선택) ──────────────────────────────────────
          Text(
            '순장 지정 (선택)',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: _showLeaderSelector,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _selectedLeader != null
                      ? AppColors.warmTangerine.withValues(alpha: 0.5)
                      : AppColors.divider,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: AppColors.warmTangerine,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _selectedLeader != null
                        ? Row(
                            children: [
                              ClayAvatar(
                                imageUrl: _selectedLeader!.profileImageUrl,
                                size: AvatarSize.small,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _selectedLeader!.name,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          )
                        : Text(
                            '선택 안 함',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                  ),
                  if (_selectedLeader != null)
                    BouncyIconBtn(
                      icon: Icons.close_rounded,
                      color: AppColors.textGrey,
                      size: IconBtnSize.small,
                      onTap: () => setState(() => _selectedLeader = null),
                    )
                  else
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textGrey,
                      size: 20,
                    ),
                ],
              ),
            ),
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

// ──────────────────────────────────────────────────────────────────────────────
// 멤버 선택 시트 (순장 지정용)
// ──────────────────────────────────────────────────────────────────────────────

/// 교회 멤버 userId 목록에서 한 명을 선택하여 [User]를 반환하는 바텀시트.
class _MemberSelectorSheet extends ConsumerWidget {
  final String churchId;
  final List<String> members;
  final String? currentSelectedId;

  const _MemberSelectorSheet({
    required this.churchId,
    required this.members,
    required this.currentSelectedId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.warmTangerine, size: 20),
                const SizedBox(width: 8),
                Text('순장 선택', style: AppTextStyles.headlineMedium),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '순장으로 지정할 멤버를 선택해주세요.',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.divider, height: 1),
            if (members.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    '교회 멤버가 없어요.',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: members.length,
                  itemBuilder: (ctx, i) {
                    final uid = members[i];
                    final userAsync = ref.watch(userByIdProvider(uid));
                    final isSelected = uid == currentSelectedId;

                    final name = userAsync.valueOrNull?.name ?? uid;
                    final photoUrl = userAsync.valueOrNull?.profileImageUrl;
                    final user = userAsync.valueOrNull;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: ClayAvatar(imageUrl: photoUrl, size: AvatarSize.small),
                      title: Text(name, style: AppTextStyles.bodyMedium),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded, color: AppColors.warmTangerine)
                          : null,
                      onTap: user != null ? () => Navigator.pop(context, user) : null,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
