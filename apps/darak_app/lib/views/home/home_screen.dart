import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/firebase_providers.dart';
import '../auth/verification_waiting_screen.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/clay_card.dart';

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
            _buildHomeContent(user, userName),
            // 2. 게시판 (준비 중)
            _buildPlaceholder('게시판'),
            // 3. 채팅 (준비 중)
            _buildPlaceholder('채팅'),
            // 4. 마이페이지 (준비 중)
            _buildPlaceholder('마이페이지'),
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

  Widget _buildHomeContent(dynamic user, String userName) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(), // 미세한 바운스 효과 제거
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header Section ───────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '반가워요, $userName! 👋',
                    style: AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text('오늘도 은혜로운 하루 되세요', style: AppTextStyles.bodySmall),
                ],
              ),
              CircleAvatar(
                radius: 24,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                backgroundColor: AppColors.sageGreen,
                child: user?.photoURL == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ─── Email Verification Banner ──────────────────────────────
          if (user != null && !user.emailVerified)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const VerificationWaitingScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warmTangerine.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.warmTangerine),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.mark_email_unread_rounded,
                          color: AppColors.warmTangerine,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '이메일 인증이 필요해요! 📧',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.warmTangerine,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '눌러서 인증을 완료해주세요',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.warmTangerine,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: AppColors.warmTangerine,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // ─── Preview Mode Banner ─────────────────────────────────────
          if (widget.isPreview)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.softCoral.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.softCoral),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_rounded, color: AppColors.softCoral),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '미리보기 모드입니다. 로그인하고 모든 기능을 누려보세요!',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.softCoral,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ─── Spirituality Streak (Top Feature) ────────────────────────
          ClayCard(
            color: AppColors.warmTangerine,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '영성 스트릭 3일째 🔥',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '말씀 묵상으로 하루를 시작했어요',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ─── Bento Grid Layout for Features ───────────────────────────
          Text('내 활동', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            // childAspectRatio를 0.85 -> 1.1로 변경하여 높이를 줄임 (더 납작하게)
            childAspectRatio: 1.1,
            children: [
              _BentoCard(
                title: '출석 체크',
                subtitle: '주일 예배 출석',
                icon: Icons.check_circle_rounded,
                color: AppColors.sageGreen,
                onTap: () {
                  // Navigate or Action
                },
                isLocked: widget.isPreview,
              ),
              _BentoCard(
                title: '오늘의 말씀',
                subtitle: '매일 성경 QT',
                icon: Icons.menu_book_rounded,
                color: AppColors.skyBlue,
                onTap: () {},
                isLocked: widget.isPreview,
              ),
              _BentoCard(
                title: '공동체',
                subtitle: '우리 다락방',
                icon: Icons.people_rounded,
                color: AppColors.softLavender,
                onTap: () {},
                isLocked: widget.isPreview,
              ),
              _BentoCard(
                title: '행사/일정',
                subtitle: '교회 주요 행사',
                icon: Icons.calendar_month_rounded,
                color: AppColors.softCoral, // Accent
                textColor: Colors.white,
                isDark: true,
                onTap: () {},
                isLocked: widget.isPreview,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _BentoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isLocked;
  final bool isDark;
  final Color? textColor;

  const _BentoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isLocked = false,
    this.isDark = false,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor =
        textColor ?? (isDark ? Colors.white : AppColors.textDark);
    final effectiveSubtitleColor = isDark
        ? Colors.white.withOpacity(0.8)
        : AppColors.textGrey;

    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: ClayCard(
        color: color,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isDark ? Colors.white : AppColors.textDark,
                    size: 24,
                  ),
                ),
                if (isLocked)
                  Icon(
                    Icons.lock_rounded,
                    color: isDark ? Colors.white54 : Colors.black26,
                    size: 20,
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: effectiveTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: effectiveSubtitleColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
