import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers/user_providers.dart';
import '../../models/attendance_status.dart';
import '../../models/attendance_type.dart';
import '../../models/user.dart' as app_user;
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/attendance/attendance_viewmodel.dart';
import '../../widgets/common/clay_card.dart';
import '../../widgets/common/core/clay_list_tile.dart';
import '../../widgets/common/core/soft_dialog.dart';
import 'profile_edit_screen.dart';
import 'widgets/user_profile_header.dart';
import 'widgets/user_stats_dashboard.dart';

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
  Timer? _shimmerTimer;
  bool _shimmerFlag = false;

  @override
  void initState() {
    super.initState();
    // 800ms 주기로 Shimmer 깜빡임 애니메이션 (Pulse) 강제 발생
    _shimmerTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted) setState(() => _shimmerFlag = !_shimmerFlag);
    });
  }

  @override
  void dispose() {
    _shimmerTimer?.cancel();
    super.dispose();
  }

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ─── 프로필 수정 화면 열기 ────────────────────────────────
  void _openEditProfileScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProfileEditScreen(),
      ),
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
    // 출석 통계 파싱 (null 안전)
    final stats = user.attendanceStats;
    final attendanceTotal = stats?['total'] as int?;
    final attendanceAttended = stats?['attended'] as int?;
    final prayerCount = user.prayerRequests?.length ?? 0;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── 타이틀 ──────────────────────────────────────────
          Text('마이페이지', style: AppTextStyles.headlineLarge),
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
          const SizedBox(height: 24),

          // ─── 통계 대시보드 (§6.2 Stats Dashboard) ─────────────
          Text('내 활동 요약', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          UserStatsDashboard(
            // Phase 3: Firestore 실데이터 바인딩
            groupName: null, // TODO: groupId로 group name 조회 (추후 구현)
            attendanceTotal: attendanceTotal,
            attendanceAttended: attendanceAttended,
            prayerRequestCount: prayerCount,
          ),
          const SizedBox(height: 24),

          // ─── 내 출석 기록 ──────────────────────────────────────
          Text('최근 출석 기록', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          _MyAttendanceSection(userId: user.id),
          const SizedBox(height: 24),

          // ─── 메뉴 리스트 (§6.3 Bouncing Animation) ────────────
          Text('설정', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          _buildMenuSection(),
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
          Text('마이페이지', style: AppTextStyles.headlineLarge),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      width: width ?? maxWidth,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.divider.withValues(alpha: _shimmerFlag ? 0.2 : 0.6),
        borderRadius: isCircle ? null : BorderRadius.circular(12),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
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
  Widget _buildMenuSection() {
    return ClayCard(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Column(
        children: [
          ClayListTile(
            leadingIcon: Icons.people_rounded,
            title: '내 다락방(공동체)',
            subtitle: '소속 공동체 확인',
            leadingColor: AppColors.softLavender,
            onTap: _showComingSoonSnackBar,
          ),
          _buildDivider(),
          ClayListTile(
            leadingIcon: Icons.menu_book_rounded,
            title: '내 기도 제목',
            subtitle: '기도 제목 관리',
            leadingColor: AppColors.sageGreen,
            onTap: _showComingSoonSnackBar,
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

// ═══════════════════════════════════════════════════════════════
// 내 최근 출석 기록 섹션 Widgets
// ═══════════════════════════════════════════════════════════════

class _MyAttendanceSection extends ConsumerWidget {
  final String userId;

  const _MyAttendanceSection({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendancesAsync = ref.watch(myAttendanceHistoryProvider(userId));

    return attendancesAsync.when(
      loading: () => ClayCard(
        padding: const EdgeInsets.all(24),
        child: const Center(
          child: CircularProgressIndicator(color: AttendanceColors.present),
        ),
      ),
      error: (_, __) => ClayCard(
        padding: const EdgeInsets.all(24),
        child: Text(
          '출석 기록을 불러오지 못했어요.',
          style: AppTextStyles.bodySmall,
        ),
      ),
      data: (attendances) {
        if (attendances.isEmpty) {
          return ClayCard(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.event_busy_rounded,
                    size: 40,
                    color: AppColors.disabled,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '최근 한 달간 출석 기록이 없어요.',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }

        return ClayCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: List.generate(attendances.length, (i) {
              final a = attendances[i];
              final isLast = i == attendances.length - 1;
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                child: _MyAttendanceTile(
                  date: a.date,
                  type: a.type,
                  status: a.status,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _MyAttendanceTile extends StatelessWidget {
  final DateTime date;
  final AttendanceType type;
  final AttendanceStatus status;

  static const _statusColors = {
    AttendanceStatus.present: AttendanceColors.present,
    AttendanceStatus.late: AttendanceColors.late,
    AttendanceStatus.absent: AttendanceColors.absent,
    AttendanceStatus.excused: AttendanceColors.excused,
  };

  static const _statusLabels = {
    AttendanceStatus.present: '출석',
    AttendanceStatus.late: '지각',
    AttendanceStatus.absent: '결석',
    AttendanceStatus.excused: '사유',
  };

  const _MyAttendanceTile({
    required this.date,
    required this.type,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('MM.dd (E)', 'ko');
    final color = _statusColors[status] ?? AppColors.textGrey;
    final label = _statusLabels[status] ?? '';
    final typeLabel = type.label;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(formatter.format(date), style: AppTextStyles.bodyMedium),
          const Spacer(),
          Text(typeLabel, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
