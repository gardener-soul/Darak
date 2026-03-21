import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/user_providers.dart';
import '../../../models/attendance_status.dart';
import '../../../models/attendance_type.dart';
import '../../../models/group.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/attendance/attendance_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';
import '../../../widgets/common/core/clay_avatar.dart';
import '../../../widgets/common/core/soft_chip.dart';
import '../../../widgets/common/soft_text_field.dart';
import '../../../repositories/user_repository.dart';

/// 출석 체크 바텀시트 (순장 이상 권한)
/// - 날짜 선택 (7일 이내 제한)
/// - 예배 유형 칩 선택
/// - 멤버별 출석 상태 설정 (기본값: '출석')
/// - 사유결석 메모 입력 애니메이션
class AttendanceCheckBottomSheet extends ConsumerStatefulWidget {
  final Group group;
  final String churchId;

  const AttendanceCheckBottomSheet({
    super.key,
    required this.group,
    required this.churchId,
  });

  static Future<void> show(
    BuildContext context, {
    required Group group,
    required String churchId,
  }) {
    return AppBottomSheet.show(
      context: context,
      child: AttendanceCheckBottomSheet(group: group, churchId: churchId),
    );
  }

  @override
  ConsumerState<AttendanceCheckBottomSheet> createState() =>
      _AttendanceCheckBottomSheetState();
}

