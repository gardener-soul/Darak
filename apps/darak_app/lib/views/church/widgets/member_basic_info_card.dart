import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/user.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/core/bouncy_icon_btn.dart';
import '../../../widgets/common/core/soft_chip.dart';

/// 순원 상세 화면 - 기본 정보 섹션
/// 생일, 등록일, 연락처, 동아리를 ClayCard 안에 표시합니다.
class MemberBasicInfoCard extends StatelessWidget {
  final User user;
  final Map<String, String> clubNames; // clubId → clubName

  const MemberBasicInfoCard({
    super.key,
    required this.user,
    this.clubNames = const {},
  });

  @override
  Widget build(BuildContext context) {
    final hasPhone = user.phone.isNotEmpty;

    return ClayCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 생일
          _InfoRow(
            icon: Icons.cake_rounded,
            iconColor: AppColors.softCoral,
            label: '생일',
            value: user.birthDate != null
                ? DateFormat('M월 d일').format(user.birthDate!)
                : '미등록',
          ),
          const Divider(color: AppColors.divider, height: 20),

          // 교회 등록일
          _InfoRow(
            icon: Icons.church_rounded,
            iconColor: AppColors.warmTangerine,
            label: '등록일',
            value: user.registerDate != null
                ? DateFormat('yyyy년 M월 d일').format(user.registerDate!)
                : '미등록',
          ),
          const Divider(color: AppColors.divider, height: 20),

          // 연락처
          Row(
            children: [
              Icon(Icons.phone_rounded, color: AppColors.sageGreen, size: 20),
              const SizedBox(width: 12),
              Text('연락처', style: AppTextStyles.bodySmall),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hasPhone ? user.phone : '미등록',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: hasPhone ? AppColors.textDark : AppColors.textGrey,
                  ),
                ),
              ),
              // 전화 버튼
              BouncyIconBtn(
                icon: Icons.call_rounded,
                color: hasPhone ? AppColors.sageGreen : AppColors.disabled,
                size: IconBtnSize.small,
                onTap: hasPhone ? () => _launchPhone(context, user.phone) : null,
              ),
              const SizedBox(width: 4),
              // 문자 버튼
              BouncyIconBtn(
                icon: Icons.message_rounded,
                color: hasPhone ? AppColors.softCoral : AppColors.disabled,
                size: IconBtnSize.small,
                onTap: hasPhone ? () => _launchSms(context, user.phone) : null,
              ),
            ],
          ),
          const Divider(color: AppColors.divider, height: 20),

          // 소속 동아리
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.groups_rounded,
                  color: AppColors.softLavender, size: 20),
              const SizedBox(width: 12),
              Text('동아리', style: AppTextStyles.bodySmall),
              const SizedBox(width: 12),
              Expanded(
                child: _buildClubChips(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClubChips() {
    final ids = user.clubIds;
    if (ids == null || ids.isEmpty) {
      return Text(
        '없음',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
      );
    }
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: ids.map((id) {
        final name = clubNames[id] ?? id;
        return SoftChip(
          label: name,
          color: AppColors.softLavender,
          isSelected: true,
        );
      }).toList(),
    );
  }

  Future<void> _launchPhone(BuildContext context, String phone) =>
      _launchUri(context, Uri.parse('tel:$phone'));

  Future<void> _launchSms(BuildContext context, String phone) =>
      _launchUri(context, Uri.parse('sms:$phone'));

  Future<void> _launchUri(BuildContext context, Uri uri) async {
    if (!await canLaunchUrl(uri)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이 기기에서 지원하지 않는 기능이에요')),
      );
      return;
    }
    await launchUrl(uri);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.bodySmall),
        const SizedBox(width: 12),
        Expanded(
          child: Text(value, style: AppTextStyles.bodyMedium),
        ),
      ],
    );
  }
}
