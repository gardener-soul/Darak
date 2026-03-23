import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/user_providers.dart';
import '../../../core/utils/string_utils.dart';
import '../../../models/meetup.dart';
import '../../../models/user.dart';
import '../../../repositories/user_repository.dart';
import '../../../viewmodels/meetup/meetup_viewmodel.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/core/clay_avatar.dart';
import '../../../widgets/common/core/soft_dialog.dart';

/// userId로 유저를 스트림 구독하는 Provider (이 파일에서만 사용)
final _userByIdProvider = StreamProvider.family<User?, String>((ref, userId) {
  return ref.watch(userRepositoryProvider).watchUser(userId);
});

/// 번개 모임 상세 바텀시트
class MeetupDetailBottomSheet extends ConsumerWidget {
  final MeetUp meetup;
  final String churchId;

  const MeetupDetailBottomSheet({
    super.key,
    required this.meetup,
    required this.churchId,
  });

  static Future<void> show(
    BuildContext context, {
    required MeetUp meetup,
    required String churchId,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (ctx, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.creamWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: MeetupDetailBottomSheet(
            meetup: meetup,
            churchId: churchId,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdProvider);
    final isParticipating =
        currentUserId != null && meetup.participantIds.contains(currentUserId);
    final isLeader = meetup.meetLeaderId == currentUserId;
    final isFull = meetup.maxParticipants != null &&
        meetup.participantIds.length >= meetup.maxParticipants!;
    final isReported = meetup.reportedBy.isNotEmpty;
    final hasReported =
        currentUserId != null && meetup.reportedBy.contains(currentUserId);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 핸들 바
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 제목 + 신고 배지
        Row(
          children: [
            Expanded(
              child: Text(meetup.name, style: AppTextStyles.headlineMedium),
            ),
            if (isReported)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warmTangerine.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 12,
                      color: AppColors.warmTangerine,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '신고됨',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11,
                        color: AppColors.warmTangerine,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // 일시
        if (meetup.scheduledAt != null) ...[
          _InfoRow(
            icon: Icons.bolt_rounded,
            iconColor: AppColors.warmTangerine,
            text: DateFormat('yyyy년 M월 d일 (E) HH:mm', 'ko_KR')
                .format(meetup.scheduledAt!),
          ),
          const SizedBox(height: 8),
        ],

        // 인원 정보
        _InfoRow(
          icon: Icons.people_rounded,
          iconColor: AppColors.sageGreen,
          text: meetup.maxParticipants != null
              ? '${meetup.participantIds.length} / ${meetup.maxParticipants}명 참여 중'
              : '${meetup.participantIds.length}명 참여 중 (제한없음)',
        ),
        const SizedBox(height: 12),

        // 설명
        if (meetup.description != null && meetup.description!.isNotEmpty) ...[
          Text(
            meetup.description!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 참여자 명단
        if (meetup.participantIds.isNotEmpty) ...[
          Text(
            '참여자',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 8),
          _ParticipantsList(
            participantIds: meetup.participantIds,
            currentUserId: currentUserId,
          ),
          const SizedBox(height: 20),
        ],

        // 신고 경고 배너
        if (isReported) ...[
          ClayCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warmTangerine,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '다른 사용자가 신고한 모임이에요 👀\n참여 시 주의하세요.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 버튼 영역
        Row(
          children: [
            // 신고 버튼 (주최자 본인 제외, 미신고 상태일 때)
            if (!isLeader && !hasReported)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _OutlineIconButton(
                  icon: Icons.flag_outlined,
                  onTap: () => _onReport(context, ref),
                ),
              ),
            // 삭제 버튼 (주최자 본인)
            if (isLeader)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _OutlineIconButton(
                  icon: Icons.delete_outline_rounded,
                  color: AppColors.softCoral,
                  onTap: () => _onDelete(context, ref),
                ),
              ),
            // 참여/취소/마감 버튼
            Expanded(
              child: BouncyButton(
                text: isParticipating
                    ? '참여 취소'
                    : (isFull ? '마감됨' : '참여하기'),
                onPressed: (isFull && !isParticipating)
                    ? null
                    : () => _onJoinOrLeave(context, ref, isParticipating),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _onJoinOrLeave(
    BuildContext context,
    WidgetRef ref,
    bool isParticipating,
  ) async {
    // 신고된 모임 참여 시 경고 모달
    if (!isParticipating && meetup.reportedBy.isNotEmpty) {
      final confirmed = await SoftDialog.show<bool>(
        context: context,
        title: '앗! 신고된 모임이에요 👀',
        content: '다른 사용자가 신고한 모임이에요. 그래도 참여하시겠어요?',
        actions: [
          SoftDialogAction(
            label: '취소',
            onPressed: () => Navigator.pop(context, false),
          ),
          SoftDialogAction(
            label: '참여할게요',
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      );
      if (confirmed != true) return;
    }

    try {
      final notifier =
          ref.read(meetupViewModelProvider(churchId).notifier);
      if (isParticipating) {
        await notifier.leaveMeetup(
          churchId: churchId,
          meetupId: meetup.id,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('참여를 취소했어요.')),
          );
          Navigator.pop(context);
        }
      } else {
        await notifier.joinMeetup(
          churchId: churchId,
          meetupId: meetup.id,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('번개 모임에 참여했어요! ⚡')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              StringUtils.cleanExceptionMessage(e),
            ),
          ),
        );
      }
    }
  }

  Future<void> _onReport(BuildContext context, WidgetRef ref) async {
    final confirmed = await SoftDialog.show<bool>(
      context: context,
      title: '모임 신고',
      content: '이 모임을 신고하시겠어요?\n신고된 모임은 다른 참여자에게 경고가 표시됩니다.',
      actions: [
        SoftDialogAction(
          label: '취소',
          onPressed: () => Navigator.pop(context, false),
        ),
        SoftDialogAction(
          label: '신고하기',
          isDestructive: true,
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(meetupViewModelProvider(churchId).notifier).reportMeetup(
            churchId: churchId,
            meetupId: meetup.id,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('신고가 접수되었어요.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              StringUtils.cleanExceptionMessage(e),
            ),
          ),
        );
      }
    }
  }

  Future<void> _onDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await SoftDialog.show<bool>(
      context: context,
      title: '번개 모임 삭제',
      content: '정말 이 번개 모임을 삭제하시겠어요?',
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
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(meetupViewModelProvider(churchId).notifier).deleteMeetup(
            churchId: churchId,
            meetupId: meetup.id,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('번개 모임이 삭제되었어요.')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              StringUtils.cleanExceptionMessage(e),
            ),
          ),
        );
      }
    }
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

/// 참여자 명단: 가로 스크롤 아바타 리스트
class _ParticipantsList extends ConsumerWidget {
  final List<String> participantIds;
  final String? currentUserId;

  const _ParticipantsList({
    required this.participantIds,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: participantIds.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (ctx, i) {
          final userId = participantIds[i];
          return _ParticipantAvatar(
            userId: userId,
            isCurrentUser: userId == currentUserId,
          );
        },
      ),
    );
  }
}

class _ParticipantAvatar extends ConsumerWidget {
  final String userId;
  final bool isCurrentUser;

  const _ParticipantAvatar({
    required this.userId,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(
      _userByIdProvider(userId),
    );

    return userAsync.when(
      loading: () => _AvatarSkeleton(isCurrentUser: isCurrentUser),
      error: (_, _) => _AvatarPlaceholder(isCurrentUser: isCurrentUser),
      data: (user) {
        if (user == null) {
          return _AvatarPlaceholder(isCurrentUser: isCurrentUser);
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClayAvatar(
              imageUrl: user.profileImageUrl,
              size: AvatarSize.small,
              borderColor: isCurrentUser ? AppColors.softCoral : null,
            ),
            const SizedBox(height: 4),
            Text(
              user.name,
              style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}

class _AvatarSkeleton extends StatelessWidget {
  final bool isCurrentUser;
  const _AvatarSkeleton({required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.disabled,
            border: isCurrentUser
                ? Border.all(color: AppColors.softCoral, width: 2)
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Container(width: 32, height: 8, color: AppColors.disabled),
      ],
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  final bool isCurrentUser;
  const _AvatarPlaceholder({required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.softLavender.withValues(alpha: 0.4),
            border: isCurrentUser
                ? Border.all(color: AppColors.softCoral, width: 2)
                : null,
          ),
          child: const Icon(
            Icons.person_rounded,
            color: AppColors.textGrey,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text('?', style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _OutlineIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _OutlineIconButton({
    required this.icon,
    this.color = AppColors.textGrey,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider, width: 1.5),
          color: AppColors.pureWhite,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

