import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/user_providers.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';
import '../../auth/verification_waiting_screen.dart';
import '../../church/church_detail_screen.dart';
import 'church_not_registered_banner.dart';
import 'home_bento_card.dart';

class HomeDashboard extends ConsumerWidget {
  final User? user;
  final String userName;
  final bool isPreview;

  /// 검색 탭으로 이동을 요청하는 콜백 (HomeScreen에서 주입)
  final VoidCallback? onSearchTabRequested;

  const HomeDashboard({
    super.key,
    required this.user,
    required this.userName,
    this.isPreview = false,
    this.onSearchTabRequested,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          // ─── 헤더 영역 (인사말 + 아바타) ──────────────────────────────
          _HomeHeader(userName: userName, photoUrl: photoUrl),
          const SizedBox(height: 24),

          // ─── 이메일 미인증 배너 ───────────────────────────────────────
          if (user != null && !user!.emailVerified)
            _EmailVerificationBanner(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const VerificationWaitingScreen(),
                ),
              ),
            ),

          // ─── 미리보기 모드 배너 ──────────────────────────────────────
          if (isPreview) const _PreviewModeBanner(),

          // ─── 영성 스트릭 카드 ─────────────────────────────────────────
          const _StreakCard(),
          const SizedBox(height: 24),

          // ─── 교회 미등록 배너 ─────────────────────────────────────────
          if (hasNoChurch)
            ChurchNotRegisteredBanner(
              onTap: () => onSearchTabRequested?.call(),
            ),

          // ─── 벤토 그리드 (4개 2x2) ────────────────────────────────────
          Text('내 활동', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),

          // 1행: 공동체 + 오늘의 말씀
          Row(
            children: [
              Expanded(
                child: HomeBentoCard(
                  title: '공동체',
                  subtitle: currentUser?.churchId != null
                      ? '우리 마을 & 다락방'
                      : '교회를 찾아보세요',
                  icon: Icons.people_alt_rounded,
                  color: AppColors.skyBlue,
                  onTap: () {
                    if (isPreview) return;
                    final churchId = currentUser?.churchId;
                    if (churchId != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ChurchDetailScreen(churchId: churchId),
                        ),
                      );
                    } else {
                      onSearchTabRequested?.call();
                    }
                  },
                  isLocked: isPreview,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: HomeBentoCard(
                  title: '오늘의 말씀',
                  subtitle: '매일 성경 QT',
                  icon: Icons.menu_book_rounded,
                  color: AppColors.sageGreen,
                  onTap: () {},
                  isLocked: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 2행: 행사/일정 + 알림
          Row(
            children: [
              Expanded(
                child: HomeBentoCard(
                  title: '행사/일정',
                  subtitle: '교회 주요 일정',
                  icon: Icons.calendar_month_rounded,
                  color: AppColors.softLavender,
                  onTap: () {
                    if (isPreview) return;
                    final churchId = currentUser?.churchId;
                    if (churchId != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChurchDetailScreen(
                            churchId: churchId,
                            initialTabIndex: 3,
                          ),
                        ),
                      );
                    } else {
                      onSearchTabRequested?.call();
                    }
                  },
                  isLocked: isPreview,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: HomeBentoCard(
                  title: '알림',
                  subtitle: '새 소식을 확인해요',
                  icon: Icons.notifications_rounded,
                  color: AppColors.warmTangerine,
                  isDark: true,
                  onTap: () {},
                  isLocked: true,
                ),
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
              ? const Icon(Icons.person, color: AppColors.pureWhite)
              : null,
        ),
      ],
    );
  }
}

/// 이메일 미인증 배너
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
              color: AppColors.pureWhite.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: AppColors.pureWhite,
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
                  color: AppColors.pureWhite,
                  fontSize: 20,
                ),
              ),
              Text(
                '말씀 묵상으로 하루를 시작했어요',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.pureWhite.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
