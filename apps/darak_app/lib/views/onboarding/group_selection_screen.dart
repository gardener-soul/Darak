import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/bouncy_button.dart';
import '../../widgets/common/soft_text_field.dart';
import '../../repositories/group_repository.dart';
import '../../models/group.dart';
import '../../viewmodels/onboarding/onboarding_view_model.dart';
import 'widgets/group_card.dart';
import '../home/home_screen.dart';

/// 그룹 선택 화면
/// 온보딩 과정에서 사용자가 가입할 다락방을 선택합니다.
class GroupSelectionScreen extends ConsumerStatefulWidget {
  const GroupSelectionScreen({super.key});

  @override
  ConsumerState<GroupSelectionScreen> createState() =>
      _GroupSelectionScreenState();
}

class _GroupSelectionScreenState extends ConsumerState<GroupSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchQuery = '';
  String? _selectedGroupId;
  bool _isSubmitting = false;

  // 캐싱용 변수
  List<Group>? _cachedGroups;
  String _lastQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  /// 검색어 입력 시 Debounce 처리 (300ms)
  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = query;
      });
    });
  }

  /// 그룹 목록 가져오기 (검색 쿼리 반영, 캐싱 처리)
  Future<List<Group>> _fetchGroups() async {
    // 캐싱: 동일한 쿼리면 기존 데이터 반환
    if (_searchQuery == _lastQuery && _cachedGroups != null) {
      return _cachedGroups!;
    }

    final repository = ref.read(groupRepositoryProvider);
    final List<Group> groups;

    if (_searchQuery.trim().isEmpty) {
      groups = await repository.getAllGroups(limit: 20);
    } else {
      groups = await repository.searchGroups(_searchQuery.trim(), limit: 20);
    }

    // 캐시 저장
    _lastQuery = _searchQuery;
    _cachedGroups = groups;

    return groups;
  }

  /// 그룹 선택 처리
  void _onGroupTap(Group group) {
    setState(() {
      _selectedGroupId = group.id;
    });

    // ViewModel에 선택된 그룹 정보 저장
    final viewModel = ref.read(onboardingViewModelProvider.notifier);
    viewModel.selectGroup(
      groupId: group.id,
      groupName: group.name,
      groupImageUrl: group.imageUrl,
    );
  }

  /// 그룹 가입하기 (온보딩 제출)
  Future<void> _joinGroup() async {
    if (_selectedGroupId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('가입할 다락방을 선택해주세요.'),
          backgroundColor: AppColors.softCoral,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final viewModel = ref.read(onboardingViewModelProvider.notifier);
      await viewModel.submitOnboarding();

      // 성공 시 홈 화면으로 이동
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('가입 실패: ${e.toString()}'),
            backgroundColor: AppColors.softCoral,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  /// 그룹 선택 건너뛰기 (프로필만 완성)
  Future<void> _skipGroupSelection() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final viewModel = ref.read(onboardingViewModelProvider.notifier);
      await viewModel.skipGroupSelection();

      // 성공 시 홈 화면으로 이동
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('오류 발생: ${e.toString()}'),
            backgroundColor: AppColors.softCoral,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      appBar: AppBar(
        backgroundColor: AppColors.creamWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('다락방 선택'),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _skipGroupSelection,
            child: Text(
              '건너뛰기',
              style: AppTextStyles.bodyMedium.copyWith(
                color: _isSubmitting ? AppColors.disabled : AppColors.textGrey,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 검색 바
          Padding(
            padding: const EdgeInsets.all(24),
            child: SoftTextField(
              controller: _searchController,
              hintText: '다락방 이름으로 검색',
              prefixIcon: const Icon(Icons.search_rounded),
              keyboardType: TextInputType.text,
              onChanged: _onSearchChanged,
            ),
          ),

          // 그룹 목록
          Expanded(
            child: FutureBuilder<List<Group>>(
              future: _fetchGroups(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.softCoral),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 64,
                            color: AppColors.textGrey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '그룹 목록을 불러오지 못했습니다.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '인터넷 연결을 확인해주세요.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                          const SizedBox(height: 24),
                          BouncyButton(
                            onPressed: () {
                              setState(() {
                                _cachedGroups = null;
                                _lastQuery = '';
                              });
                            },
                            text: '다시 시도',
                            icon: const Icon(Icons.refresh_rounded),
                            isFullWidth: false,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final groups = snapshot.data ?? [];

                if (groups.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: AppColors.textGrey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _searchQuery.isEmpty
                                ? '아직 다락방이 없습니다.'
                                : '검색 결과가 없습니다.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: groups.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return GroupCard(
                      group: group,
                      isSelected: _selectedGroupId == group.id,
                      onTap: () => _onGroupTap(group),
                    );
                  },
                );
              },
            ),
          ),

          // 하단 가입하기 버튼
          if (_selectedGroupId != null)
            Padding(
              padding: const EdgeInsets.all(24),
              child: BouncyButton(
                onPressed: _isSubmitting ? null : _joinGroup,
                text: _isSubmitting ? '가입 중...' : '가입하기',
                icon: const Icon(Icons.check_rounded),
              ),
            ),
        ],
      ),
    );
  }
}
