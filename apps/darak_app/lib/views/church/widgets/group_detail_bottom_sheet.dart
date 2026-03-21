import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/attendance_status.dart';
import '../../../models/church_member.dart';
import '../../../models/group.dart';
import '../../../repositories/user_repository.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/attendance/attendance_viewmodel.dart';
import '../../../viewmodels/church/church_community_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';
import '../../../widgets/common/core/bouncy_icon_btn.dart';
import '../../../widgets/common/core/clay_avatar.dart';
import '../../../widgets/common/core/soft_dialog.dart';
import 'attendance_check_bottom_sheet.dart';
import 'attendance_history_sheet.dart';
import 'group_edit_bottom_sheet.dart';
import 'member_picker_bottom_sheet.dart';

/// 다락방 상세 바텀시트
/// 다락방 이름 + 순장 정보 + 멤버 목록 + 수정/삭제 + 순원 추가/제거
class GroupDetailBottomSheet extends ConsumerStatefulWidget {
  final Group group;
  final String churchId;
  final bool isAdmin;
  final bool isLeader;
  final ChurchMember? currentMember;

  const GroupDetailBottomSheet({
    super.key,
    required this.group,
    required this.churchId,
    required this.isAdmin,
    required this.isLeader,
    this.currentMember,
  });

  static Future<void> show(
    BuildContext context, {
    required Group group,
    required String churchId,
    required bool isAdmin,
    required bool isLeader,
    ChurchMember? currentMember,
  }) {
    return AppBottomSheet.show(
      context: context,
      child: GroupDetailBottomSheet(
        group: group,
        churchId: churchId,
        isAdmin: isAdmin,
        isLeader: isLeader,
        currentMember: currentMember,
      ),
    );
  }

  @override
  ConsumerState<GroupDetailBottomSheet> createState() =>
      _GroupDetailBottomSheetState();
}

