import 'package:flutter/material.dart';

import '../../../models/church.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';

/// 교회 기본 정보 헤더 카드
/// 교회 이름, 교단, 담임목사, 주소 표시
class ChurchInfoHeader extends StatelessWidget {
  final Church church;

  const ChurchInfoHeader({super.key, required this.church});

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.softCoral.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.church_rounded,
                  color: AppColors.softCoral,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      church.name,
                      style: AppTextStyles.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      church.denomination,
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider, height: 1),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.person_rounded,
            label: '담임목사',
            value: church.seniorPastor,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.location_on_rounded,
            label: '주소',
            value: church.address,
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textGrey),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: AppTextStyles.bodySmall,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }
}
