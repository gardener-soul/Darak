import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/address_search_service.dart';
import '../../theme/app_theme.dart';
import '../../viewmodels/church/church_registration_viewmodel.dart';
import '../../widgets/common/bouncy_button.dart';
import '../../widgets/common/bouncy_tap_wrapper.dart';
import '../../widgets/common/clay_card.dart';
import '../../widgets/common/soft_text_field.dart';
import 'church_pending_screen.dart';

/// 교회 등록 신청 폼 화면.
/// 교회 이름, 주소, 담임목사, 교단, 신청 메모를 입력받아 Firestore에 저장합니다.
class ChurchRegistrationScreen extends ConsumerStatefulWidget {
  const ChurchRegistrationScreen({super.key});

  @override
  ConsumerState<ChurchRegistrationScreen> createState() =>
      _ChurchRegistrationScreenState();
}

class _ChurchRegistrationScreenState
    extends ConsumerState<ChurchRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _pastorController = TextEditingController();
  final _memoController = TextEditingController();
  final _customDenominationController = TextEditingController();
  // 매 호출마다 새 인스턴스 생성을 방지하기 위해 State 필드로 관리
  final _addressSearchService = AddressSearchService();

  String? _selectedDenomination;
  bool _isCustomDenomination = false;

  bool get _isFormValid {
    final denomination = _isCustomDenomination
        ? _customDenominationController.text.trim()
        : _selectedDenomination;
    return _nameController.text.trim().isNotEmpty &&
        _addressController.text.trim().isNotEmpty &&
        _pastorController.text.trim().isNotEmpty &&
        (denomination?.isNotEmpty ?? false) &&
        _memoController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _pastorController.dispose();
    _memoController.dispose();
    _customDenominationController.dispose();
    super.dispose();
  }

  Future<void> _openAddressSearch() async {
    final result = await _addressSearchService.searchAddress(context);
    if (!mounted) return;

    if (result != null) {
      _addressController.text = result.roadAddress;
      setState(() {});
    }
  }

  Future<void> _submitRegistration() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_isFormValid) return;

    // CRITICAL-01: bang operator 제거 — null일 경우 빈 문자열로 안전 처리
    final denomination = _isCustomDenomination
        ? _customDenominationController.text.trim()
        : (_selectedDenomination ?? '');

    // _isFormValid를 통과했더라도 race condition 방어
    if (denomination.isEmpty) return;

    final churchId = await ref
        .read(churchRegistrationViewModelProvider.notifier)
        .submit(
          name: _nameController.text.trim(),
          address: _addressController.text.trim(),
          seniorPastor: _pastorController.text.trim(),
          denomination: denomination,
          requestMemo: _memoController.text.trim(),
        );

    if (!mounted) return;

    if (churchId != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ChurchPendingScreen(churchId: churchId),
        ),
      );
    } else {
      final vmState = ref.read(churchRegistrationViewModelProvider);
      final errorMsg = vmState.error?.toString().replaceAll(RegExp(r'^Exception:\s*'), '') ?? '등록 신청 중 오류가 발생했습니다.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(churchRegistrationViewModelProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      appBar: AppBar(
        backgroundColor: AppColors.creamWhite,
        elevation: 0,
        title: Text('교회 등록 신청', style: AppTextStyles.bodyLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _RegistrationInfoCard(),
                      const SizedBox(height: 24),

                      const _SectionLabel('교회 이름 *'),
                      const SizedBox(height: 8),
                      SoftTextField(
                        controller: _nameController,
                        hintText: '예) 다락방교회',
                        prefixIcon: const Icon(Icons.church_rounded),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),

                      const _SectionLabel('주소 *'),
                      const SizedBox(height: 8),
                      _AddressRow(
                        controller: _addressController,
                        onSearchTap: _openAddressSearch,
                        onChanged: () => setState(() {}),
                      ),
                      const SizedBox(height: 16),

                      const _SectionLabel('담임목사 성함 *'),
                      const SizedBox(height: 8),
                      SoftTextField(
                        controller: _pastorController,
                        hintText: '예) 홍길동',
                        prefixIcon: const Icon(Icons.person_rounded),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 16),

                      const _SectionLabel('교단 *'),
                      const SizedBox(height: 8),
                      _DenominationSelector(
                        selectedDenomination: _selectedDenomination,
                        isCustomDenomination: _isCustomDenomination,
                        customController: _customDenominationController,
                        onChanged: (selected, isCustom) {
                          setState(() {
                            _selectedDenomination = selected;
                            _isCustomDenomination = isCustom;
                          });
                        },
                        onCustomChanged: () => setState(() {}),
                      ),
                      const SizedBox(height: 16),

                      const _SectionLabel('신청 메모 * (최대 300자)'),
                      const SizedBox(height: 8),
                      SoftTextField(
                        controller: _memoController,
                        hintText: '교회 소개나 담당자 연락처 등을 자유롭게 적어주세요',
                        keyboardType: TextInputType.multiline,
                        minLines: 4,
                        maxLines: 8,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(300),
                        ],
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 6),
                      // 글자 수 카운터: 280자 이상이면 경고색(softCoral)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${_memoController.text.length}/300',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: _memoController.text.length >= 280
                                ? AppColors.softCoral
                                : AppColors.textGrey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // ─── 하단 고정 제출 버튼 ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.softCoral,
                      ),
                    )
                  : BouncyButton(
                      text: '등록 신청하기',
                      icon: const Icon(Icons.send_rounded),
                      isFullWidth: true,
                      color: AppColors.softCoral,
                      onPressed: _isFormValid ? _submitRegistration : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 분리된 위젯들 ──────────────────────────────────────────────────────────

/// 상단 관리자 검토 안내 카드 (CRITICAL-03: Extract Widget)
class _RegistrationInfoCard extends StatelessWidget {
  const _RegistrationInfoCard();

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      color: AppColors.warmTangerine.withValues(alpha: 0.15),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.warmTangerine),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '등록 신청 후 관리자 검토를 거쳐 승인됩니다.\n승인까지 영업일 기준 1~3일이 소요됩니다.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}

/// 주소 입력 필드 + 검색 버튼 행
class _AddressRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearchTap;
  final VoidCallback onChanged;

  const _AddressRow({
    required this.controller,
    required this.onSearchTap,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SoftTextField(
            controller: controller,
            hintText: '검색 버튼을 눌러 주소를 입력하세요',
            prefixIcon: const Icon(Icons.location_on_rounded),
            onChanged: (_) => onChanged(),
          ),
        ),
        const SizedBox(width: 12),
        _CompactSearchButton(onTap: onSearchTap),
      ],
    );
  }
}

