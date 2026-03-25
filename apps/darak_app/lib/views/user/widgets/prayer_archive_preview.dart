import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/core/soft_chip.dart';
import '../../../models/prayer.dart';
import '../../../models/prayer_period_type.dart';

class PrayerArchivePreview extends StatelessWidget {
  final int count;
  final List<Prayer> prayers;
  final VoidCallback onGoToPrayer;

  const PrayerArchivePreview({
    super.key,
    required this.count,
    required this.prayers,
    required this.onGoToPrayer,
  });

  @override
  Widget build(BuildContext context) {
    // 마일스톤 메시지 계산 — 가장 높은 달성 단계 하나만 표시
    final milestoneMessage = _resolveMilestoneMessage(count);

    return ClayCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                '기도 응답 아카이브',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              SoftChip(
                label: '$count건',
                color: AppColors.sageGreen,
                isSelected: true,
              ),
            ],
          ),
          // Phase 2: 마일스톤 달성 시 축하 카드 표시
          if (milestoneMessage != null) ...[
            const SizedBox(height: 12),
            _MilestoneCard(message: milestoneMessage),
          ],
          const SizedBox(height: 12),
          if (prayers.isEmpty)
            _buildEmptyState(context)
          else ...[
            ...prayers.map(
              (prayer) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _PrayerItem(prayer: prayer),
              ),
            ),
            const SizedBox(height: 8),
            BouncyButton(
              onPressed: onGoToPrayer,
              text: '전체 응답 보기',
              color: AppColors.sageGreen,
              textColor: AppColors.pureWhite,
            ),
          ],
        ],
      ),
    );
  }

  /// 달성된 마일스톤 중 가장 높은 단계의 메시지를 반환합니다.
  ///
  /// 마일스톤 미달성이면 null 반환.
  String? _resolveMilestoneMessage(int count) {
    if (count >= 100) return '🏆 기도 응답 100건! 놀라운 믿음의 여정이에요!';
    if (count >= 50) return '⭐ 기도 응답 50건! 꾸준한 기도가 응답받고 있어요!';
    if (count >= 10) return '🎉 기도 응답 10건! 기도의 열매가 맺히고 있어요!';
    return null;
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.auto_awesome_rounded,
          color: AppColors.softLavender,
          size: 40,
        ),
        const SizedBox(height: 12),
        Text(
          '기도가 응답되면 여기에 기록돼요',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        BouncyButton(
          onPressed: onGoToPrayer,
          text: '기도 제목 등록하기',
          color: AppColors.softLavender,
        ),
      ],
    );
  }
}

// ─── 마일스톤 축하 카드 ─────────────────────────────────────────────────────

/// 기도 응답 마일스톤(10/50/100건) 달성 시 표시되는 축하 카드
class _MilestoneCard extends StatelessWidget {
  final String message;

  const _MilestoneCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.warmTangerine.withValues(alpha: 0.15),
            AppColors.softLavender.withValues(alpha: 0.15),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warmTangerine.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // 트로피 아이콘 배지
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warmTangerine.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.warmTangerine,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 기도 응답 아이템 ───────────────────────────────────────────────────────

class _PrayerItem extends StatelessWidget {
  final Prayer prayer;

  const _PrayerItem({required this.prayer});

  /// 기도 기간 표시 문자열 생성
  ///
  /// - indefinite: "기간 없음"
  /// - 그 외: periodType.label (매일/이번 주/이번 달) + 날짜 범위
  String _periodText() {
    final fmt = DateFormat('yyyy.MM.dd');
    if (prayer.periodType == PrayerPeriodType.indefinite) {
      return '기간 없음';
    }
    final start = fmt.format(prayer.startDate);
    final end = prayer.endDate != null ? fmt.format(prayer.endDate!) : '-';
    return '$start ~ $end';
  }

  @override
  Widget build(BuildContext context) {
    final answeredDate = prayer.answeredAt ?? prayer.updatedAt;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: AppColors.sageGreen, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prayer.content,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              // 기도 기간
              Text(
                _periodText(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textGrey,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              // 응답일
              Text(
                '응답 ${DateFormat('M월 d일').format(answeredDate)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
