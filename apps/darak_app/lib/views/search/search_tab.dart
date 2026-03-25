import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/church.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/church/church_list_viewmodel.dart';
import '../../widgets/common/bouncy_button.dart';
import '../../widgets/common/empty_state_view.dart';
import '../../widgets/common/skeleton_card.dart';
import '../../widgets/common/soft_text_field.dart';
import '../church/church_detail_screen.dart';
import '../church/church_registration_screen.dart';
import 'widgets/church_search_card.dart';

/// 검색 탭 - 기존 게시판 탭 위치를 대체합니다.
/// 교회 목록 검색 + 교회 등록 CTA 섹션을 포함합니다.
class SearchTab extends ConsumerStatefulWidget {
  const SearchTab({super.key});

  @override
  ConsumerState<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends ConsumerState<SearchTab> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(churchListViewModelProvider.notifier).updateSearch(query);
  }

  void _navigateToDetail(Church church) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChurchDetailScreen(churchId: church.id),
      ),
    );
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ChurchRegistrationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final churchesAsync = ref.watch(churchListViewModelProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── 상단 헤더 ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Text('교회 찾기', style: AppTextStyles.headlineMedium),
          ),
          const SizedBox(height: 16),

          // ─── 검색바 ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SoftTextField(
              controller: _searchController,
              hintText: '교회 이름으로 검색...',
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textGrey,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          const SizedBox(height: 16),

          // ─── 교회 목록 ────────────────────────────────────────────
          Expanded(
            child: churchesAsync.when(
              loading: () => const _ChurchListSkeleton(),
              error: (e, _) => EmptyStateView(
                icon: Icons.error_outline_rounded,
                message: '교회 목록을 불러오지 못했어요',
                subMessage: '잠시 후 다시 시도해주세요.',
                iconColor: AppColors.textGrey,
              ),
              data: (churches) => _ChurchList(
                churches: churches,
                onChurchTap: _navigateToDetail,
                onRegisterTap: _navigateToRegister,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

/// 교회 목록 + 교회 등록 CTA 섹션
class _ChurchList extends StatelessWidget {
  final List<Church> churches;
  final void Function(Church) onChurchTap;
  final VoidCallback onRegisterTap;

  const _ChurchList({
    required this.churches,
    required this.onChurchTap,
    required this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    // 검색 결과 없음 슬롯(1) + 교회 카드 목록 + 여백(1) + CTA(1)
    final itemCount = (churches.isEmpty ? 1 : churches.length) + 2;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      itemCount: itemCount,
      itemBuilder: (ctx, index) {
        // 검색 결과 없음 메시지
        if (churches.isEmpty && index == 0) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: EmptyStateView(
              icon: Icons.search_off_rounded,
              message: '검색 결과가 없어요',
              subMessage: '다른 교회 이름으로 검색해보세요.',
            ),
          );
        }

        // 교회 카드 목록
        final churchIndex = churches.isEmpty ? index - 1 : index;
        if (churchIndex < churches.length) {
          final church = churches[churchIndex];
          return ChurchSearchCard(
            church: church,
            onTap: () => onChurchTap(church),
          );
        }

        // 여백
        if (index == itemCount - 2) {
          return const SizedBox(height: 8);
        }

        // ─── 교회 등록 CTA ─────────────────────────────────────
        return _ChurchRegisterCta(onTap: onRegisterTap);
      },
    );
  }
}

/// 교회 등록 CTA 섹션 (목록 하단 고정)
class _ChurchRegisterCta extends StatelessWidget {
  final VoidCallback onTap;

  const _ChurchRegisterCta({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.softCoral.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.softCoral.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '찾는 교회가 없나요?',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '교회를 직접 등록해보세요',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 16),
          BouncyButton(
            text: '교회 등록하기',
            icon: const Icon(Icons.add_rounded),
            onPressed: onTap,
            color: AppColors.softCoral,
            isFullWidth: false,
          ),
        ],
      ),
    );
  }
}

/// 로딩 중 스켈레톤 UI
class _ChurchListSkeleton extends StatelessWidget {
  const _ChurchListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      itemCount: 5,
      itemBuilder: (ctx, i) => const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: SkeletonCard(height: 100, borderRadius: 32),
      ),
    );
  }
}
