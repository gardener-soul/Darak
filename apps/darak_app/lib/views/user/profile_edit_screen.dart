import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/bouncy_button.dart';
import '../../widgets/common/birth_date_picker_sheet.dart';
import '../../widgets/common/soft_text_field.dart';
import '../../widgets/common/clay_card.dart';
import '../../core/providers/user_providers.dart';
import '../../core/utils/string_utils.dart';
import '../../repositories/user_repository.dart';

/// 프로필 전체 정보 수정 화면 (전체 화면)
/// 온보딩에서 입력한 모든 정보(name, phone, birthDate, bio)를 수정할 수 있습니다.
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  DateTime? _selectedBirthDate;

  String? _nameError;
  String? _phoneError;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // 현재 유저 정보로 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userAsync = ref.read(currentUserProvider);
      userAsync.whenData((user) {
        if (user != null && mounted) {
          setState(() {
            _nameController.text = user.name;
            _phoneController.text = user.phone;
            _bioController.text = user.bio ?? '';
            _selectedBirthDate = user.birthDate;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  /// 생년월일 선택 바텀시트 표시 (한국 친화적 드럼 방식)
  void _selectBirthDate() {
    BirthDatePickerSheet.show(
      context,
      initialDate: _selectedBirthDate,
      onDateSelected: (date) => setState(() => _selectedBirthDate = date),
    );
  }

  /// 유효성 검사
  bool _validate() {
    String? nameError;
    String? phoneError;

    // 이름 검증
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      nameError = '이름을 입력해주세요.';
    } else if (name.length > 50) {
      nameError = '이름은 50자 이내로 입력해주세요.';
    }

    // 전화번호 검증
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      phoneError = '전화번호를 입력해주세요.';
    } else if (!StringUtils.isValidKoreanPhone(phone)) {
      phoneError = '올바른 전화번호 형식을 입력해주세요. (예: 010-1234-5678)';
    }

    setState(() {
      _nameError = nameError;
      _phoneError = phoneError;
    });

    // 생년월일 검증 (선택 사항이지만, 입력된 경우 유효성 체크)
    final birthDate = _selectedBirthDate;
    if (birthDate != null && !StringUtils.isValidBirthDate(birthDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('올바른 생년월일을 선택해주세요.'),
          backgroundColor: AppColors.softCoral,
        ),
      );
      return false;
    }

    return nameError == null && phoneError == null;
  }

  /// 프로필 업데이트 제출
  Future<void> _saveProfile() async {
    if (!_validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final uid = ref.read(currentUserIdProvider);
      if (uid == null) {
        throw Exception('로그인 정보를 찾을 수 없습니다.');
      }

      final userRepo = ref.read(userRepositoryProvider);
      await userRepo.updateUser(
        uid,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        birthDate: _selectedBirthDate,
        bio: _bioController.text.trim().isEmpty
            ? null
            : _bioController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('프로필이 수정되었습니다.'),
            backgroundColor: AppColors.sageGreen,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('프로필 수정 실패: ${e.toString()}'),
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
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('프로필 수정'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 스크롤 가능한 폼 영역
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ClayCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 섹션 제목
                      Text('내 정보 수정', style: AppTextStyles.headlineMedium),
                      const SizedBox(height: 8),
                      Text(
                        '변경된 정보는 즉시 반영됩니다',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 이름 필드
                      _buildFieldLabel('이름', isRequired: true),
                      const SizedBox(height: 8),
                      SoftTextField(
                        controller: _nameController,
                        hintText: '이름을 입력하세요',
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                      ),
                      if (_nameError != null) ...[
                        const SizedBox(height: 8),
                        _buildErrorText(_nameError!),
                      ],
                      const SizedBox(height: 24),

                      // 전화번호 필드
                      _buildFieldLabel('전화번호', isRequired: true),
                      const SizedBox(height: 8),
                      SoftTextField(
                        controller: _phoneController,
                        hintText: '010-0000-0000',
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                      if (_phoneError != null) ...[
                        const SizedBox(height: 8),
                        _buildErrorText(_phoneError!),
                      ],
                      const SizedBox(height: 24),

                      // 생년월일 필드
                      _buildFieldLabel('생년월일', isRequired: false),
                      const SizedBox(height: 8),
                      _buildBirthDateButton(),
                      const SizedBox(height: 24),

                      // 한 줄 소개 필드
                      _buildFieldLabel('한 줄 소개', isRequired: false),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppDecorations.defaultRadius,
                          boxShadow: AppDecorations.innerInputShadow,
                        ),
                        child: TextField(
                          controller: _bioController,
                          maxLines: 3,
                          maxLength: 200,
                          style: AppTextStyles.bodyMedium,
                          decoration: InputDecoration(
                            hintText: '나를 소개하는 한 줄을 작성해보세요',
                            border: OutlineInputBorder(
                              borderRadius: AppDecorations.defaultRadius,
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: AppDecorations.defaultRadius,
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: AppDecorations.defaultRadius,
                              borderSide: const BorderSide(
                                color: AppColors.softCoral,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(20),
                            filled: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 하단 고정 버튼
            Padding(
              padding: const EdgeInsets.all(24),
              child: BouncyButton(
                onPressed: _isSubmitting ? null : _saveProfile,
                text: _isSubmitting ? '저장 중...' : '저장',
                icon: const Icon(Icons.check_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, {required bool isRequired}) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.bodyLarge),
        if (isRequired) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.softCoral),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorText(String error) {
    return Row(
      children: [
        const Icon(
          Icons.error_outline_rounded,
          size: 16,
          color: AppColors.softCoral,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            error,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.softCoral),
          ),
        ),
      ],
    );
  }

  Widget _buildBirthDateButton() {
    return GestureDetector(
      onTap: _selectBirthDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppDecorations.defaultRadius,
          boxShadow: AppDecorations.innerInputShadow,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.textGrey,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              _selectedBirthDate != null
                  ? '${_selectedBirthDate!.year}년 ${_selectedBirthDate!.month}월 ${_selectedBirthDate!.day}일'
                  : '생년월일을 선택하세요 (선택)',
              style: AppTextStyles.bodyMedium.copyWith(
                color: _selectedBirthDate != null
                    ? AppColors.textDark
                    : AppColors.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
