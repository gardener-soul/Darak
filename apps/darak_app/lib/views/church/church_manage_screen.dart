import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/church_role.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/church/church_detail_viewmodel.dart';
import '../../viewmodels/church/church_manage_viewmodel.dart';
import '../../viewmodels/church/church_roles_provider.dart';
import '../../widgets/common/bouncy_button.dart';
import '../../widgets/common/soft_text_field.dart';

/// 교회 관리 화면 (관리자 전용)
/// 교회 기본 정보 편집 + 역할명 변경
class ChurchManageScreen extends ConsumerStatefulWidget {
  final String churchId;

  const ChurchManageScreen({super.key, required this.churchId});

  @override
  ConsumerState<ChurchManageScreen> createState() => _ChurchManageScreenState();
}

class _ChurchManageScreenState extends ConsumerState<ChurchManageScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _pastorController = TextEditingController();
  final _denominationController = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // build()가 아닌 didChangeDependencies에서 초기화하여 매 리빌드마다 초기화되는 문제 방지
    _initControllers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _pastorController.dispose();
    _denominationController.dispose();
    super.dispose();
  }

  /// 교회 상세 정보로 TextField 초기값 설정 (최초 1회)
  void _initControllers() {
    if (_initialized) return;
    final detail =
        ref.read(churchDetailViewModelProvider(widget.churchId)).valueOrNull;
    if (detail == null) return;
    _nameController.text = detail.church.name;
    _addressController.text = detail.church.address;
    _pastorController.text = detail.church.seniorPastor;
    _denominationController.text = detail.church.denomination;
    _initialized = true;
  }

  Future<void> _saveChurchInfo() async {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final pastor = _pastorController.text.trim();
    final denomination = _denominationController.text.trim();

    if (name.isEmpty || address.isEmpty || pastor.isEmpty || denomination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 항목을 입력해주세요.')),
      );
      return;
    }

    final success = await ref
        .read(churchManageViewModelProvider(widget.churchId).notifier)
        .updateChurchInfo(
          name: name,
          address: address,
          seniorPastor: pastor,
          denomination: denomination,
        );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? '교회 정보가 저장되었습니다.' : '저장 중 오류가 발생했습니다.'),
      ),
    );
  }

  Future<void> _showRenameDialog(ChurchRole role) async {
    final controller = TextEditingController(text: role.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.pureWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '역할명 변경',
          style: AppTextStyles.bodyLarge,
        ),
        content: SoftTextField(
          controller: controller,
          hintText: '새 역할명 입력',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              '취소',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: Text(
              '변경',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCoral,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    controller.dispose();

    if (newName == null || newName.isEmpty || !mounted) return;

    final success = await ref
        .read(churchManageViewModelProvider(widget.churchId).notifier)
        .updateRoleName(roleId: role.id, newName: newName);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? '역할명이 변경되었습니다.' : '변경 중 오류가 발생했습니다.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 관리자 권한 가드: 비관리자가 직접 URL/라우트로 접근 시 즉시 차단
    final detailAsync =
        ref.watch(churchDetailViewModelProvider(widget.churchId));
    final isAdmin = detailAsync.valueOrNull?.isAdmin ?? false;
    if (detailAsync.hasValue && !isAdmin) {
      // 다음 프레임에서 pop 처리 (build 중 즉시 Navigator 호출 금지)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('관리자만 접근할 수 있습니다.')),
          );
        }
      });
    }

    final manageState =
        ref.watch(churchManageViewModelProvider(widget.churchId));
    final rolesAsync =
        ref.watch(churchRolesProvider(widget.churchId));

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      appBar: AppBar(
        backgroundColor: AppColors.creamWhite,
        elevation: 0,
        title: const Text('교회 관리', style: AppTextStyles.headlineMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── 섹션 1: 교회 정보 편집 ──────────────────────────────
            _SectionHeader(
              icon: Icons.church_rounded,
              title: '교회 정보 편집',
              color: AppColors.softCoral,
            ),
            const SizedBox(height: 16),
            _ChurchInfoForm(
              nameController: _nameController,
              addressController: _addressController,
              pastorController: _pastorController,
              denominationController: _denominationController,
            ),
            const SizedBox(height: 16),
            BouncyButton(
              text: '저장',
              onPressed: manageState.isLoading ? null : _saveChurchInfo,
            ),
            const SizedBox(height: 32),

            // ─── 섹션 2: 역할 관리 ────────────────────────────────────
            _SectionHeader(
              icon: Icons.manage_accounts_rounded,
              title: '역할 관리',
              color: AppColors.sageGreen,
            ),
            const SizedBox(height: 16),
            _RolesSection(
              rolesAsync: rolesAsync,
              onRenameTap: _showRenameDialog,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.bodyLarge),
      ],
    );
  }
}

class _ChurchInfoForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController pastorController;
  final TextEditingController denominationController;

  const _ChurchInfoForm({
    required this.nameController,
    required this.addressController,
    required this.pastorController,
    required this.denominationController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SoftTextField(
          controller: nameController,
          hintText: '교회 이름',
          prefixIcon: const Icon(Icons.church_rounded, color: AppColors.textGrey),
        ),
        const SizedBox(height: 12),
        SoftTextField(
          controller: addressController,
          hintText: '주소',
          prefixIcon:
              const Icon(Icons.location_on_rounded, color: AppColors.textGrey),
        ),
        const SizedBox(height: 12),
        SoftTextField(
          controller: pastorController,
          hintText: '담임목사 성함',
          prefixIcon:
              const Icon(Icons.person_rounded, color: AppColors.textGrey),
        ),
        const SizedBox(height: 12),
        SoftTextField(
          controller: denominationController,
          hintText: '교단',
          prefixIcon:
              const Icon(Icons.category_rounded, color: AppColors.textGrey),
        ),
      ],
    );
  }
}

class _RolesSection extends StatelessWidget {
  final AsyncValue<List<ChurchRole>> rolesAsync;
  final void Function(ChurchRole role) onRenameTap;

  const _RolesSection({
    required this.rolesAsync,
    required this.onRenameTap,
  });

  @override
  Widget build(BuildContext context) {
    return rolesAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.softCoral),
      ),
      error: (_, _) => Text(
        '역할 목록을 불러오지 못했어요.',
        style: AppTextStyles.bodySmall,
      ),
      data: (roles) {
        if (roles.isEmpty) {
          return Text('등록된 역할이 없습니다.', style: AppTextStyles.bodySmall);
        }
        return Column(
          children: roles
              .map((role) => _RoleManageTile(role: role, onRenameTap: onRenameTap))
              .toList(),
        );
      },
    );
  }
}

class _RoleManageTile extends StatelessWidget {
  final ChurchRole role;
  final void Function(ChurchRole role) onRenameTap;

  const _RoleManageTile({
    required this.role,
    required this.onRenameTap,
  });

  Color get _levelColor {
    switch (role.level) {
      case 4:
        return AppColors.softCoral;
      case 3:
        return AppColors.warmTangerine;
      case 2:
        return AppColors.sageGreen;
      default:
        return AppColors.skyBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _levelColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role.name, style: AppTextStyles.bodyMedium),
                Text(
                  'Lv.${role.level}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_rounded, size: 18),
            color: AppColors.textGrey,
            onPressed: () => onRenameTap(role),
            tooltip: '역할명 변경',
          ),
        ],
      ),
    );
  }
}
