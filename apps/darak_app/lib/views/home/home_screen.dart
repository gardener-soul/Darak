import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/firebase_providers.dart';
import '../user/user_profile_screen.dart';
import '../../theme/app_theme.dart';
import 'widgets/home_dashboard.dart';

/// 홈 화면 (로그인 후 메인 화면 또는 미리보기 모드)
class HomeScreen extends ConsumerStatefulWidget {
  /// true이면 미리보기 모드 (로그인 없이 둘러보기)
  final bool isPreview;

  const HomeScreen({super.key, this.isPreview = false});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Current user can be null in preview mode
    final user = ref.watch(firebaseAuthProvider).currentUser;
    final userName = user?.displayName ?? '친구';

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            // 1. 홈 탭
            HomeDashboard(
              user: user,
              userName: userName,
              isPreview: widget.isPreview,
            ),
            // 2. 게시판 (준비 중)
            _buildPlaceholder('게시판'),
            // 3. 채팅 (준비 중)
            _buildPlaceholder('채팅'),
            // 4. 마이페이지
            const UserProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.article_rounded),
                label: '게시판',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_rounded),
                label: '채팅',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: '마이페이지',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.softCoral,
            unselectedItemColor: AppColors.textGrey,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            onTap: _onItemTapped,
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction_rounded, size: 48, color: AppColors.textGrey),
          const SizedBox(height: 16),
          Text(
            '$title 기능 준비 중입니다!',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}
