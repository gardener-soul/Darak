import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/church_member.dart';
import '../../../models/group.dart';
import '../../../repositories/church_member_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/church/church_community_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';
import '../../../widgets/common/core/clay_avatar.dart';
import '../../../widgets/common/core/soft_dialog.dart';
import '../../../widgets/common/soft_text_field.dart';

/// 교회 멤버 목록 실시간 스트림 Provider (MemberPickerBottomSheet 전용)
/// limit을 200으로 설정하여 대부분의 교회 규모를 커버합니다.
final churchMembersStreamProvider = StreamProvider.family<List<ChurchMember>, String>(
  (ref, churchId) => ref.watch(churchMemberRepositoryProvider).watchMembers(
        churchId: churchId,
        limit: 200,
      ),
);

/// 순원 추가 멤버 선택 바텀시트
/// 교회 전체 멤버 목록에서 다락방에 추가할 멤버를 선택합니다.
class MemberPickerBottomSheet extends ConsumerStatefulWidget {
  final String churchId;
  final Group group;

  const MemberPickerBottomSheet({
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
      child: MemberPickerBottomSheet(churchId: churchId, group: group),
    );
  }

  @override
  ConsumerState<MemberPickerBottomSheet> createState() =>
      _MemberPickerBottomSheetState();
}