class _GroupDetailBottomSheetState
    extends ConsumerState<GroupDetailBottomSheet> {
  bool _isDeletingGroup = false;
  bool _isUpdatingLeader = false;

  Future<void> _onEditTap() async {
    if (!mounted) return;
    Navigator.of(context).pop();
    await GroupEditBottomSheet.show(
      context,
      churchId: widget.churchId,
      group: widget.group,
    );
  }

  Future<void> _onDeleteGroupTap() async {
    final confirmed = await SoftDialog.show<bool>(
      context: context,
      title: '다락방 삭제',
      content: '다락방을 삭제하면 소속 순원들의 다락방 소속이 해제됩니다.\n정말 삭제하시겠어요?',
      actions: [
        SoftDialogAction(
          label: '취소',
          onPressed: () => Navigator.pop(context, false),
        ),
        SoftDialogAction(
          label: '삭제',
          isDestructive: true,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );

    if (confirmed != true || !mounted) return;
    setState(() => _isDeletingGroup = true);
    try {
      await ref
          .read(churchCommunityViewModelProvider(widget.churchId).notifier)
          .deleteGroup(
            churchId: widget.churchId,
            groupId: widget.group.id,
            memberIds: widget.group.memberIds ?? [],
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('다락방이 삭제되었어요.')),
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
      if (mounted) setState(() => _isDeletingGroup = false);
    }
  }

  Future<void> _onAddMemberTap() async {
    if (!mounted) return;
    Navigator.of(context).pop();
    await MemberPickerBottomSheet.show(
      context,
      churchId: widget.churchId,
      group: widget.group,
    );
  }

  /// 순장 선택: MemberPickerBottomSheet를 단일 선택 모드로 재활용하거나
  /// 현재 순원 목록 중에서 선택하는 다이얼로그를 표시합니다.
  Future<void> _onLeaderEditTap() async {
    final memberIds = widget.group.memberIds ?? [];
    if (memberIds.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('다락방에 순원을 먼저 추가한 후 순장을 지정해주세요.')),
      );
      return;
    }

    // 순원 목록 중 한 명을 선택하는 BottomSheet (shimple list)
    if (!mounted) return;
    final selectedUserId = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: AppColors.creamWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) => _LeaderPickerSheet(
        churchId: widget.churchId,
        group: widget.group,
        currentLeaderId: widget.group.leaderId,
      ),
    );

    // null: 취소, 'remove': 순장 해제, 기타: userId 선택
    if (selectedUserId == null || !mounted) return;

    setState(() => _isUpdatingLeader = true);
    try {
      final newLeaderId = selectedUserId == 'remove' ? null : selectedUserId;
      await ref
          .read(churchCommunityViewModelProvider(widget.churchId).notifier)
          .updateGroupLeader(
            groupId: widget.group.id,
            leaderId: newLeaderId,
          );
      if (!mounted) return;
      final msg = newLeaderId == null ? '순장이 해제되었어요.' : '순장이 변경되었어요.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll(RegExp(r'^Exception:\s*'), '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _isUpdatingLeader = false);
    }
  }

  Future<void> _onRemoveMemberTap(String userId, String userName) async {
    // 순장은 제거 불가
    if (userId == widget.group.leaderId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('순장은 제거할 수 없습니다. 순장 변경 후 시도해주세요.'),
        ),
      );
      return;
    }

    final confirmed = await SoftDialog.show<bool>(
      context: context,
      title: '순원 제거',
      content: '정말 $userName님을 다락방에서 제거하시겠어요?',
      actions: [
        SoftDialogAction(
          label: '취소',
          onPressed: () => Navigator.pop(context, false),
        ),
        SoftDialogAction(
          label: '제거',
          isDestructive: true,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );

    if (confirmed != true || !mounted) return;
    try {
      await ref
          .read(churchCommunityViewModelProvider(widget.churchId).notifier)
          .removeMemberFromGroup(
            churchId: widget.churchId,
            groupId: widget.group.id,
            userId: userId,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$userName님이 다락방에서 제거되었어요.')),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final memberIds = widget.group.memberIds ?? [];
    final canManage = widget.isAdmin || widget.isLeader;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── 헤더 행 ──────────────────────────────────────────────
        _HeaderRow(
          groupName: widget.group.name,
          canManage: canManage,
          isAdmin: widget.isAdmin,
          isDeletingGroup: _isDeletingGroup,
          onEditTap: _onEditTap,
          onDeleteTap: _onDeleteGroupTap,
        ),
        const SizedBox(height: 20),

        // ── 순장 정보 ─────────────────────────────────────────────
        _GroupLeaderInfo(
          leaderId: widget.group.leaderId,
          canManage: canManage,
          isUpdatingLeader: _isUpdatingLeader,
          onEditTap: _onLeaderEditTap,
        ),
        const SizedBox(height: 16),

        // ── 멤버 수 + 출석 체크 버튼 ─────────────────────────────
        _MemberCountRow(
          memberCount: memberIds.length,
          canManage: canManage,
          onAttendanceTap: () => AttendanceCheckBottomSheet.show(
            context,
            group: widget.group,
            churchId: widget.churchId,
          ),
        ),
        const SizedBox(height: 20),

        const Divider(color: AppColors.divider, height: 1),
        const SizedBox(height: 16),

        // ── 멤버 목록 섹션 헤더 ────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('순원 목록', style: AppTextStyles.bodyLarge),
            if (canManage)
              BouncyButton(
                text: '+ 순원 추가',
                isFullWidth: false,
                onPressed: _onAddMemberTap,
              ),
          ],
        ),
        const SizedBox(height: 12),

        // ── 멤버 목록 ─────────────────────────────────────────────
        if (memberIds.isEmpty)
          const _EmptyMemberState()
        else
          _MemberList(
            churchId: widget.churchId,
            group: widget.group,
            canManage: canManage,
            onRemoveMember: _onRemoveMemberTap,
          ),

        const SizedBox(height: 8),

        // ── 최근 출석 요약 카드 ─────────────────────────────────────
        const Divider(color: AppColors.divider, height: 1),
        const SizedBox(height: 12),
        _RecentAttendanceSummaryCard(
          groupId: widget.group.id,
          onHistoryTap: () => AttendanceHistorySheet.show(
            context,
            groupId: widget.group.id,
            churchId: widget.churchId,
            groupName: widget.group.name,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _HeaderRow extends StatelessWidget {
  final String groupName;
  final bool canManage;
  final bool isAdmin;
  final bool isDeletingGroup;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const _HeaderRow({
    required this.groupName,
    required this.canManage,
    required this.isAdmin,
    required this.isDeletingGroup,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(groupName, style: AppTextStyles.headlineMedium),
        ),
        if (canManage) ...[
          BouncyIconBtn(
            icon: Icons.edit_rounded,
            color: AppColors.warmTangerine,
            size: IconBtnSize.small,
            onTap: onEditTap,
          ),
          const SizedBox(width: 4),
        ],
        if (isAdmin)
          BouncyIconBtn(
            icon: Icons.delete_rounded,
            color: AppColors.softCoral,
            size: IconBtnSize.small,
            onTap: isDeletingGroup ? null : onDeleteTap,
          ),
      ],
    );
  }
}

class _GroupLeaderInfo extends ConsumerWidget {
  final String? leaderId;
  final bool canManage;
  final bool isUpdatingLeader;
  final VoidCallback onEditTap;

  const _GroupLeaderInfo({
    required this.leaderId,
    required this.canManage,
    required this.isUpdatingLeader,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // leaderId가 있으면 실제 이름 조회
    final leaderAsync = leaderId != null
        ? ref.watch(userByIdProvider(leaderId!))
        : null;
    final leaderName = leaderAsync?.valueOrNull?.name;

    final displayText = leaderId == null
        ? '순장 없음'
        : (leaderName ?? '조회 중...');
    final displayColor = leaderId == null ? AppColors.textGrey : AppColors.textDark;

    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 18, color: AppColors.warmTangerine),
        const SizedBox(width: 8),
        Text('순장', style: AppTextStyles.bodySmall),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            displayText,
            style: AppTextStyles.bodyMedium.copyWith(color: displayColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (canManage)
          isUpdatingLeader
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.warmTangerine,
                  ),
                )
              : BouncyIconBtn(
                  icon: leaderId == null
                      ? Icons.person_add_rounded
                      : Icons.edit_rounded,
                  color: AppColors.warmTangerine,
                  size: IconBtnSize.small,
                  onTap: onEditTap,
                ),
      ],
    );
  }
}

