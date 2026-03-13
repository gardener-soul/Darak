import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/announcement.dart';
import '../../../models/church.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/church/church_announcements_viewmodel.dart';
import '../../../widgets/common/clay_card.dart';

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
          _ChurchInfoCard(church: church),
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

/// 교회 기본 정보 카드 (이름, 담임목사, 교단, 주소)
class _ChurchInfoCard extends StatelessWidget {
  final Church church;

  const _ChurchInfoCard({required this.church});

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.softCoral.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.church_rounded,
                  color: AppColors.softCoral,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      church.name,
                      style: AppTextStyles.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      church.denomination,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.person_rounded,
            label: '담임목사',
            value: church.seniorPastor,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.location_on_rounded,
            label: '주소',
            value: church.address,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textGrey),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: AppTextStyles.bodySmall,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
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
              .map((a) => _AnnouncementCard(announcement: a))
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
              '등록된 공지사항이 없습니다',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const _AnnouncementCard({required this.announcement});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('M월 d일', 'ko_KR').format(announcement.createdAt);

    return ClayCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (announcement.isPinned)
            const Padding(
              padding: EdgeInsets.only(right: 8, top: 2),
              child: Icon(
                Icons.push_pin_rounded,
                size: 16,
                color: AppColors.softCoral,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.title,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  announcement.content,
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(dateStr, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