class _MemberPickerBottomSheetState
    extends ConsumerState<MemberPickerBottomSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedUserId;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onMemberTap({
    required String userId,
    required String userName,
    required String? currentGroupId,
    required String? currentGroupName,
  }) async {
    // 이미 해당 다락방 소속: 선택 불가
    if (currentGroupId == widget.group.id) return;

    // 다른 다락방 소속: 이동 확인 다이얼로그
    if (currentGroupId != null) {
      final groupLabel = currentGroupName ?? '다른 다락방';
      final confirmed = await SoftDialog.show<bool>(
        context: context,
        title: '다락방 이동',
        content:
            '$userName님은 현재 $groupLabel에 소속되어 있습니다.\n${widget.group.name}으로 이동하시겠습니까?',
        actions: [
          SoftDialogAction(
            label: '취소',
            onPressed: () => Navigator.pop(context, false),
          ),
          SoftDialogAction(
            label: '이동',
            isDestructive: true,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );
      if (confirmed != true) return;
    }

    setState(() => _selectedUserId = userId);
  }

  Future<void> _submit() async {
    final userId = _selectedUserId;
    if (userId == null) return;

    setState(() => _isSubmitting = true);
    try {
      final member = await ref
          .read(churchMemberRepositoryProvider)
          .getMember(churchId: widget.churchId, userId: userId);

      if (member?.groupId != null && member!.groupId != widget.group.id) {
        // 다른 다락방에서 이동
        await ref
            .read(churchCommunityViewModelProvider(widget.churchId).notifier)
            .moveMemberBetweenGroups(
              churchId: widget.churchId,
              fromGroupId: member.groupId!,
              toGroupId: widget.group.id,
              toVillageId: widget.group.villageId ?? '',
              userId: userId,
            );
      } else {
        // 신규 추가
        await ref
            .read(churchCommunityViewModelProvider(widget.churchId).notifier)
            .addMemberToGroup(
              churchId: widget.churchId,
              groupId: widget.group.id,
              userId: userId,
            );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('순원이 추가되었어요!')),
      );
      Navigator.of(context).pop();
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
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(
      churchMembersStreamProvider(widget.churchId),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('순원 추가', style: AppTextStyles.headlineMedium),
        const SizedBox(height: 20),
        SoftTextField(
          controller: _searchController,
          hintText: '이름으로 검색',
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textGrey,
            size: 20,
          ),
          onChanged: (v) => setState(() => _searchQuery = v.trim()),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: membersAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.softCoral),
            ),
            error: (e, stack) => Center(
              child: Text(
                '멤버 목록을 불러오지 못했어요.',
                style: AppTextStyles.bodySmall,
              ),
            ),
            data: (members) {
              if (members.isEmpty) {
                return Center(
                  child: Text(
                    '교회 멤버가 없어요.',
                    style: AppTextStyles.bodySmall,
                  ),
                );
              }

              return ListView.builder(
                itemCount: members.length,
                itemBuilder: (ctx, i) {
                  final churchMember = members[i];
                  final uid = churchMember.userId;
                  final userAsync = ref.watch(userByIdProvider(uid));

                  return userAsync.when(
                    loading: () => const SizedBox(height: 60),
                    error: (e, stack) => const SizedBox.shrink(),
                    data: (user) {
                      // 이름 검색 필터링
                      final displayName = user?.name ?? uid;
                      if (_searchQuery.isNotEmpty &&
                          !displayName.contains(_searchQuery)) {
                        return const SizedBox.shrink();
                      }

                      final isCurrentGroup =
                          churchMember.groupId == widget.group.id;
                      final isSelected = _selectedUserId == uid;
                      final hasOtherGroup = churchMember.groupId != null &&
                          !isCurrentGroup;

                      return _MemberPickerItem(
                        userId: uid,
                        userName: displayName,
                        photoUrl: user?.profileImageUrl,
                        isCurrentGroup: isCurrentGroup,
                        isSelected: isSelected,
                        hasOtherGroup: hasOtherGroup,
                        onTap: isCurrentGroup
                            ? null
                            : () => _onMemberTap(
                                  userId: uid,
                                  userName: displayName,
                                  currentGroupId: churchMember.groupId,
                                  currentGroupName: null,
                                ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        BouncyButton(
          text: _isSubmitting ? '추가 중...' : '추가하기',
          onPressed: (_selectedUserId == null || _isSubmitting) ? null : _submit,
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _MemberPickerItem extends StatelessWidget {
  final String userId;
  final String userName;
  final String? photoUrl;
  final bool isCurrentGroup;
  final bool isSelected;
  final bool hasOtherGroup;
  final VoidCallback? onTap;

  const _MemberPickerItem({
    required this.userId,
    required this.userName,
    this.photoUrl,
    required this.isCurrentGroup,
    required this.isSelected,
    required this.hasOtherGroup,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color titleColor = AppColors.textDark;
    Widget? trailingWidget;
    Widget? subtitleWidget;

    if (isCurrentGroup) {
      bgColor = null;
      titleColor = AppColors.textGrey;
      trailingWidget = const Icon(
        Icons.check_rounded,
        color: AppColors.sageGreen,
        size: 18,
      );
      subtitleWidget = Text(
        '이미 이 다락방 소속',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey),
      );
    } else if (isSelected) {
      bgColor = AppColors.softCoral.withValues(alpha: 0.08);
      titleColor = AppColors.softCoral;
      trailingWidget = const Icon(
        Icons.check_circle_rounded,
        color: AppColors.softCoral,
        size: 22,
      );
    } else if (hasOtherGroup) {
      bgColor = AppColors.warmTangerine.withValues(alpha: 0.05);
      trailingWidget = const Icon(
        Icons.swap_horiz_rounded,
        color: AppColors.warmTangerine,
        size: 18,
      );
      subtitleWidget = Text(
        '다른 다락방 소속',
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.warmTangerine,
        ),
      );
    }

    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: isSelected ? BorderRadius.circular(16) : null,
      ),
      child: Row(
        children: [
          ClayAvatar(
            imageUrl: photoUrl,
            size: AvatarSize.small,
            borderColor: isCurrentGroup
                ? AppColors.disabled
                : isSelected
                    ? AppColors.softCoral
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName,
                  style: AppTextStyles.bodyMedium.copyWith(color: titleColor),
                ),
                if (subtitleWidget != null) subtitleWidget,
              ],
            ),
          ),
          if (trailingWidget != null) trailingWidget,
        ],
      ),
    );

    if (isCurrentGroup) {
      return Opacity(opacity: 0.5, child: content);
    }

    return BouncyTapWrapper(
      onTap: onTap ?? () {},
      child: content,
    );
  }
}
