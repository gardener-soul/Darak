import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/bouncy_button.dart';
import '../../widgets/common/soft_text_field.dart';
import '../../repositories/group_repository.dart';
import '../../models/group.dart';
import 'widgets/group_card.dart';

/// 다락방 선택 화면
/// 마이페이지 또는 공동체 화면에서 다락방 가입 시 사용합니다.
/// [onGroupSelected]: 그룹 선택 완료 시 호출되는 콜백
/// [onSkip]: 건너뛰기 시 호출되는 콜백 (null이면 건너뛰기 버튼 미표시)
class GroupSelectionScreen extends ConsumerStatefulWidget {
  final void Function(Group group)? onGroupSelected;
  final VoidCallback? onSkip;

  const GroupSelectionScreen({
    super.key,
    this.onGroupSelected,
    this.onSkip,
  });

  @override
  ConsumerState<GroupSelectionScreen> createState() =>
      _GroupSelectionScreenState();
}

class _GroupSelectionScreenState extends ConsumerState<GroupSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String _searchQuery = '';
  String? _selectedGroupId;

  // 캐싱용 변수
  List<Group>? _cachedGroups;
  String _lastQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = query;
        _cachedGroups = null;
      });
    });
  }

  Future<List<Group>> _fetchGroups() async {
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

    _lastQuery = _searchQuery;
    _cachedGroups = groups;
    return groups;
  }

  void _onGroupTap(Group group) {
    setState(() {
      _selectedGroupId = group.id;
    });
  }

  void _confirmSelection(Group group) {
    widget.onGroupSelected?.call(group);
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
          if (widget.onSkip != null)
            TextButton(
              onPressed: widget.onSkip,
              child: Text(
                '건너뛰기',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
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

          if (_selectedGroupId != null)
            Padding(
              padding: const EdgeInsets.all(24),
              child: FutureBuilder<List<Group>>(
                future: _fetchGroups(),
                builder: (context, snapshot) {
                  final selected = snapshot.data?.where(
                    (g) => g.id == _selectedGroupId,
                  ).firstOrNull;
                  if (selected == null) return const SizedBox.shrink();
                  return BouncyButton(
                    onPressed: () => _confirmSelection(selected),
                    text: '가입하기',
                    icon: const Icon(Icons.check_rounded),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
