import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/user_providers.dart';
import '../../models/follow/follow_status.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/follow/follow_search_viewmodel.dart';
import '../../widgets/common/empty_state_view.dart';
import '../../widgets/common/soft_text_field.dart';
import 'widgets/follow_user_card.dart';

/// 같은 교회 교인 검색 + 팔로우 요청 화면
class FollowSearchScreen extends ConsumerStatefulWidget {
  const FollowSearchScreen({super.key});

  @override
  ConsumerState<FollowSearchScreen> createState() => _FollowSearchScreenState();
}

class _FollowSearchScreenState extends ConsumerState<FollowSearchScreen> {
  final _searchController = TextEditingController();
  // 디바운스 타이머: 연속 입력 시 마지막 입력 후 400ms 뒤에만 검색 실행
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // 이전 타이머 취소 후 재설정 (400ms 디바운스)
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final user = ref.read(currentUserProvider).valueOrNull;
      if (user == null) return;

      ref.read(followSearchViewModelProvider.notifier).search(
            query: query,
            currentUserId: user.id,
            churchId: user.churchId ?? '',
          );
    });
  }

  Future<void> _onFollowTap(String followeeId) async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;

    try {
      await ref.read(followSearchViewModelProvider.notifier).sendFollowRequest(
            followerId: user.id,
            followeeId: followeeId,
            churchId: user.churchId ?? '',
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('팔로우 요청을 보냈어요'),
            backgroundColor: AppColors.sageGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('팔로우 요청에 실패했어요. 다시 시도해주세요.'),
            backgroundColor: AppColors.softCoral,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(followSearchViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      appBar: AppBar(
        title: const Text('교인 찾기'),
        backgroundColor: AppColors.creamWhite,
      ),
      body: Column(
        children: [
          // ─── 검색창 ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: SoftTextField(
              controller: _searchController,
              hintText: '이름으로 검색',
              onChanged: _onSearchChanged,
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textGrey,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ─── 검색 결과 ───────────────────────────────────────────
          Expanded(child: _SearchResultBody(
            searchAsync: searchAsync,
            searchQuery: _searchController.text,
            onFollowTap: _onFollowTap,
          )),
        ],
      ),
    );
  }
}

// ─── 검색 결과 바디 ──────────────────────────────────────────────────────────

class _SearchResultBody extends StatelessWidget {
  final AsyncValue<List<FollowSearchResult>> searchAsync;
  final String searchQuery;
  final Future<void> Function(String followeeId) onFollowTap;

  const _SearchResultBody({
    required this.searchAsync,
    required this.searchQuery,
    required this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    // 검색어가 비어 있으면 초기 안내 화면 표시 (결과 없음과 구분)
    if (searchQuery.trim().isEmpty) {
      return const _SearchInitialView();
    }

    return searchAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.softCoral),
      ),
      error: (_, __) => const EmptyStateView(
        icon: Icons.wifi_off_rounded,
        message: '검색에 실패했어요',
        subMessage: '네트워크 연결을 확인해주세요',
      ),
      data: (results) {
        if (results.isEmpty) {
          return const EmptyStateView(
            icon: Icons.person_search_rounded,
            message: '검색 결과가 없어요',
            subMessage: '이름을 다시 확인해보세요',
          );
        }
        return _SearchResultList(
          results: results,
          onFollowTap: onFollowTap,
        );
      },
    );
  }
}

class _SearchInitialView extends StatelessWidget {
  const _SearchInitialView();

  @override
  Widget build(BuildContext context) {
    return const EmptyStateView(
      icon: Icons.group_add_rounded,
      message: '교인을 검색해보세요',
      subMessage: '같은 교회 교인의 이름을 입력하세요',
    );
  }
}

class _SearchResultList extends StatelessWidget {
  final List<FollowSearchResult> results;
  final Future<void> Function(String followeeId) onFollowTap;

  const _SearchResultList({
    required this.results,
    required this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      itemCount: results.length,
      separatorBuilder: (context, index) => const Divider(
        color: AppColors.divider,
        height: 1,
      ),
      itemBuilder: (context, i) {
        final item = results[i];
        final canFollow = item.followStatus == null ||
            item.followStatus == FollowStatus.rejected;

        return FollowUserCard(
          user: item.user,
          followStatus: item.followStatus,
          onFollowTap: canFollow ? () => onFollowTap(item.user.id) : null,
        );
      },
    );
  }
}
