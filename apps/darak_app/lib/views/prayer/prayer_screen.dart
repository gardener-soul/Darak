import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/user_providers.dart';
import '../../models/prayer.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/prayer/community_prayer_viewmodel.dart';
import '../../viewmodels/prayer/prayer_list_viewmodel.dart';
import '../../widgets/common/core/soft_chip.dart';
import '../../widgets/common/skeleton_card.dart';
import 'widgets/community_prayer_card.dart';
import 'widgets/prayer_calendar.dart';
import 'widgets/prayer_card.dart';
import 'widgets/prayer_create_sheet.dart';
import 'widgets/prayer_detail_sheet.dart';
import 'widgets/prayer_empty_state.dart';

/// 교회 등록 여부를 확인 후 기도 등록 바텀시트를 표시합니다.
void _showPrayerCreateSheet(
  BuildContext context, {
  required String userId,
  required String churchId,
  String? groupId,
}) {
  if (churchId.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('교회 등록 후 이용 가능합니다.')));
    return;
  }
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.creamWhite,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) =>
        PrayerCreateSheet(userId: userId, churchId: churchId, groupId: groupId),
  );
}

/// 기도 메인 화면 — "내 기도" / "공동체 기도" 2탭 구조
class PrayerScreen extends ConsumerStatefulWidget {
  const PrayerScreen({super.key});