class _MemberCountRow extends StatelessWidget {
  final int memberCount;
  final bool canManage;
  final VoidCallback onAttendanceTap;

  const _MemberCountRow({
    required this.memberCount,
    required this.canManage,
    required this.onAttendanceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.people_rounded, size: 18, color: AppColors.sageGreen),
        const SizedBox(width: 8),
        Text('멤버', style: AppTextStyles.bodySmall),
        const SizedBox(width: 8),
        Text('$memberCount명', style: AppTextStyles.bodyMedium),
        const Spacer(),
        if (canManage)
          BouncyButton(
            text: '출석 체크',
            icon: const Icon(Icons.check_rounded, size: 16, color: Colors.white),
            color: AttendanceColors.present,
            isFullWidth: false,
            onPressed: onAttendanceTap,
          ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 최근 출석 요약 카드
// ──────────────────────────────────────────────────────────────────────────────

class _RecentAttendanceSummaryCard extends ConsumerWidget {
  final String groupId;
  final VoidCallback onHistoryTap;

  const _RecentAttendanceSummaryCard({
    required this.groupId,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendancesAsync = ref.watch(recentGroupAttendancesProvider(groupId));

    return ClayCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('최근 출석', style: AppTextStyles.bodySmall),
                const SizedBox(height: 8),
                attendancesAsync.when(
                  loading: () => const SizedBox(
                    height: 20,
                    child: Center(
                      child: LinearProgressIndicator(
                        color: AttendanceColors.present,
                      ),
                    ),
                  ),
                  error: (_, __) => Text(
                    '출석 기록을 불러오지 못했어요.',
                    style: AppTextStyles.bodySmall,
                  ),
                  data: (attendances) {
                    if (attendances.isEmpty) {
                      return Text(
                        '아직 출석 기록이 없어요.',
                        style: AppTextStyles.bodySmall,
                      );
                    }
                    // 가장 최근 날짜의 기록만 집계
                    final latestDate = attendances
                        .map((a) => DateTime(a.date.year, a.date.month, a.date.day))
                        .reduce((a, b) => a.isAfter(b) ? a : b);
                    final latestRecords = attendances
                        .where((a) =>
                            DateTime(a.date.year, a.date.month, a.date.day) ==
                            latestDate)
                        .toList();

                    var present = 0, absent = 0, late = 0;
                    for (final a in latestRecords) {
                      switch (a.status) {
                        case AttendanceStatus.present: present++; break;
                        case AttendanceStatus.absent:  absent++;  break;
                        case AttendanceStatus.late:    late++;    break;
                        default: break;
                      }
                    }

                    return Row(
                      children: [
                        _StatusBadgeSmall(
                          label: '출석',
                          count: present,
                          color: AttendanceColors.present,
                        ),
                        const SizedBox(width: 6),
                        _StatusBadgeSmall(
                          label: '결석',
                          count: absent,
                          color: AttendanceColors.absent,
                        ),
                        const SizedBox(width: 6),
                        _StatusBadgeSmall(
                          label: '지각',
                          count: late,
                          color: AttendanceColors.late,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          BouncyTapWrapper(
            onTap: onHistoryTap,
            child: Text(
              '기록 보기 →',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.softCoral,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadgeSmall extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatusBadgeSmall({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        '$label $count',
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _EmptyMemberState extends StatelessWidget {
  const _EmptyMemberState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.people_outline_rounded,
              size: 48,
              color: AppColors.disabled,
            ),
            const SizedBox(height: 12),
            Text(
              '아직 순원이 없어요.\n멤버를 추가해보세요!',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberList extends ConsumerWidget {
  final String churchId;
  final Group group;
  final bool canManage;
  final Future<void> Function(String userId, String userName) onRemoveMember;

  const _MemberList({
    required this.churchId,
    required this.group,
    required this.canManage,
    required this.onRemoveMember,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberIds = group.memberIds ?? [];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: memberIds.length,
      separatorBuilder: (context, index) => const Divider(
        color: AppColors.divider,
        height: 1,
        indent: 56,
      ),
      itemBuilder: (ctx, i) {
        final uid = memberIds[i];
        final userAsync = ref.watch(userByIdProvider(uid));
        final isLeader = uid == group.leaderId;

        return userAsync.when(
          loading: () => const SizedBox(
            height: 56,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.softCoral,
                strokeWidth: 2,
              ),
            ),
          ),
          error: (error, stack) => _MemberItem(
            uid: uid,
            name: uid,
            photoUrl: null,
            isLeader: isLeader,
            canManage: canManage,
            onRemove: () => onRemoveMember(uid, uid),
          ),
          data: (user) => _MemberItem(
            uid: uid,
            name: user?.name ?? uid,
            photoUrl: user?.profileImageUrl,
            isLeader: isLeader,
            canManage: canManage,
            onRemove: () => onRemoveMember(uid, user?.name ?? uid),
          ),
        );
      },
    );
  }
}

class _MemberItem extends StatelessWidget {
  final String uid;
  final String name;
  final String? photoUrl;
  final bool isLeader;
  final bool canManage;
  final VoidCallback onRemove;

  const _MemberItem({
    required this.uid,
    required this.name,
    required this.photoUrl,
    required this.isLeader,
    required this.canManage,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          ClayAvatar(imageUrl: photoUrl, size: AvatarSize.small),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name, style: AppTextStyles.bodyMedium),
          ),
          if (isLeader)
            const Icon(
              Icons.star_rounded,
              color: AppColors.warmTangerine,
              size: 18,
            )
          else if (canManage)
            // W-6: 이중 탭 이벤트 제거 - BouncyTapWrapper 제거, BouncyIconBtn만 사용
            BouncyIconBtn(
              icon: Icons.remove_circle_outline_rounded,
              color: AppColors.softCoral,
              size: IconBtnSize.small,
              onTap: onRemove,
            ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// 순장 선택 바텀시트
// ──────────────────────────────────────────────────────────────────────────────

/// 다락방 순원 목록 중에서 순장을 선택하는 바텀시트.
/// - 반환값: 선택한 userId (String) | 'remove' (순장 해제) | null (취소)
class _LeaderPickerSheet extends ConsumerWidget {
  final String churchId;
  final Group group;
  final String? currentLeaderId;

  const _LeaderPickerSheet({
    required this.churchId,
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
            // 헤더
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.warmTangerine, size: 20),
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
            // 순원 목록
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
                    leading: ClayAvatar(imageUrl: photoUrl, size: AvatarSize.small),
                    title: Text(name, style: AppTextStyles.bodyMedium),
                    trailing: isCurrentLeader
                        ? const Icon(Icons.star_rounded, color: AppColors.warmTangerine, size: 18)
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
                icon: const Icon(Icons.person_remove_rounded, color: AppColors.softCoral, size: 18),
                label: Text(
                  '순장 해제',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.softCoral),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
