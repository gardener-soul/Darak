import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/user_providers.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/empty_state_view.dart';
import '../church/church_detail_screen.dart';
import '../church/church_list_screen.dart';
import '../feed/feed_screen.dart';
import '../prayer/prayer_screen.dart';
import '../user/user_profile_screen.dart';

/// 홈 화면 — 5탭 하단 네비게이션
/// 나눔(피드) / 기도 / 말씀 / 공동체 / 나
class HomeScreen extends ConsumerStatefulWidget {
  final bool isPreview;

  const HomeScreen({super.key, this.isPreview = false});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 3; // 기본 진입: 공동체

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // 0. 나눔 (피드 타임라인)
          const FeedScreen(),
          // 1. 기도
          const PrayerScreen(),
          // 2. 말씀 (준비 중)
          const SafeArea(
            child: EmptyStateView(
              icon: Icons.menu_book_rounded,
              message: '말씀 기능 준비 중이에요',
              subMessage: '곧 만나요 :)',
            ),
          ),
          // 3. 공동체
          _CommunityTab(isPreview: widget.isPreview),
          // 4. 나
          const UserProfileScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 공동체 탭
// ─────────────────────────────────────────────────────────────────────────────

/// 공동체 탭 — 교회 등록 여부에 따라 교회 상세 또는 안내 화면 표시.
/// 중첩 Navigator로 내부 서브 화면(순원 상세 등) 스택을 탭 안에서 관리합니다.
class _CommunityTab extends ConsumerWidget {
  final bool isPreview;

  const _CommunityTab({required this.isPreview});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isPreview) {
      return const SafeArea(
        child: EmptyStateView(
          icon: Icons.lock_rounded,
          message: '로그인 후 이용할 수 있어요',
        ),
      );
    }

    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.softCoral),
      ),
      error: (_, _) => const Center(
        child: Text('정보를 불러오지 못했어요.'),
      ),
      data: (user) {
        final churchId = user?.churchId;
        if (churchId == null) {
          return SafeArea(
            child: EmptyStateView(
              icon: Icons.church_rounded,
              message: '아직 교회에 등록되지 않았어요',
              subMessage: '교회를 검색하고 등록 신청을 해보세요!',
              actionLabel: '교회 찾기',
              onAction: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChurchListScreen()),
              ),
            ),
          );
        }
        return Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => ChurchDetailScreen(churchId: churchId),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 하단 네비게이션 바
// ─────────────────────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: '나눔',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.volunteer_activism_rounded),
              label: '기도',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: '말씀',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.church_rounded),
              label: '공동체',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: '나',
            ),
          ],
          currentIndex: selectedIndex,
          onTap: onTap,
          selectedItemColor: AppColors.softCoral,
          unselectedItemColor: AppColors.textGrey,
          backgroundColor: AppColors.pureWhite,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedLabelStyle: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