class _AttendanceCheckBottomSheetState
    extends ConsumerState<AttendanceCheckBottomSheet> {
  final Map<String, TextEditingController> _noteControllers = {};

  @override
  void initState() {
    super.initState();
    // QA-4 [WARNING]: Build 메서드 사이드 이펙트 방지를 위해 모든 컨트롤러 사전 초기화
    final memberIds = widget.group.memberIds ?? [];
    for (final uid in memberIds) {
      _noteControllers[uid] = TextEditingController();
    }

    // 멤버 초기화 (기존 기록 로드 포함)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(attendanceCheckViewModelProvider.notifier)
          .initMembers(
            groupId: widget.group.id,
            memberIds: memberIds,
          );
    });
  }

  @override
  void dispose() {
    for (final c in _noteControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _onDateChanged(DateTime date) async {
    await ref.read(attendanceCheckViewModelProvider.notifier).changeDate(
          date: date,
          groupId: widget.group.id,
          memberIds: widget.group.memberIds ?? [],
        );
  }

  Future<void> _onTypeChanged(AttendanceType type) async {
    await ref.read(attendanceCheckViewModelProvider.notifier).changeType(
          type: type,
          groupId: widget.group.id,
          memberIds: widget.group.memberIds ?? [],
        );
  }

  Future<void> _onSave() async {
    final currentUserId = ref.read(currentUserIdProvider);
    if (currentUserId == null) return;

    // 메모 컨트롤러에서 note 값 동기화
    for (final entry in _noteControllers.entries) {
      final note = entry.value.text.trim().isEmpty ? null : entry.value.text.trim();
      ref
          .read(attendanceCheckViewModelProvider.notifier)
          .updateMemberNote(entry.key, note);
    }

    final success = await ref
        .read(attendanceCheckViewModelProvider.notifier)
        .saveAttendance(
          groupId: widget.group.id,
          checkedById: currentUserId,
        );

    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ 출석이 저장되었어요!'),
          backgroundColor: AttendanceColors.present,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      final errorMsg = ref.read(attendanceCheckViewModelProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg ?? '출석 저장에 실패했습니다.'),
          backgroundColor: AttendanceColors.absent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(attendanceCheckViewModelProvider);
    final memberIds = widget.group.memberIds ?? [];

    // 빌드 페이즈 외부에서 상태 동기화 (기존 메모 채워넣기)
    ref.listen(attendanceCheckViewModelProvider, (prev, next) {
      if (prev?.isLoading == true && next.isLoading == false) {
        for (final entry in next.memberNotes.entries) {
          final uid = entry.key;
          final note = entry.value;
          final controller = _noteControllers[uid];
          // 컨트롤러가 비어있고, 불러온 내용이 존재하면 덮어쓰기
          if (controller != null && note != null && note.isNotEmpty && controller.text.isEmpty) {
            controller.text = note;
          }
        }
      }
    });

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── 헤더 ────────────────────────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AttendanceColors.present.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AttendanceColors.present,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Text('출석 체크', style: AppTextStyles.headlineMedium),
            ],
          ),
          const SizedBox(height: 20),

          // ── 날짜 선택 (7일 이내 제한) ──────────────────────────
          _DatePickerField(
            selectedDate: state.selectedDate,
            onDateChanged: _onDateChanged,
          ),
          const SizedBox(height: 12),

          // ── 예배 유형 칩 (Wrap으로 줄바꿈 대응) ─────────────────
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SoftChip(
                label: '주일예배',
                icon: Icons.church_rounded,
                color: AppColors.softCoral,
                isSelected: state.selectedType == AttendanceType.onlySundayService,
                onTap: () => _onTypeChanged(AttendanceType.onlySundayService),
              ),
              SoftChip(
                label: '다락방',
                icon: Icons.home_rounded,
                color: AppColors.sageGreen,
                isSelected: state.selectedType == AttendanceType.onlyDarak,
                onTap: () => _onTypeChanged(AttendanceType.onlyDarak),
              ),
              SoftChip(
                label: '예배+다락방',
                icon: Icons.layers_rounded,
                color: AppColors.warmTangerine,
                isSelected: state.selectedType == AttendanceType.both,
                onTap: () => _onTypeChanged(AttendanceType.both),
              ),
              SoftChip(
                label: '특별집회',
                icon: Icons.celebration_rounded,
                color: AppColors.softLavender,
                isSelected: state.selectedType == AttendanceType.specialEvent,
                onTap: () => _onTypeChanged(AttendanceType.specialEvent),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 8),

          // ── 로딩 또는 멤버 목록 ──────────────────────────────────
          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: CircularProgressIndicator(color: AttendanceColors.present),
              ),
            )
          else if (memberIds.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  '다락방에 순원이 없어요.\n먼저 순원을 추가해주세요.',
                  style: AppTextStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: memberIds.length,
              itemBuilder: (ctx, i) {
                final uid = memberIds[i];
                final status = state.memberStatuses[uid] ?? AttendanceStatus.present;
                final noteController = _noteControllers[uid] ?? TextEditingController();
                
                return _MemberAttendanceItem(
                  uid: uid,
                  status: status,
                  noteController: noteController,
                  onStatusChanged: (s) => ref
                      .read(attendanceCheckViewModelProvider.notifier)
                      .updateMemberStatus(uid, s),
                );
              },
            ),

          // ── 에러 메시지 ─────────────────────────────────────────
          if (state.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                state.errorMessage!,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AttendanceColors.absent),
              ),
            ),

          const SizedBox(height: 16),

          // ── 저장 버튼 ────────────────────────────────────────────
          BouncyButton(
            text: state.isLoading ? '저장 중...' : '저장하기',
            color: AttendanceColors.present,
            onPressed: (state.isLoading || memberIds.isEmpty) ? null : _onSave,
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// 날짜 선택 필드
// ───────────────────────────────────────────────────────────────────────────────

class _DatePickerField extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const _DatePickerField({
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy.MM.dd (E)', 'ko');

    return BouncyTapWrapper(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          // 순장은 7일 이내만 수정 가능 (정책 강제)
          firstDate: DateTime.now().subtract(const Duration(days: 7)),
          lastDate: DateTime.now(),
          locale: const Locale('ko'),
        );
        if (date != null) {
          onDateChanged(date);
        }
      },
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: AppDecorations.defaultRadius,
          boxShadow: AppDecorations.innerInputShadow,
          border: Border.all(color: AttendanceColors.present, width: 2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              color: AttendanceColors.present,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              formatter.format(selectedDate),
              style: AppTextStyles.bodyMedium,
            ),
            const Spacer(),
            const Icon(
              Icons.edit_calendar_rounded,
              color: AppColors.textGrey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// 멤버별 출석 상태 행
// ───────────────────────────────────────────────────────────────────────────────

class _MemberAttendanceItem extends ConsumerWidget {
  final String uid;
  final AttendanceStatus status;
  final TextEditingController noteController;
  final ValueChanged<AttendanceStatus> onStatusChanged;

  const _MemberAttendanceItem({
    required this.uid,
    required this.status,
    required this.noteController,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userByIdProvider(uid));
    final name = userAsync.valueOrNull?.name ?? '...';
    final photoUrl = userAsync.valueOrNull?.profileImageUrl;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClayAvatar(imageUrl: photoUrl, size: AvatarSize.small),
              const SizedBox(width: 12),
              Expanded(
                child: Text(name, style: AppTextStyles.bodyMedium),
              ),
              _StatusButtonGroup(
                selected: status,
                onChanged: onStatusChanged,
              ),
            ],
          ),
          // 사유결석 메모 입력 (AnimatedSize + AnimatedOpacity)
          _ExcusedNoteField(
            visible: status == AttendanceStatus.excused,
            controller: noteController,
          ),
          const SizedBox(height: 4),
          const Divider(color: AppColors.divider, height: 1),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// 출석 상태 버튼 그룹
// ───────────────────────────────────────────────────────────────────────────────

class _StatusButtonGroup extends StatelessWidget {
  final AttendanceStatus selected;
  final ValueChanged<AttendanceStatus> onChanged;

  const _StatusButtonGroup({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // QA-5 [WARNING]: 좁은 기기에서 오버플로우를 막기 위해 Row 대신 Wrap 사용
    return Wrap(
      spacing: 0,
      runSpacing: 4,
      children: AttendanceStatus.values
          .where((s) => s != AttendanceStatus.etc) // 'etc'는 UI에서 제외
          .map((s) => _StatusBtn(
                status: s,
                isSelected: selected == s,
                onTap: () => onChanged(s),
              ))
          .toList(),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// 개별 상태 버튼 (클레이모피즘 입체감)
// ───────────────────────────────────────────────────────────────────────────────

class _StatusBtn extends StatelessWidget {
  final AttendanceStatus status;
  final bool isSelected;
  final VoidCallback onTap;

  static const _labels = {
    AttendanceStatus.present: '출석',
    AttendanceStatus.late: '지각',
    AttendanceStatus.absent: '결석',
    AttendanceStatus.excused: '사유',
  };

  static const _icons = {
    AttendanceStatus.present: Icons.check_circle_rounded,
    AttendanceStatus.late: Icons.schedule_rounded,
    AttendanceStatus.absent: Icons.cancel_rounded,
    AttendanceStatus.excused: Icons.help_rounded,
  };

  static const _colors = {
    AttendanceStatus.present: AttendanceColors.present,
    AttendanceStatus.late: AttendanceColors.late,
    AttendanceStatus.absent: AttendanceColors.absent,
    AttendanceStatus.excused: AttendanceColors.excused,
  };

  static const _shadowColors = {
    AttendanceStatus.present: AttendanceColors.presentShadow,
    AttendanceStatus.late: AttendanceColors.lateShadow,
    AttendanceStatus.absent: AttendanceColors.absentShadow,
    AttendanceStatus.excused: AttendanceColors.excusedShadow,
  };

  const _StatusBtn({
    required this.status,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _colors[status]!;
    final shadowColor = _shadowColors[status]!;
    final label = _labels[status];
    final icon = _icons[status];

    return BouncyTapWrapper(
      onTap: onTap,
      child: Container(
        // 최소 터치 영역 48×48 dp 보장
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          // 선택 시 하단 솔리드 그림자 → 클레이모피즘 입체감
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: shadowColor,
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? color : AppColors.textGrey,
              size: 18,
            ),
            const SizedBox(height: 2),
            Text(
              label ?? '',
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? color : AppColors.textGrey,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────────────────────────
// 사유결석 메모 입력 (AnimatedSize + AnimatedOpacity)
// ───────────────────────────────────────────────────────────────────────────────

class _ExcusedNoteField extends StatelessWidget {
  final bool visible;
  final TextEditingController controller;

  const _ExcusedNoteField({
    required this.visible,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: visible ? 1.0 : 0.0,
        child: visible
            ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SoftTextField(
                  controller: controller,
                  hintText: '사유를 입력해주세요 (선택)',
                  maxLines: 2,
                  minLines: 1,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
