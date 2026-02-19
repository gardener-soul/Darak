import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/firebase_providers.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/clay_card.dart';
import 'widgets/user_profile_header.dart';
import 'widgets/user_stats_card.dart';
import 'widgets/user_menu_tile.dart';
import 'widgets/profile_edit_bottom_sheet.dart';

/// 마이페이지 (사용자 프로필) 화면
class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  bool _isLoggingOut = false;

  // ─── 가입일 포맷 헬퍼 ───────────────────────────────────────
  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  // ─── 로그아웃 ───────────────────────────────────────────────
  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppDecorations.defaultRadius,
        ),
        backgroundColor: AppColors.creamWhite,
        title: Text('로그아웃', style: AppTextStyles.headlineMedium),
        content: Text('정말 로그아웃 하시겠어요?', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              '취소',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              '로그아웃',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCoral,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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

  // ─── 프로필 수정 바텀시트 열기 ────────────────────────────────
  void _openEditProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileEditBottomSheet(
        onSave: () {
          // 저장 후 추가 동작 필요 시 여기에 작성
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(firebaseAuthProvider).currentUser;
    final displayName = user?.displayName ?? '사용자';
    final email = user?.email ?? '';
    final photoUrl = user?.photoURL;
    // Firebase Auth의 creationTime 사용
    final createdAt = user?.metadata.creationTime;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── 타이틀 ──────────────────────────────────────────
          Text('마이페이지', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 24),

          // ─── 프로필 헤더 카드 ─────────────────────────────────
          UserProfileHeader(
            displayName: displayName,
            email: email,
            photoUrl: photoUrl,
            onEditPressed: _openEditProfileSheet,
          ),
          const SizedBox(height: 24),

          // ─── 통계 섹션 ───────────────────────────────────────
          Text('내 활동 요약', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          _buildStatsRow(createdAt: createdAt),
          const SizedBox(height: 24),

          // ─── 메뉴 리스트 ─────────────────────────────────────
          Text('설정', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 16),
          _buildMenuSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // 통계 카드 Row
  // ═══════════════════════════════════════════════════════════════
  Widget _buildStatsRow({DateTime? createdAt}) {
    return Row(
      children: [
        Expanded(
          child: UserStatsCard(
            icon: Icons.calendar_today_rounded,
            label: '가입일',
            value: _formatDate(createdAt),
            color: AppColors.skyBlue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: UserStatsCard(
            icon: Icons.check_circle_rounded,
            label: '출석률',
            value: '--%',
            color: AppColors.sageGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: UserStatsCard(
            icon: Icons.favorite_rounded,
            label: '기도 제목',
            value: '0건',
            color: AppColors.softLavender,
          ),
        ),
      ],
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
          UserMenuTile(
            icon: Icons.people_rounded,
            title: '내 다락방(공동체)',
            subtitle: '소속 공동체 확인',
            color: AppColors.softLavender,
            onTap: () {
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
            },
          ),
          _buildDivider(),
          UserMenuTile(
            icon: Icons.notifications_rounded,
            title: '알림 설정',
            subtitle: '푸시 알림 관리',
            color: AppColors.warmTangerine,
            onTap: () {
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
            },
          ),
          _buildDivider(),
          UserMenuTile(
            icon: Icons.info_rounded,
            title: '앱 정보',
            subtitle: '버전 1.0.0 (MVP)',
            color: AppColors.skyBlue,
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
          UserMenuTile(
            icon: Icons.logout_rounded,
            title: '로그아웃',
            subtitle: '계정에서 로그아웃',
            color: AppColors.softCoral,
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
      child: Divider(height: 1, color: AppColors.divider.withOpacity(0.5)),
    );
  }
}