/// 주소 행 전용 소형 검색 버튼.
/// SoftTextField(contentPadding vertical:20) 높이에 맞춰 BouncyButton보다 compact하게 설계.
class _CompactSearchButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CompactSearchButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BouncyTapWrapper(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.softCoral,
          borderRadius: AppDecorations.buttonRadius,
          boxShadow: [
            BoxShadow(
              color: Color.alphaBlend(
                Colors.black.withValues(alpha: 0.2),
                AppColors.softCoral,
              ),
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
            BoxShadow(
              color: AppColors.softCoral.withValues(alpha: 0.4),
              offset: const Offset(0, 8),
              blurRadius: 16,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 6),
            Text(
              '검색',
              style: AppTextStyles.buttonLabel.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

/// 교단 선택 필터칩 + 직접 입력 토글 위젯
class _DenominationSelector extends StatelessWidget {
  final String? selectedDenomination;
  final bool isCustomDenomination;
  final TextEditingController customController;
  final void Function(String? selected, bool isCustom) onChanged;
  final VoidCallback onCustomChanged;

  static const _customLabel = '직접 입력';
  static const _denominations = [
    '예장 합동',
    '예장 통합',
    '기감',
    '기침',
    '기성',
    '침례회',
    '순복음',
    _customLabel,
  ];

  const _DenominationSelector({
    required this.selectedDenomination,
    required this.isCustomDenomination,
    required this.customController,
    required this.onChanged,
    required this.onCustomChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _denominations.map((d) {
            final isSelected = selectedDenomination == d;
            return FilterChip(
              label: Text(d),
              selected: isSelected,
              backgroundColor: AppColors.pureWhite,
              selectedColor: AppColors.softCoral.withValues(alpha: 0.15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide(
                color: isSelected ? AppColors.softCoral : AppColors.divider,
                width: isSelected ? 1.5 : 1,
              ),
              labelStyle: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.softCoral : AppColors.textDark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              onSelected: (selected) {
                onChanged(
                  selected ? d : null,
                  selected && d == _customLabel,
                );
              },
            );
          }).toList(),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isCustomDenomination
              ? Padding(
                  key: const ValueKey('custom_denomination'),
                  padding: const EdgeInsets.only(top: 12),
                  child: SoftTextField(
                    controller: customController,
                    hintText: '교단명을 직접 입력해주세요',
                    onChanged: (_) => onCustomChanged(),
                  ),
                )
              : const SizedBox.shrink(
                  key: ValueKey('denomination_hidden'),
                ),
        ),
      ],
    );
  }
}

/// 각 입력 필드 위에 표시되는 섹션 레이블
class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
