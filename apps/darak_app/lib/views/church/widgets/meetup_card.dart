import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/meetup.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';

/// 번개 모임 목록 카드 위젯
class MeetupCard extends StatelessWidget {
  final MeetUp meetup;
  final String? currentUserId;
  final VoidCallback? onTap;
  final VoidCallback? onReport;

  const MeetupCard({
    super.key,
    required this.meetup,
    this.currentUserId,
    this.onTap,
    this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final isReported = meetup.reportedBy.isNotEmpty;
    final participantCount = meetup.participantIds.length;
    final isFull = meetup.maxParticipants != null &&
        participantCount >= meetup.maxParticipants!;

    return ClayCard(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    meetup.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isReported)
                  const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: AppColors.warmTangerine,
                    ),
                  ),
                _ReportIconButton(onTap: onReport),
              ],
            ),
            if (meetup.scheduledAt != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: AppColors.textGrey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('M월 d일 (E) HH:mm', 'ko_KR')
                        .format(meetup.scheduledAt!),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ],
            if (meetup.description != null &&
                meetup.description!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                meetup.description!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textGrey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                // 참여자 스택 아바타
                _StackedAvatars(
                  participantIds: meetup.participantIds,
                  currentUserId: currentUserId,
                ),
                const SizedBox(width: 8),
                Text(
                  meetup.maxParticipants != null
                      ? '$participantCount / ${meetup.maxParticipants}명'
                      : '$participantCount명 참여 중',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isFull
                        ? AppColors.softCoral
                        : AppColors.textGrey,
                    fontWeight:
                        isFull ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
                if (isFull) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.softCoral.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '마감',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.softCoral,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _ReportIconButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _ReportIconButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.all(4),
        child: Icon(
          Icons.flag_outlined,
          size: 18,
          color: AppColors.textGrey,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

/// 참여자 아이디 배열을 스택(겹쳐진) 아바타로 표시합니다.
class _StackedAvatars extends StatelessWidget {
  final List<String> participantIds;
  final String? currentUserId;

  const _StackedAvatars({
    required this.participantIds,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    const maxVisible = 4;
    final visibleIds = participantIds.take(maxVisible).toList();
    final overflowCount = participantIds.length - maxVisible;

    if (participantIds.isEmpty) {
      return Text(
        '아직 참여자가 없어요',
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.disabled),
      );
    }

    return SizedBox(
      height: 28,
      width: (visibleIds.length * 20 + 8 + (overflowCount > 0 ? 28 : 0))
          .toDouble(),
      child: Stack(
        children: [
          ...visibleIds.asMap().entries.map((entry) {
            final i = entry.key;
            final id = entry.value;
            final isCurrentUser = id == currentUserId;
            return Positioned(
              left: i * 20.0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.creamWhite,
                    width: 1.5,
                  ),
                  color: isCurrentUser
                      ? AppColors.softCoral.withValues(alpha: 0.3)
                      : AppColors.softLavender.withValues(alpha: 0.5),
                ),
                child: Center(
                  child: Icon(
                    Icons.person_rounded,
                    size: 16,
                    color: isCurrentUser
                        ? AppColors.softCoral
                        : AppColors.textGrey,
                  ),
                ),
              ),
            );
          }),
          if (overflowCount > 0)
            Positioned(
              left: visibleIds.length * 20.0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.creamWhite, width: 1.5),
                  color: AppColors.disabled,
                ),
                child: Center(
                  child: Text(
                    '+$overflowCount',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 9,
                      color: AppColors.textGrey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
