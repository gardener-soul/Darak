import 'package:flutter/material.dart';

import '../../../widgets/common/empty_state_view.dart';

/// 내 기도 탭 — 기도 제목 없음
class PrayerMyEmptyState extends StatelessWidget {
  final VoidCallback onAddTap;

  const PrayerMyEmptyState({super.key, required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      icon: Icons.volunteer_activism_rounded,
      message: '첫 기도 제목을 등록해보세요',
      subMessage: '기도 제목을 적고 매일 기도해요',
      actionLabel: '기도 제목 추가',
      onAction: onAddTap,
    );
  }
}

/// 공동체 기도 탭 — 다락방 미배정
class PrayerNoGroupEmptyState extends StatelessWidget {
  const PrayerNoGroupEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateView(
      icon: Icons.group_off_rounded,
      message: '다락방에 배정되면\n함께 기도할 수 있어요',
      subMessage: '다락방 배정 후 이용 가능합니다',
    );
  }
}

/// 공동체 기도 탭 — 공개 기도 제목 없음
class PrayerCommunityEmptyState extends StatelessWidget {
  const PrayerCommunityEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyStateView(
      icon: Icons.favorite_border_rounded,
      message: '아직 공유된 기도 제목이 없어요',
      subMessage: '기도 제목을 다락방에 공개해보세요',
    );
  }
}
