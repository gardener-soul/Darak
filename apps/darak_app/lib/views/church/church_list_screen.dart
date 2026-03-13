import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/user_providers.dart';
import '../../models/church.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/church/church_list_viewmodel.dart';
import '../../widgets/common/bouncy_button.dart';
import '../../widgets/common/soft_text_field.dart';
import 'church_registration_screen.dart';
import 'widgets/church_card.dart';

/// 승인된 교회 목록 화면.
/// 교회 검색, 교회 선택(교인 등록), 교회 등록 신청으로 진입하는 허브입니다.
class ChurchListScreen extends ConsumerStatefulWidget {
  const ChurchListScreen({super.key});

  @override
  ConsumerState<ChurchListScreen> createState() => _ChurchListScreenState();
}

class _ChurchListScreenState extends ConsumerState<ChurchListScreen> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(churchListViewModelProvider.notifier).updateSearch(query);
    });
  }

  Future<void> _confirmJoin(Church church) async {
    // 이미 다른 교회에 등록된 경우 교체 플로우
    final currentUser = ref.read(currentUserProvider).valueOrNull;
    final prevChurchName = currentUser?.churchName;
    final isChanging =
        currentUser?.churchId != null && currentUser?.churchId != church.id;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isChanging ? '교회 변경' : '교인 등록',
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Text(
          isChanging
              ? '현재 등록된 \'${prevChurchName ?? '교회'}\'에서\n\'${church.name}\'(으)로 교회를 변경할까요?'
              : '\'${church.name}\'의 교인으로 등록하시겠어요?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              '취소',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              isChanging ? '변경' : '등록',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCoral,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(churchListViewModelProvider.notifier).joinChurch(
            churchId: church.id,
            churchName: church.name,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isChanging
                ? '\'${church.name}\'(으)로 교회가 변경되었어요!'
                : '\'${church.name}\' 교인으로 등록되었어요!',
          ),
        ),
      );
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString().replaceAll(RegExp(r'^Exception:\s*'), '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    }
  }

  void _goToRegistration() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ChurchRegistrationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final churchListAsync = ref.watch(churchListViewModelProvider);
    final currentUserAsync = ref.watch(currentUserProvider);

    // WARNING-03: 유저 로딩 완료 전까지 isRegistered 판단을 보류
    final isUserLoaded = currentUserAsync.hasValue;
    final myChurchId = currentUserAsync.valueOrNull?.churchId;

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      appBar: AppBar(
        backgroundColor: AppColors.creamWhite,
        elevation: 0,
        title: Text('우리 교회 찾기', style: AppTextStyles.bodyLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ─── 검색바 ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24),
              child: SoftTextField(
                controller: _searchController,
                hintText: '교회 이름으로 검색',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textGrey,
                ),
                onChanged: _onSearchChanged,
              ),
            ),

            // ─── 교회 목록 ─────────────────────────────────────────────
            Expanded(
              child: churchListAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.softCoral),
                ),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: AppColors.textGrey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '목록을 불러오지 못했어요',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      BouncyButton(
                        text: '다시 시도',
                        isFullWidth: false,
                        color: AppColors.softCoral,
                        onPressed: () =>
                            ref.invalidate(churchListViewModelProvider),
                      ),
                    ],
                  ),
                ),
                data: (churches) {
                  if (churches.isEmpty) {
                    return _EmptyChurchState(
                      searchQuery: _searchController.text,
                      onRegisterTap: _goToRegistration,
                    );
                  }
                  return ListView.builder(
                    itemCount: churches.length + 1,
                    itemBuilder: (ctx, index) {
                      if (index == churches.length) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                          child: BouncyButton(
                            text: '우리 교회가 없어요',
                            icon: const Icon(Icons.add_rounded),
                            isFullWidth: true,
                            color: AppColors.skyBlue,
                            textColor: AppColors.textDark,
                            onPressed: _goToRegistration,
                          ),
                        );
                      }
                      final church = churches[index];
                      final isRegistered = myChurchId == church.id;
                      return ChurchCard(
                        church: church,
                        isRegistered: isRegistered,
                        // 유저 로딩 완료 전, 또는 이미 이 교회에 등록된 경우만 비활성화
                        // 다른 교회에 등록된 경우에는 교체 가능하도록 활성화 유지
                        onRegisterTap: (!isUserLoaded || isRegistered)
                            ? null
                            : () => _confirmJoin(church),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 교회 목록이 비어있을 때 표시되는 빈 상태 위젯.
class _EmptyChurchState extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onRegisterTap;

  const _EmptyChurchState({
    required this.searchQuery,
    required this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasQuery = searchQuery.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (hasQuery)
              const Icon(
                Icons.search_off_rounded,
                size: 72,
                color: AppColors.textGrey,
              )
            else
              const Text('⛪', style: TextStyle(fontSize: 72)),
            const SizedBox(height: 16),
            Text(
              hasQuery
                  ? '"$searchQuery"에 해당하는 교회가 없어요'
                  : '아직 등록된 교회가 없어요',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              hasQuery
                  ? '교회명을 다시 확인하거나 등록 신청을 해주세요'
                  : '가장 먼저 우리 교회를 등록해보세요!',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // WARNING-01: const Icon 적용 (삼항 분기)
            // WARNING-07: Colors.white → AppColors.pureWhite 토큰으로 교체
            BouncyButton(
              text: '교회 등록 신청하기',
              icon: hasQuery
                  ? const Icon(Icons.add_rounded)
                  : const Icon(Icons.church_rounded),
              isFullWidth: false,
              color: hasQuery ? AppColors.softCoral : AppColors.skyBlue,
              textColor: hasQuery ? AppColors.pureWhite : AppColors.textDark,
              onPressed: onRegisterTap,
            ),
          ],
        ),
      ),
    );
  }
}