  @override
  ConsumerState<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends ConsumerState<PrayerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => const _LoadingView(),
      error: (_, _) => const _ErrorView(),
      data: (user) {
        if (user == null) return const _ErrorView();
        return Scaffold(
          backgroundColor: AppColors.creamWhite,
          body: SafeArea(
            child: Column(
              children: [
                _PrayerHeader(tabController: _tabController),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // 내 기도 탭
                      _MyPrayerTab(
                        userId: user.id,
                        churchId: user.churchId ?? '',
                        groupId: user.groupId,
                      ),
                      // 공동체 기도 탭
                      _CommunityPrayerTab(
                        groupId: user.groupId,
                        userId: user.id,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: _PrayerFab(
            userId: user.id,
            churchId: user.churchId ?? '',
            groupId: user.groupId,
          ),
        );
      },
    );
  }
}

// ─── 헤더 + 탭바 ──────────────────────────────────────────────────────────────

class _PrayerHeader extends StatelessWidget {
  final TabController tabController;

  const _PrayerHeader({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('기도', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppDecorations.clayShadow,
            ),
            child: TabBar(
              controller: tabController,
              indicator: BoxDecoration(
                color: AppColors.softCoral,
                borderRadius: BorderRadius.circular(14),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppColors.pureWhite,
              unselectedLabelColor: AppColors.textGrey,
              labelStyle: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
              tabs: const [
                Tab(text: '내 기도'),
                Tab(text: '공동체 기도'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── 내 기도 탭 ───────────────────────────────────────────────────────────────

class _MyPrayerTab extends ConsumerWidget {
  final String userId;
  final String churchId;
  final String? groupId;

  const _MyPrayerTab({
    required this.userId,
    required this.churchId,
    this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayersAsync = ref.watch(myPrayerListProvider(userId));

    return prayersAsync.when(
      loading: () => const _SkeletonList(),
      error: (_, _) => const _InlineError(),
      data: (prayers) {
        if (prayers.isEmpty) {
          return PrayerMyEmptyState(
            onAddTap: () => _showPrayerCreateSheet(
              context,
              userId: userId,
              churchId: churchId,
              groupId: groupId,
            ),
          );
        }
        return _MyPrayerContent(
          prayers: prayers,
          userId: userId,
          groupId: groupId,
        );
      },
    );
  }
}

class _MyPrayerContent extends ConsumerWidget {
  final List<Prayer> prayers;
  final String userId;
  final String? groupId;

  const _MyPrayerContent({
    required this.prayers,
    required this.userId,
    this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredPrayers = ref.watch(filteredPrayerListProvider(userId));

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        // 캘린더
        PrayerCalendar(prayers: prayers),
        const SizedBox(height: 20),
        // 선택된 날짜의 기도 목록
        if (filteredPrayers.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text('이 날 기도 제목이 없어요', style: AppTextStyles.bodySmall),
            ),
          )
        else
          ...filteredPrayers.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PrayerCard(
                prayer: p,
                onTap: () => _showDetail(context, p, groupId),
              ),
            ),
          ),
      ],
    );
  }

  void _showDetail(BuildContext context, Prayer prayer, String? groupId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.creamWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PrayerDetailSheet(prayer: prayer, groupId: groupId),
    );
  }
}

// ─── 공동체 기도 탭 ───────────────────────────────────────────────────────────

class _CommunityPrayerTab extends ConsumerStatefulWidget {
  final String? groupId;
  final String userId;

  const _CommunityPrayerTab({this.groupId, required this.userId});

  @override
  ConsumerState<_CommunityPrayerTab> createState() =>
      _CommunityPrayerTabState();
}

class _CommunityPrayerTabState extends ConsumerState<_CommunityPrayerTab> {
  CommunityPrayerFilter _filter = CommunityPrayerFilter.all;

  @override
  Widget build(BuildContext context) {
    final id = widget.groupId;
    if (id == null) {
      return const PrayerNoGroupEmptyState();
    }

    // 필터에 따라 적절한 Provider 선택
    final AsyncValue<List<Prayer>> prayersAsync;
    switch (_filter) {
      case CommunityPrayerFilter.all:
        prayersAsync = ref.watch(
          mergedCommunityPrayerListProvider(id, widget.userId),
        );
      case CommunityPrayerFilter.group:
        prayersAsync = ref.watch(communityPrayerListProvider(id));
      case CommunityPrayerFilter.followers:
        prayersAsync = ref.watch(followingPrayerListProvider(widget.userId));
    }

    return Column(
      children: [
        // ─── 필터 칩 ─────────────────────────────────────────────
        _CommunityFilterChips(
          selected: _filter,
          onSelected: (f) => setState(() => _filter = f),
        ),
        // ─── 기도 목록 ───────────────────────────────────────────
        Expanded(
          child: prayersAsync.when(
            loading: () => const _SkeletonList(),
            error: (_, _) => const _InlineError(),
            data: (prayers) {
              if (prayers.isEmpty) {
                return const PrayerCommunityEmptyState();
              }
              return _CommunityPrayerList(prayers: prayers);
            },
          ),
        ),
      ],
    );
  }
}

class _CommunityFilterChips extends StatelessWidget {
  final CommunityPrayerFilter selected;
  final ValueChanged<CommunityPrayerFilter> onSelected;

  const _CommunityFilterChips({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          SoftChip(
            label: '전체',
            color: AppColors.softCoral,
            isSelected: selected == CommunityPrayerFilter.all,
            onTap: () => onSelected(CommunityPrayerFilter.all),
          ),
          const SizedBox(width: 8),
          SoftChip(
            label: '다락방',
            color: AppColors.sageGreen,
            isSelected: selected == CommunityPrayerFilter.group,
            onTap: () => onSelected(CommunityPrayerFilter.group),
          ),
          const SizedBox(width: 8),
          SoftChip(
            label: '팔로잉',
            color: AppColors.softLavender,
            isSelected: selected == CommunityPrayerFilter.followers,
            onTap: () => onSelected(CommunityPrayerFilter.followers),
          ),
        ],
      ),
    );
  }
}

class _CommunityPrayerList extends StatelessWidget {
  final List<Prayer> prayers;

  const _CommunityPrayerList({required this.prayers});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      itemCount: prayers.length,
      itemBuilder: (context, i) {
        final p = prayers[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CommunityPrayerCard(
            prayer: p,
            userId: p.userId,
          ),
        );
      },
    );
  }
}

// ─── FAB ─────────────────────────────────────────────────────────────────────

class _PrayerFab extends StatelessWidget {
  final String userId;
  final String churchId;
  final String? groupId;

  const _PrayerFab({
    required this.userId,
    required this.churchId,
    this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showPrayerCreateSheet(
        context,
        userId: userId,
        churchId: churchId,
        groupId: groupId,
      ),
      backgroundColor: AppColors.softCoral,
      child: const Icon(Icons.add_rounded, color: AppColors.pureWhite),
    );
  }
}

// ─── 상태 위젯 ────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.softCoral),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '정보를 불러오지 못했어요.',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
      ),
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => const SkeletonCard(),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            color: AppColors.textGrey,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text('네트워크 연결을 확인해주세요', style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
