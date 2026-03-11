import 'package:flutter/material.dart';

import '../../../models/church.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/bouncy_button.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import '../../../widgets/common/clay_card.dart';

/// 교회 목록 화면에 표시되는 개별 교회 카드.
/// [isRegistered]가 true이면 '등록됨' 뱃지를, false이면 '교인 등록' 버튼을 표시합니다.
class ChurchCard extends StatelessWidget {
  final Church church;
  final bool isRegistered;
  final VoidCallback? onRegisterTap;

  const ChurchCard({
    super.key,
    required this.church,
    this.isRegistered = false,
    this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyTapWrapper(
      scaleDown: 0.97,
      onTap: null, // 카드 자체 탭은 미사용 — 우측 버튼으로만 액션
      child: ClayCard(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          children: [
            const _ChurchIconContainer(),
            const SizedBox(width: 16),
            Expanded(child: _ChurchInfo(church: church)),
            const SizedBox(width: 12),
            if (isRegistered)
              const _RegisteredBadge()
            else
              BouncyButton(
                text: '교인 등록',
                isFullWidth: false,
                color: AppColors.softCoral,
                onPressed: onRegisterTap,
              ),
          ],
        ),
      ),
    );
  }
}

class _ChurchIconContainer extends StatelessWidget {
  const _ChurchIconContainer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.skyBlue.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.church_rounded, color: AppColors.skyBlue, size: 28),
    );
  }
}

class _ChurchInfo extends StatelessWidget {
  final Church church;

  const _ChurchInfo({required this.church});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                church.name,
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            _DenominationBadge(denomination: church.denomination),
          ],
        ),
        const SizedBox(height: 4),
        Text('담임 ${church.seniorPastor} 목사', style: AppTextStyles.bodySmall),
        const SizedBox(height: 2),
        Row(
          children: [
            const Icon(Icons.location_on_rounded, size: 12, color: AppColors.textGrey),
            const SizedBox(width: 2),
            Expanded(
              child: Text(
                church.address,
                style: AppTextStyles.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DenominationBadge extends StatelessWidget {
  final String denomination;

  const _DenominationBadge({required this.denomination});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.softLavender,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        denomination,
        style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
      ),
    );
  }
}

class _RegisteredBadge extends StatelessWidget {
  const _RegisteredBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.sageGreen.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.sageGreen, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.sageGreen),
          const SizedBox(width: 4),
          Text(
            '등록됨',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.sageGreen,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
