import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/bouncy_button.dart';
import '../../widgets/common/soft_text_field.dart';
import '../../widgets/common/empty_state_view.dart';
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
  Group? _selectedGroup;

  // Future를 필드로 저장하여 매 build마다 새 Future가 생성되는 것을 방지
  late Future<List<Group>> _groupsFuture;

  @override
  void initState() {
    super.initState();
    _groupsFuture = _fetchGroups();
  }

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
        _groupsFuture = _fetchGroups();
      });
    });
  }

  Future<List<Group>> _fetchGroups() async {
    final repository = ref.read(groupRepositoryProvider);
    if (_searchQuery.trim().isEmpty) {
      return repository.getAllGroups(limit: 20);
    } else {
      return repository.searchGroups(_searchQuery.trim(), limit: 20);
    }
  }

  void _onGroupTap(Group group) {
    setState(() {
      _selectedGroup = group;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              future: _groupsFuture,
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
                  return EmptyStateView(
                    icon: Icons.error_outline_rounded,
                    message: '그룹 목록을 불러오지 못했습니다.',
                    subMessage: '인터넷 연결을 확인해주세요.',
                    actionLabel: '다시 시도',
                    onAction: () => setState(() {
                      _groupsFuture = _fetchGroups();
                    }),
                  );
                }

                final groups = snapshot.data ?? [];

                if (groups.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.search_off_rounded,
                    message: _searchQuery.isEmpty
                        ? '아직 다락방이 없습니다.'
                        : '검색 결과가 없습니다.',
                  );
                }

                return ListView.builder(
                  itemCount: groups.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return GroupCard(
                      group: group,
                      isSelected: _selectedGroup?.id == group.id,
                      onTap: () => _onGroupTap(group),
                    );
                  },
                );
              },
            ),
          ),

          if (_selectedGroup != null)
            Padding(
              padding: const EdgeInsets.all(24),
              child: BouncyButton(
                onPressed: () => widget.onGroupSelected?.call(_selectedGroup!),
                text: '가입하기',
                icon: const Icon(Icons.check_rounded),
              ),
            ),
        ],
      ),
    );
  }
}
