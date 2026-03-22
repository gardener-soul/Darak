import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/user_providers.dart';
import '../../models/attendance.dart';
import '../../models/user.dart';
import '../../models/user_role.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/member/member_detail_viewmodel.dart';
import '../../widgets/common/skeleton_card.dart';
import 'widgets/member_attendance_card.dart';
import 'widgets/member_basic_info_card.dart';
import 'widgets/member_notes_section.dart';
import 'widgets/member_prayer_card.dart';
import 'widgets/member_profile_header.dart';

/// 순원 상세 프로필 화면
/// SliverAppBar 기반 콜랩서블 헤더 + 기본정보·기도제목·출석·비공개메모 섹션
class MemberDetailScreen extends ConsumerStatefulWidget {
  final String userId;

  const MemberDetailScreen({super.key, required this.userId});

  /// MaterialPageRoute 진입점
  static Route<void> route(String userId) {
    return MaterialPageRoute(
      builder: (_) => MemberDetailScreen(userId: userId),
    );
  }

  @override
  ConsumerState<MemberDetailScreen> createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends ConsumerState<MemberDetailScreen> {
  @override
  void initState() {
    super.initState();
    // 첫 프레임 완료 후 권한을 확인하여 메모 구독 시작 (단 한 번)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final currentUser = ref.read(currentUserProvider).valueOrNull;
      final canSeeNotes = currentUser != null &&
          currentUser.id != widget.userId &&
          currentUser.role.isLeaderOrAbove;
      if (canSeeNotes) {
        ref
            .read(memberDetailViewModelProvider(widget.userId).notifier)
            .startWatchingNotes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vmState = ref.watch(memberDetailViewModelProvider(widget.userId));
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final attendanceAsync = ref.watch(
      memberAttendanceHistoryProvider(widget.userId),
    );

    // 권한 체크: 순장 이상 + 자기 자신이 아닌 경우에만 메모 열람 가능
    final canSeeNotes = currentUser != null &&
        currentUser.id != widget.userId &&
        currentUser.role.isLeaderOrAbove;

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: vmState.userAsync.when(
        loading: () => const _LoadingBody(),
        error: (err, _) => _ErrorBody(message: err.toString()),
        data: (user) {
          if (user == null) {
            return const _ErrorBody(message: '순원 정보를 찾을 수 없어요');
          }
          return _DetailBody(
            user: user,
            vmState: vmState,
            attendanceAsync: attendanceAsync,
            canSeeNotes: canSeeNotes,
          );
        },
      ),
    );
  }

}

// ─────────────────────────────────────────────
// 메인 본문
// ─────────────────────────────────────────────

class _DetailBody extends StatelessWidget {
  final User user;
  final MemberDetailState vmState;
  final AsyncValue<List<Attendance>> attendanceAsync;
  final bool canSeeNotes;

  const _DetailBody({
    required this.user,
    required this.vmState,
    required this.attendanceAsync,
    required this.canSeeNotes,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── 콜랩서블 프로필 헤더 ──
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: AppColors.creamWhite,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: AppColors.textDark,
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: MemberProfileHeader(user: user),
          ),
        ),

        // ── 본문 섹션 ──
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // 생일 넛지 배너
              if (vmState.showBirthdayNudge) ...[
                _BirthdayNudgeBanner(daysUntil: vmState.daysUntilBirthday ?? 0),
                const SizedBox(height: 20),
              ],

              // 기본 정보
              MemberBasicInfoCard(user: user),
              const SizedBox(height: 24),

              // 기도 제목
              MemberPrayerCard(
                prayerRequests: user.prayerRequests ?? [],
              ),
              const SizedBox(height: 24),

              // 출석 현황
              MemberAttendanceCard(
                attendanceAsync: attendanceAsync,
                attendanceStats: user.attendanceStats,
              ),

              // 비공개 메모 (권한자만)
              if (canSeeNotes) ...[
                const SizedBox(height: 24),
                Consumer(
                  builder: (context, ref, _) {
                    final notesAsync = ref
                        .watch(memberDetailViewModelProvider(user.id))
                        .notesAsync;
                    final currentUserId =
                        ref.watch(currentUserIdProvider) ?? '';
                    return MemberNotesSection(
                      targetUserId: user.id,
                      currentUserId: currentUserId,
                      notesAsync: notesAsync,
                    );
                  },
                ),
              ],
            ]),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// 생일 넛지 배너
// ─────────────────────────────────────────────

class _BirthdayNudgeBanner extends StatelessWidget {
  final int daysUntil;

  const _BirthdayNudgeBanner({required this.daysUntil});

  @override
  Widget build(BuildContext context) {
    final label = daysUntil == 0 ? '오늘이 생일이에요! 🎉' : '$daysUntil일 후 생일이에요 🎂';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.softCoral.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.softCoral.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.cake_rounded, color: AppColors.softCoral, size: 20),
          const SizedBox(width: 10),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.softCoral,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 로딩 / 에러 상태
// ─────────────────────────────────────────────

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: AppColors.creamWhite,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: AppColors.textDark,
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: const FlexibleSpaceBar(
            background: ColoredBox(color: AppColors.creamWhite),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SkeletonCard(height: 120, borderRadius: 20),
              const SizedBox(height: 16),
              const SkeletonCard(height: 80, borderRadius: 20),
              const SizedBox(height: 16),
              const SkeletonCard(height: 160, borderRadius: 20),
            ]),
          ),
        ),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;

  const _ErrorBody({required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: AppColors.creamWhite,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            color: AppColors.textDark,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
