import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/village_with_groups.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/church/church_community_viewmodel.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';
import '../../../widgets/common/core/soft_dialog.dart';

/// 관리자 전용: 구성원 탭에서 멤버를 특정 다락방에 배정하는 바텀시트.
/// 마을 > 다락방 트리를 펼쳐 보여주고, 선택 시 addMemberToGroup 또는
/// moveMemberBetweenGroups를 호출합니다.
class GroupAssignBottomSheet extends ConsumerStatefulWidget {
  final String churchId;
  final String userId;
  final String userName;
  final String? currentGroupId;

  const GroupAssignBottomSheet({
    super.key,
    required this.churchId,
    required this.userId,
    required this.userName,
    this.currentGroupId,
  });

  static Future<void> show(
    BuildContext context, {
    required String churchId,
    required String userId,
    required String userName,
    String? currentGroupId,
  }) {
    return AppBottomSheet.show(
      context: context,
      child: GroupAssignBottomSheet(
        churchId: churchId,
        userId: userId,
        userName: userName,
        currentGroupId: currentGroupId,
      ),
    );
  }

  @override
  ConsumerState<GroupAssignBottomSheet> createState() =>
      _GroupAssignBottomSheetState();
}

class _GroupAssignBottomSheetState
    extends ConsumerState<GroupAssignBottomSheet> {
  bool _isSubmitting = false;

  Future<void> _onGroupTap(VillageWithGroups villageWithGroup, String groupId, String groupName) async {
    // 이미 해당 다락방에 소속되어 있으면 무시
    if (groupId == widget.currentGroupId) return;

    // 다른 다락방에서 이동하는 경우 확인 다이얼로그
    if (widget.currentGroupId != null) {
      final confirmed = await SoftDialog.show<bool>(
        context: context,
        title: '다락방 이동',
        content:
            '${widget.userName}님을 현재 다락방에서\n\'$groupName\'으로 이동하시겠습니까?',
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
      if (confirmed != true || !mounted) return;
    }

    setState(() => _isSubmitting = true);
    try {
      final vm = ref.read(
        churchCommunityViewModelProvider(widget.churchId).notifier,
      );

      if (widget.currentGroupId != null) {
        await vm.moveMemberBetweenGroups(
          churchId: widget.churchId,
          fromGroupId: widget.currentGroupId!,
          toGroupId: groupId,
          toVillageId: villageWithGroup.village.id,
          userId: widget.userId,
        );
      } else {
        await vm.addMemberToGroup(
          churchId: widget.churchId,
          groupId: groupId,
          userId: widget.userId,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.userName}님이 \'$groupName\'에 배정되었어요!')),
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
    final communityAsync =
        ref.watch(churchCommunityViewModelProvider(widget.churchId));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 헤더 ─────────────────────────────────────────────────
        Row(
          children: [
            const Icon(Icons.door_back_door_rounded,
                color: AppColors.softCoral, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${widget.userName}님 다락방 배정',
                style: AppTextStyles.headlineMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '배정할 다락방을 선택해주세요.',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGrey),
        ),
        const SizedBox(height: 16),
        const Divider(color: AppColors.divider, height: 1),
        const SizedBox(height: 8),

        // ── 그룹 목록 ─────────────────────────────────────────────
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 360),
          child: communityAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(color: AppColors.softCoral),
              ),
            ),
            error: (_, _) => Center(
              child: Text('다락방 목록을 불러오지 못했어요.',
                  style: AppTextStyles.bodySmall),
            ),
            data: (villages) {
              if (villages.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('생성된 다락방이 없습니다.',
                        style: AppTextStyles.bodySmall),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: villages.length,
                itemBuilder: (ctx, vi) {
                  final vwg = villages[vi];
                  if (vwg.groups.isEmpty) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 마을 헤더
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                        child: Row(
                          children: [
                            const Icon(Icons.location_city_rounded,
                                size: 14, color: AppColors.textGrey),
                            const SizedBox(width: 6),
                            Text(
                              vwg.village.name,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 다락방 목록
                      ...vwg.groups.map((group) {
                        final isCurrent = group.id == widget.currentGroupId;
                        return _GroupItem(
                          groupName: group.name,
                          isCurrent: isCurrent,
                          isSubmitting: _isSubmitting,
                          onTap: (isCurrent || _isSubmitting)
                              ? null
                              : () => _onGroupTap(vwg, group.id, group.name),
                        );
                      }),
                    ],
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _GroupItem extends StatelessWidget {
  final String groupName;
  final bool isCurrent;
  final bool isSubmitting;
  final VoidCallback? onTap;

  const _GroupItem({
    required this.groupName,
    required this.isCurrent,
    required this.isSubmitting,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isCurrent
            ? AppColors.sageGreen.withValues(alpha: 0.08)
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.groups_rounded, size: 18, color: AppColors.textGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              groupName,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isCurrent ? AppColors.sageGreen : AppColors.textDark,
              ),
            ),
          ),
          if (isCurrent)
            const Icon(Icons.check_rounded,
                size: 18, color: AppColors.sageGreen)
          else if (isSubmitting)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppColors.softCoral),
            ),
        ],
      ),
    );

    if (isCurrent || onTap == null) {
      return Opacity(opacity: isCurrent ? 0.6 : 1.0, child: content);
    }

    return BouncyTapWrapper(onTap: onTap!, child: content);
  }
}
