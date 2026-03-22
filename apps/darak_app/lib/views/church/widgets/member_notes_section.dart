import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/member_note.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/member/member_detail_viewmodel.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/empty_state_view.dart';
import '../../../widgets/common/skeleton_card.dart';
import 'member_note_input_sheet.dart';

/// 순원 상세 화면 - 비공개 메모 섹션 (순장 이상 권한자에게만 노출)
class MemberNotesSection extends ConsumerWidget {
  final String targetUserId;
  final String currentUserId;
  final AsyncValue<List<MemberNote>> notesAsync;

  const MemberNotesSection({
    super.key,
    required this.targetUserId,
    required this.currentUserId,
    required this.notesAsync,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더 + 추가 버튼
        Row(
          children: [
            const Icon(
              Icons.lock_rounded,
              color: AppColors.softLavender,
              size: 22,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('비공개 메모', style: AppTextStyles.bodyLarge),
            ),
            _AddNoteButton(
              targetUserId: targetUserId,
              currentUserId: currentUserId,
            ),
          ],
        ),
        const SizedBox(height: 12),

        notesAsync.when(
          loading: () => const _NotesLoadingSkeleton(),
          error: (err, st) => ClayCard(
            padding: const EdgeInsets.all(20),
            child: const EmptyStateView(
              icon: Icons.error_outline_rounded,
              message: '메모를 불러오지 못했어요',
            ),
          ),
          data: (notes) {
            if (notes.isEmpty) {
              return ClayCard(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                child: EmptyStateView(
                  icon: Icons.sticky_note_2_rounded,
                  message: '아직 작성된 메모가 없어요',
                  iconColor: AppColors.disabled,
                ),
              );
            }
            return Column(
              children: notes
                  .map((note) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _NoteCard(
                          note: note,
                          targetUserId: targetUserId,
                          currentUserId: currentUserId,
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// 메모 추가 버튼
// ─────────────────────────────────────────────

class _AddNoteButton extends StatelessWidget {
  final String targetUserId;
  final String currentUserId;

  const _AddNoteButton({
    required this.targetUserId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _showInputSheet(context),
      icon: const Icon(Icons.add_rounded, size: 18),
      label: const Text('추가'),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.softLavender,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        textStyle: AppTextStyles.bodySmall,
      ),
    );
  }

  void _showInputSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MemberNoteInputSheet(
        targetUserId: targetUserId,
        currentUserId: currentUserId,
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 메모 카드
// ─────────────────────────────────────────────

class _NoteCard extends ConsumerWidget {
  final MemberNote note;
  final String targetUserId;
  final String currentUserId;

  const _NoteCard({
    required this.note,
    required this.targetUserId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = note.updatedAt ?? note.createdAt;
    final dateLabel = date != null ? DateFormat('yyyy.MM.dd').format(date) : '-';

    return ClayCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 본문
          Text(note.content, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 8),
          // 하단: 날짜 + 편집 버튼
          Row(
            children: [
              const Icon(
                Icons.lock_rounded,
                size: 12,
                color: AppColors.textGrey,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  dateLabel,
                  style: AppTextStyles.bodySmall,
                ),
              ),
              _NoteActionMenu(
                note: note,
                targetUserId: targetUserId,
                currentUserId: currentUserId,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 메모 액션 메뉴 (수정 / 삭제)
// ─────────────────────────────────────────────

class _NoteActionMenu extends ConsumerWidget {
  final MemberNote note;
  final String targetUserId;
  final String currentUserId;

  const _NoteActionMenu({
    required this.note,
    required this.targetUserId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_NoteAction>(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_horiz_rounded, size: 18, color: AppColors.textGrey),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (action) {
        switch (action) {
          case _NoteAction.edit:
            _showEditSheet(context);
            break;
          case _NoteAction.delete:
            _confirmDelete(context, ref);
            break;
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: _NoteAction.edit,
          child: Row(
            children: [
              Icon(Icons.edit_rounded, size: 16, color: AppColors.textDark),
              SizedBox(width: 8),
              Text('수정'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: _NoteAction.delete,
          child: Row(
            children: [
              Icon(Icons.delete_rounded, size: 16, color: AppColors.softCoral),
              SizedBox(width: 8),
              Text('삭제', style: TextStyle(color: AppColors.softCoral)),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MemberNoteInputSheet(
        targetUserId: targetUserId,
        currentUserId: currentUserId,
        noteId: note.id,
        initialContent: note.content,
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('메모 삭제'),
        content: const Text('이 메모를 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('취소'),
          ),
          BouncyButton(
            text: '삭제',
            color: AppColors.softCoral,
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                // ViewModel의 deleteNote 호출은 MemberNotesSection 상위에서
                // memberDetailViewModelProvider를 직접 읽어야 합니다.
                // 여기서는 ref를 통해 접근합니다.
                final notifier = ref.read(
                  // ignore: undefined_identifier — build_runner 실행 후 생성됨
                  memberDetailViewModelProvider(targetUserId).notifier,
                );
                await notifier.deleteNote(noteId: note.id);
              } catch (_) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('메모 삭제에 실패했어요'),
                    backgroundColor: AppColors.softCoral,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

enum _NoteAction { edit, delete }

// ─────────────────────────────────────────────
// 로딩 스켈레톤
// ─────────────────────────────────────────────

class _NotesLoadingSkeleton extends StatelessWidget {
  const _NotesLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ClayCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonCard(height: 16, borderRadius: 8),
                SizedBox(height: 8),
                SkeletonCard(height: 16, borderRadius: 8, width: 160),
                SizedBox(height: 8),
                SkeletonCard(height: 12, borderRadius: 6, width: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
