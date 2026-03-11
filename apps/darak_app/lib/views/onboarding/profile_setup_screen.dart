import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/bouncy_button.dart';
import '../../viewmodels/onboarding/onboarding_view_model.dart';
import '../../core/utils/string_utils.dart';
import 'widgets/profile_form_section.dart';

/// 프로필 정보 입력 화면
/// 온보딩 과정에서 사용자의 기본 정보(이름, 전화번호, 생년월일)를 입력받습니다.
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _selectedBirthDate;

  String? _nameError;
  String? _phoneError;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// 생년월일 선택 DatePicker 표시
  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.softCoral,
              onPrimary: Colors.white,
              surface: AppColors.pureWhite,
              onSurface: AppColors.textDark,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.pureWhite,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  /// 유효성 검사
  bool _validate() {
    setState(() {
      _nameError = null;
      _phoneError = null;
    });

    bool isValid = true;

    // 이름 검증
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _nameError = '이름을 입력해주세요.';
      });
      isValid = false;
    } else if (name.length > 50) {
      setState(() {
        _nameError = '이름은 50자 이내로 입력해주세요.';
      });
      isValid = false;
    }

    // 전화번호 검증
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      setState(() {
        _phoneError = '전화번호를 입력해주세요.';
      });
      isValid = false;
    } else if (!StringUtils.isValidKoreanPhone(phone)) {
      setState(() {
        _phoneError = '올바른 전화번호 형식을 입력해주세요. (예: 010-1234-5678)';
      });
      isValid = false;
    }

    // 생년월일 검증 (선택 사항이지만, 입력된 경우 유효성 체크)
    if (_selectedBirthDate != null &&
        !StringUtils.isValidBirthDate(_selectedBirthDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('올바른 생년월일을 선택해주세요.'),
          backgroundColor: AppColors.softCoral,
        ),
      );
      isValid = false;
    }

    return isValid;
  }

  /// 프로필 저장 후 온보딩 완료
  Future<void> _goToNext() async {
    if (!_validate()) return;

    // ViewModel에 데이터 저장
    final viewModel = ref.read(onboardingViewModelProvider.notifier);
    viewModel.updateProfileData(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      birthDate: _selectedBirthDate,
    );

    // 바로 Firestore에 저장 후 완료
    try {
      await viewModel.submitOnboarding();
      // AuthWrapper가 user.phone.isNotEmpty 조건으로 HomeScreen을 자동 분기
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.softCoral,
          ),
        );
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
        title: const Text('프로필 설정'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 스크롤 가능한 폼 영역
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ProfileFormSection(
                  nameController: _nameController,
                  phoneController: _phoneController,
                  selectedBirthDate: _selectedBirthDate,
                  onBirthDateTap: _selectBirthDate,
                  nameError: _nameError,
                  phoneError: _phoneError,
                ),
              ),
            ),

            // 하단 고정 버튼
            Padding(
              padding: const EdgeInsets.all(24),
              child: BouncyButton(
                onPressed: _goToNext,
                text: '완료',
                icon: const Icon(Icons.check_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
