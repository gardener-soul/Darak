import 'package:flutter/material.dart';

import '../../../models/church.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';
import '../../../widgets/common/clay_card.dart';

/// 교회 목록 화면에 표시되는 개별 교회 카드.
/// [isRegistered]가 true이면 '등록됨' 뱃지를, false이면 '등록' 버튼을 표시합니다.
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
    return ClayCard(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _ChurchInfo(church: church)),
          const SizedBox(width: 12),
          if (isRegistered)
            const _RegisteredBadge()
          else
            _RegisterButton(onTap: onRegisterTap),
        ],
      ),
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

/// 컴팩트 등록 버튼. BouncyButton보다 패딩을 줄여 카드 정보 영역을 침범하지 않습니다.
class _RegisterButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _RegisterButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return BouncyTapWrapper(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isEnabled
              ? AppColors.softCoral
              : AppColors.softCoral.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.softCoral.withValues(alpha: 0.35),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Text(
          '등록',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.pureWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
