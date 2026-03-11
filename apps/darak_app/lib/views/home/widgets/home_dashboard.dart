import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/user_providers.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';
import '../../auth/verification_waiting_screen.dart';
import '../../church/church_list_screen.dart';
import 'church_not_registered_banner.dart';
import 'home_bento_card.dart';

class HomeDashboard extends ConsumerWidget {
  final User? user;
  final String userName;
  final bool isPreview;

  const HomeDashboard({
    super.key,
    required this.user,
    required this.userName,
    this.isPreview = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WARNING-06: photoURL null 안전 처리 — 이중 bang 제거
    final photoUrl = user?.photoURL;

    // 교회 미등록 여부 확인 (로그인 상태에서만 확인)
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final hasNoChurch =
        !isPreview && currentUser != null && currentUser.churchId == null;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header Section ───────────────────────────────────────────
          _HomeHeader(userName: userName, photoUrl: photoUrl),
          const SizedBox(height: 24),

          // ─── Email Verification Banner ──────────────────────────────
          if (user != null && !user!.emailVerified)
            _EmailVerificationBanner(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const VerificationWaitingScreen(),
                ),
              ),
            ),

          // ─── Preview Mode Banner ─────────────────────────────────────
          if (isPreview) const _PreviewModeBanner(),

          // ─── Spirituality Streak (Top Feature) ────────────────────────
          const _StreakCard(),
          const SizedBox(height: 24),

          // ─── 교회 미등록 배너 ─────────────────────────────────────────
          if (hasNoChurch)
            ChurchNotRegisteredBanner(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ChurchListScreen()),
              ),
            ),

          // ─── Bento Grid Layout for Features ───────────────────────────
          Text('내 활동', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: [
              HomeBentoCard(
                title: '우리 교회',
                subtitle: '교회 찾기 & 교인 등록',
                icon: Icons.church_rounded,
                color: AppColors.skyBlue,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ChurchListScreen()),
                ),
                isLocked: isPreview,
              ),
              HomeBentoCard(
                title: '오늘의 말씀',
                subtitle: '매일 성경 QT',
                icon: Icons.menu_book_rounded,
                color: AppColors.sageGreen,
                onTap: () {},
                isLocked: isPreview,
              ),
              HomeBentoCard(
                title: '공동체',
                subtitle: '우리 다락방',
                icon: Icons.people_rounded,
                color: AppColors.softLavender,
                onTap: () {},
                isLocked: isPreview,
              ),
              HomeBentoCard(
                title: '행사/일정',
                subtitle: '교회 주요 행사',
                icon: Icons.calendar_month_rounded,
                color: AppColors.softCoral,
                textColor: Colors.white,
                isDark: true,
                onTap: () {},
                isLocked: isPreview,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── 분리된 위젯들 ──────────────────────────────────────────────────────────

/// 헤더 영역 (인사말 + 아바타)
class _HomeHeader extends StatelessWidget {
  final String userName;
  final String? photoUrl;

  const _HomeHeader({required this.userName, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('반가워요, $userName! 👋', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 4),
            Text('오늘도 은혜로운 하루 되세요', style: AppTextStyles.bodySmall),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundImage:
              photoUrl != null ? NetworkImage(photoUrl!) : null,
          backgroundColor: AppColors.sageGreen,
          child: photoUrl == null
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
      ],
    );
  }
}

/// 이메일 미인증 배너 (CRITICAL-03: Extract Widget)
class _EmailVerificationBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _EmailVerificationBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warmTangerine.withValues(alpha: 0.1),
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
    );
  }
}

/// 미리보기 모드 배너
class _PreviewModeBanner extends StatelessWidget {
  const _PreviewModeBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: AppColors.softCoral.withValues(alpha: 0.1),
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
    );
  }
}

/// 영성 스트릭 카드
class _StreakCard extends StatelessWidget {
  const _StreakCard();

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      color: AppColors.warmTangerine,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
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
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
