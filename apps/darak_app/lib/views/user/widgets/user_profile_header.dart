import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../../../widgets/common/clay_card.dart';

class UserProfileHeader extends StatelessWidget {
  final String displayName;
  final String email;
  final String? photoUrl;
  final VoidCallback onEditPressed;

  const UserProfileHeader({
    super.key,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.onEditPressed,
  });

  // ─── 이메일 마스킹 헬퍼 ─────────────────────────────────────
  String _maskEmail(String email) {
    if (email.isEmpty) return '';
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return '${name[0]}*@$domain';
    return '${name.substring(0, 2)}${'*' * (name.length - 2)}@$domain';
  }

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      child: Column(
        children: [
          Row(
            children: [
              // 아바타
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.softCoral.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: photoUrl != null
                      ? NetworkImage(photoUrl!)
                      : null,
                  backgroundColor: AppColors.sageGreen,
                  child: photoUrl == null
                      ? const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 40,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 20),
              // 이름 / 이메일
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.email_rounded,
                          size: 14,
                          color: AppColors.textGrey,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            _maskEmail(email),
                            style: AppTextStyles.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 프로필 수정 버튼
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onEditPressed,
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text('프로필 수정'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.softCoral,
                side: const BorderSide(color: AppColors.softCoral, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: AppDecorations.buttonRadius,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
