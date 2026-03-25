import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/user_providers.dart';
import '../../models/user.dart' as app_user;
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/clay_card.dart';
import '../../widgets/common/skeleton_card.dart';
import '../../widgets/common/core/clay_list_tile.dart';
import '../../widgets/common/core/soft_dialog.dart';
import 'profile_edit_screen.dart';
import 'widgets/attendance_heatmap.dart';
import 'widgets/monthly_attendance_bar.dart';
import 'widgets/prayer_archive_preview.dart';
import 'widgets/relationship_summary_card.dart';
import 'widgets/spiritual_dashboard_card.dart';
import 'widgets/user_profile_header.dart';

import '../../viewmodels/follow/follow_request_viewmodel.dart';
import '../../viewmodels/follow/follow_stats_viewmodel.dart';
import '../../viewmodels/user/prayer_archive_viewmodel.dart';
import '../../viewmodels/user/spiritual_dashboard_viewmodel.dart';
import '../church/church_detail_screen.dart';
import '../follow/follow_list_screen.dart';
import '../follow/follow_requests_screen.dart';
import '../follow/follow_search_screen.dart';
import 'prayer_archive_screen.dart';

/// 마이페이지 (사용자 프로필) 화면
///
/// Phase 3: currentUserProvider 바인딩으로 Firestore 실데이터 연동
/// AsyncValue 기반 로딩/에러/데이터 3분기 처리
class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  bool _isLoggingOut = false;

  // ─── 로그아웃 ───────────────────────────────────────────────
  Future<void> _handleLogout() async {
    // Phase 3 Migration: SoftDialog로 교체
    final confirm = await SoftDialog.show<bool>(
      context: context,
      title: '로그아웃',
      content: '정말 로그아웃 하시겠어요?',
      actions: [
        SoftDialogAction(
          label: '취소',
          onPressed: () => Navigator.of(context).pop(false),
        ),
        SoftDialogAction(
          label: '로그아웃',
          isDestructive: true,
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    );

    if (confirm == true && mounted) {
      setState(() => _isLoggingOut = true);
      try {
        await ref.read(authServiceProvider).signOut();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('로그아웃 실패: $e'),
              backgroundColor: AppColors.softCoral,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoggingOut = false);
      }
    }
  }

  // ─── 준비 중 기능 알림 SnackBar ──────────────────────────
  void _showComingSoonSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('준비 중인 기능입니다 🔜'),
        backgroundColor: AppColors.warmTangerine,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ─── 프로필 수정 화면 열기 ────────────────────────────────
  void _openEditProfileScreen() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ProfileEditScreen()));
  }

  // ─── 팔로잉/팔로워 목록 열기 ─────────────────────────────
  /// [initialTab] 0 = 팔로잉, 1 = 팔로워
  void _openFollowList(int initialTab) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FollowListScreen(initialTab: initialTab),
      ),
    );
  }

  // ─── 교회 미등록 안내 스낵바 ──────────────────────────────
  void _showChurchRequiredSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.warmTangerine,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ─── 기도 응답 아카이브 화면 열기 ─────────────────────────
  void _openPrayerArchive() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PrayerArchiveScreen()),
    );
  }

  // ─── 교인 찾기(팔로우 검색) 화면 열기 ─────────────────────
  void _openFollowSearch() {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user?.churchId == null) {
      _showChurchRequiredSnackBar('교회 등록 후 교인 찾기가 가능합니다');
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FollowSearchScreen()),
    );
  }

  // ─── 내 다락방(교회 상세) 화면 열기 ──────────────────────
  void _openMyChurch(String? churchId) {
    if (churchId == null) {
      _showChurchRequiredSnackBar('교회 등록 후 이용 가능합니다');
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChurchDetailScreen(churchId: churchId),
      ),
    );
  }

  // ─── 팔로우 요청 목록 화면 열기 ───────────────────────────
  void _openFollowRequests() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FollowRequestsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ═══════════════════════════════════════════════════════════
    // Phase 3 핵심: currentUserProvider (AsyncValue<User?>) 구독
    // ═══════════════════════════════════════════════════════════
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      // ─── 로딩 상태: Shimmer 스켈레톤 UI ─────────────────────
      loading: () => _buildLoadingState(),
      // ─── 에러 상태: Fallback UI ────────────────────────────
      error: (error, stack) => _buildErrorState(error),
      // ─── 데이터 상태: 메인 UI ──────────────────────────────
      data: (user) {
        if (user == null) {
          // Firestore에 유저 문서가 아직 없거나 로그아웃 진행 중
          return _buildLoadingState();
        }
        return _buildProfileContent(user);
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 정상 데이터 UI (메인 프로필 화면)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildProfileContent(app_user.User user) {
    final prayerPreviewAsync = ref.watch(
      answeredPrayerPreviewProvider(user.id),
    );
    final prayerCountAsync = ref.watch(answeredPrayerCountProvider(user.id));
    // 팔로잉/팔로워 수 실데이터 (§3-4 기획서)
    final followStatsAsync = ref.watch(followStatsProvider(user.id));
    // 연속 출석 주수 — 뱃지 시스템에 전달 (로딩/에러 시 0으로 fallback)
    final dashboardAsync = ref.watch(
      spiritualDashboardProvider((userId: user.id, groupId: user.groupId)),
    );
    final consecutiveWeeks = dashboardAsync.valueOrNull?.consecutiveWeeks ?? 0;
    // 나에게 온 팔로우 요청 수 (0이면 배너 숨김)
    final pendingRequestCount = ref
            .watch(pendingFollowRequestCountProvider(user.id))
            .valueOrNull ??
        0;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── 타이틀 ──────────────────────────────────────────
          Text('나의 여정', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 24),

          // ─── 프로필 헤더 카드 (§6.1 Clay Avatar) ──────────────
          UserProfileHeader(
            displayName: user.name,
            email: user.email ?? '',
            photoUrl: user.profileImageUrl,
            registerDate: user.registerDate ?? user.createdAt,
            bio: user.bio,
            onEditPressed: _openEditProfileScreen,
          ),

          // ─── 팔로우 요청 배너 (요청 건수 >= 1 일 때만 노출) ───────
          if (pendingRequestCount > 0) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _openFollowRequests,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warmTangerine.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.warmTangerine.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_add_rounded,
                      color: AppColors.warmTangerine,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '팔로우 요청 $pendingRequestCount건이 있어요',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.warmTangerine,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.warmTangerine,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (pendingRequestCount == 0) const SizedBox(height: 24),

          // ─── 영적 여정 요약 ────────────────────────────────────
          SpiritualDashboardCard(userId: user.id, groupId: user.groupId),
          const SizedBox(height: 24),

          // ─── 출석 히트맵 ───────────────────────────────────────
          AttendanceHeatmap(
            userId: user.id,
            consecutiveWeeks: consecutiveWeeks,
          ),
          const SizedBox(height: 16),
          MonthlyAttendanceBar(userId: user.id),
          const SizedBox(height: 24),

          // ─── 기도 응답 아카이브 ────────────────────────────────
          prayerPreviewAsync.when(
            loading: () => _shimmerBox(double.infinity, 140),
            error: (err, st) => const SizedBox.shrink(),
            data: (prayers) => PrayerArchivePreview(
              count: prayerCountAsync.valueOrNull ?? 0,
              prayers: prayers,
              onGoToPrayer: _openPrayerArchive,
            ),
          ),
          const SizedBox(height: 24),

          // ─── 관계망 요약 (팔로잉/팔로워 실데이터 연결) ────────────
          RelationshipSummaryCard(
            followingCount: followStatsAsync.valueOrNull?.following ?? 0,
            followerCount: followStatsAsync.valueOrNull?.follower ?? 0,
            clubCount: user.clubIds?.length ?? 0,
            onFollowingTap: () => _openFollowList(0),
            onFollowerTap: () => _openFollowList(1),
            onFindMembers: _openFollowSearch,
          ),
          const SizedBox(height: 24),

          // ─── 메뉴 리스트 (§6.3 Bouncing Animation) ────────────
          Text('설정', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          _buildMenuSection(user.churchId),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 로딩 상태 UI (Shimmer 스켈레톤)
  // ═══════════════════════════════════════════════════════════════
  Widget _buildLoadingState() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('나의 여정', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 24),
          // 프로필 헤더 스켈레톤
          ClayCard(
            child: Row(
              children: [
                _shimmerBox(80, 80, isCircle: true),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(160, 20),
                      const SizedBox(height: 8),
                      _shimmerBox(120, 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // 통계 대시보드 스켈레톤
          _shimmerBox(double.infinity, 16, width: 100),
          const SizedBox(height: 16),
          _shimmerBox(double.infinity, 140),
          const SizedBox(height: 24),
          // 메뉴 스켈레톤
          _shimmerBox(double.infinity, 16, width: 60),
          const SizedBox(height: 16),
          _shimmerBox(double.infinity, 200),
        ],
      ),
    );
  }

  /// Shimmer 효과를 내는 네모/원 스켈레톤 박스
  Widget _shimmerBox(
    double maxWidth,
    double height, {
    double? width,
    bool isCircle = false,
  }) {
    return SkeletonCard(
      width: width ?? maxWidth,
      height: height,
      borderRadius: isCircle ? 999 : 12,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 에러 상태 Fallback UI
  // ═══════════════════════════════════════════════════════════════
  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.softCoral.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 64,
                color: AppColors.softCoral,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '프로필을 불러올 수 없어요',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '네트워크 연결을 확인하고 다시 시도해주세요.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => ref.invalidate(currentUserProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('다시 시도'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.softCoral,
                side: const BorderSide(color: AppColors.softCoral),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDecorations.buttonRadius,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 메뉴 리스트 섹션
  // ═══════════════════════════════════════════════════════════════
  Widget _buildMenuSection(String? churchId) {
    return ClayCard(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Column(
        children: [
          ClayListTile(
            leadingIcon: Icons.people_rounded,
            title: '내 다락방(공동체)',
            subtitle: '소속 공동체 확인',
            leadingColor: AppColors.sageGreen,
            onTap: () => _openMyChurch(churchId),
          ),
          _buildDivider(),
          ClayListTile(
            leadingIcon: Icons.notifications_rounded,
            title: '알림 설정',
            subtitle: '푸시 알림 관리',
            leadingColor: AppColors.warmTangerine,
            onTap: _showComingSoonSnackBar,
          ),
          _buildDivider(),
          ClayListTile(
            leadingIcon: Icons.info_rounded,
            title: '앱 정보',
            subtitle: '버전 1.0.0 (MVP)',
            leadingColor: AppColors.skyBlue,
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: '다락(Darak)',
                applicationVersion: '1.0.0 (MVP)',
                applicationIcon: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.softCoral,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.church_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                children: [
                  Text('교회 청년부를 위한 공동체 앱', style: AppTextStyles.bodyMedium),
                ],
              );
            },
          ),
          _buildDivider(),
          ClayListTile(
            leadingIcon: Icons.logout_rounded,
            title: '로그아웃',
            subtitle: '계정에서 로그아웃',
            leadingColor: AppColors.softCoral,
            isDestructive: true,
            isLoading: _isLoggingOut,
            onTap: _isLoggingOut ? null : _handleLogout,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Divider(
        height: 1,
        color: AppColors.divider.withValues(alpha: 0.5),
      ),
    );
  }
}
