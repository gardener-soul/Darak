import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/soft_text_field.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../core/utils/phone_formatter.dart';

/// 프로필 입력 폼 섹션 위젯
class ProfileFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final DateTime? selectedBirthDate;
  final VoidCallback onBirthDateTap;
  final String? nameError;
  final String? phoneError;

  const ProfileFormSection({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.selectedBirthDate,
    required this.onBirthDateTap,
    this.nameError,
    this.phoneError,
  });

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          Text(
            '기본 정보를 입력해주세요',
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '다락방 멤버들과 소통하기 위한 정보입니다',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 32),

          // 이름 필드 (필수)
          _buildFieldLabel('이름', isRequired: true),
          const SizedBox(height: 8),
          SoftTextField(
            controller: nameController,
            hintText: '이름을 입력하세요',
            keyboardType: TextInputType.name,
            prefixIcon: const Icon(Icons.person_outline_rounded),
          ),
          if (nameError != null) ...[
            const SizedBox(height: 8),
            _buildErrorText(nameError!),
          ],
          const SizedBox(height: 24),

          // 전화번호 필드 (필수)
          _buildFieldLabel('전화번호', isRequired: true),
          const SizedBox(height: 8),
          SoftTextField(
            controller: phoneController,
            hintText: '010-0000-0000',
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_outlined),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
              PhoneNumberFormatter(),
            ],
          ),
          if (phoneError != null) ...[
            const SizedBox(height: 8),
            _buildErrorText(phoneError!),
          ],
          const SizedBox(height: 24),

          // 생년월일 필드 (선택)
          _buildFieldLabel('생년월일', isRequired: false),
          const SizedBox(height: 8),
          _buildBirthDateButton(context),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, {required bool isRequired}) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge,
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          Text(
            '*',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.softCoral,
            ),
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
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.softCoral,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBirthDateButton(BuildContext context) {
    final birthDate = selectedBirthDate;

    return GestureDetector(
      onTap: onBirthDateTap,
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
              birthDate != null
                  ? '${birthDate.year}년 ${birthDate.month}월 ${birthDate.day}일'
                  : '생년월일을 선택하세요 (선택)',
              style: AppTextStyles.bodyMedium.copyWith(
                color: birthDate != null
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
