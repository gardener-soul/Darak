import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/announcement.dart';
import '../../../models/church.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/church/church_announcements_viewmodel.dart';
import '../../../widgets/common/clay_card.dart';
import '../widgets/announcement_card.dart';
import '../widgets/church_info_header.dart';

/// 교회 상세 - 홈 탭
/// 교회 기본 정보 + 통계 + 최근 공지사항 3건 표시
class ChurchHomeTab extends ConsumerWidget {
  final String churchId;
  final Church church;

  const ChurchHomeTab({
    super.key,
    required this.churchId,
    required this.church,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcementsAsync =
        ref.watch(churchRecentAnnouncementsProvider(churchId));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChurchInfoHeader(church: church),
          const SizedBox(height: 16),
          _ChurchStatsRow(church: church),
          const SizedBox(height: 24),
          const Text('최근 공지사항', style: AppTextStyles.bodyLarge),
          const SizedBox(height: 12),
          _AnnouncementSection(announcementsAsync: announcementsAsync),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

/// 통계 3칸 Row (성도수, 마을수, 다락방수)
class _ChurchStatsRow extends StatelessWidget {
  final Church church;

  const _ChurchStatsRow({required this.church});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: '성도수',
            value: church.memberCount,
            unit: '명',
            color: AppColors.softCoral,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: '마을',
            value: church.villageCount,
            unit: '개',
            color: AppColors.sageGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: '다락방',
            value: church.groupCount,
            unit: '개',
            color: AppColors.skyBlue,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final String unit;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: [
          Text(
            '$value$unit',
            style: AppTextStyles.bodyLarge.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

/// 공지사항 섹션 (AsyncValue 처리)
class _AnnouncementSection extends StatelessWidget {
  final AsyncValue<List<Announcement>> announcementsAsync;

  const _AnnouncementSection({required this.announcementsAsync});

  @override
  Widget build(BuildContext context) {
    return announcementsAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.softCoral),
      ),
      error: (e, _) => Center(
        child: Text(
          '공지사항을 불러오지 못했어요.',
          style: AppTextStyles.bodySmall,
        ),
      ),
      data: (announcements) {
        if (announcements.isEmpty) {
          return const _EmptyAnnouncementState();
        }
        return Column(
          children: announcements
              .map((a) => AnnouncementCard(announcement: a))
              .toList(),
        );
      },
    );
  }
}

class _EmptyAnnouncementState extends StatelessWidget {
  const _EmptyAnnouncementState();

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.campaign_rounded,
              size: 36,
              color: AppColors.textGrey,
            ),
            const SizedBox(height: 8),
            Text(
              '아직 공지사항이 없어요',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              '첫 번째 공지를 작성해보세요 ✍️',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
