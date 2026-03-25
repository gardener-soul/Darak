import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/church_member.dart';
import '../../../models/church_member_profile.dart';
import '../../../theme/app_theme.dart';
import '../../../viewmodels/church/church_members_viewmodel.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/role_badge.dart';
import '../../../widgets/common/soft_text_field.dart';
import '../../church/member_detail_screen.dart';

/// 교회 상세 - 구성원 탭
/// 검색 + 교인 프로필 목록
class ChurchMembersTab extends ConsumerStatefulWidget {
  final String churchId;
  final ChurchMember? currentMember;

  const ChurchMembersTab({
    super.key,
    required this.churchId,
    required this.currentMember,
  });

  @override
  ConsumerState<ChurchMembersTab> createState() => _ChurchMembersTabState();
}

class _ChurchMembersTabState extends ConsumerState<ChurchMembersTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref
        .read(churchMembersViewModelProvider(widget.churchId).notifier)
        .setSearchQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync =
        ref.watch(churchMembersViewModelProvider(widget.churchId));

    return Column(
      children: [
        // ─── 검색바 ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: SoftTextField(
            controller: _searchController,
            hintText: '이름으로 검색',
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.textGrey,
            ),
            onChanged: _onSearchChanged,
          ),
        ),

        // ─── 교인 목록 ────────────────────────────────────────────────
        Expanded(
          child: membersAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.softCoral),
            ),
            error: (e, _) => Center(
              child: Text(
                '구성원 목록을 불러오지 못했어요.',
                style: AppTextStyles.bodySmall,
              ),
            ),
            data: (state) {
              if (state.members.isEmpty) {
                final isFiltering = state.searchQuery.isNotEmpty;
                return _EmptyMembersState(isFiltering: isFiltering);
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                itemCount: state.members.length,
                itemBuilder: (ctx, i) => _MemberCard(
                  profile: state.members[i],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

/// 교인 프로필 카드
class _MemberCard extends StatelessWidget {
  final ChurchMemberProfile profile;

  const _MemberCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return BouncyTapWrapper(
      onTap: () => Navigator.of(context).push(
        MemberDetailScreen.route(profile.userId),
      ),
      child: ClayCard(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            _MemberAvatar(
              imageUrl: profile.profileImageUrl,
              name: profile.name,
            ),
            const SizedBox(width: 12),
            Expanded(child: _MemberInfo(profile: profile)),
            RoleBadge(
              roleName: profile.roleName,
              roleLevel: profile.roleLevel,
            ),
            const SizedBox(width: 4),
            // 탭 가능함을 암시하는 화살표 아이콘
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textGrey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;

  const _MemberAvatar({required this.imageUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url != null && url.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(url),
        backgroundColor: AppColors.divider,
      );
    }
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.softCoral.withValues(alpha: 0.15),
      child: Text(
        name.isNotEmpty ? name[0] : '?',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.softCoral),
      ),
    );
  }
}

class _MemberInfo extends StatelessWidget {
  final ChurchMemberProfile profile;

  const _MemberInfo({required this.profile});

  @override
  Widget build(BuildContext context) {
    final groupLabel =
        profile.groupName ?? (profile.groupId != null ? '다락방' : '미배정');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          profile.name,
          style: AppTextStyles.bodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          groupLabel,
          style: AppTextStyles.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _EmptyMembersState extends StatelessWidget {
  /// true: 검색/필터 조건 적용 중 결과 없음 / false: 실제 등록된 교인 없음
  final bool isFiltering;

  const _EmptyMembersState({required this.isFiltering});

  @override
  Widget build(BuildContext context) {
    final message =
        isFiltering ? '검색 결과가 없습니다.' : '아직 등록된 교인이 없습니다.';
    final icon =
        isFiltering ? Icons.search_off_rounded : Icons.people_outline_rounded;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: AppColors.textGrey),
          const SizedBox(height: 12),
          Text(message, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
