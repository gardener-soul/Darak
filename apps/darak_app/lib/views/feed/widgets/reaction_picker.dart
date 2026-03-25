import 'package:flutter/material.dart';

import '../../../models/feed/reaction_type.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/bouncy_tap_wrapper.dart';

/// 반응 선택 팝오버 — 5가지 반응 타입 선택 UI
class ReactionPicker extends StatelessWidget {
  final ReactionType? currentReaction;
  final void Function(ReactionType) onSelect;

  const ReactionPicker({
    super.key,
    this.currentReaction,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.clayShadow.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ReactionType.values.map((type) {
          final isSelected = currentReaction == type;
          return BouncyTapWrapper(
            onTap: () => onSelect(type),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(8),
              decoration: isSelected
                  ? BoxDecoration(
                      color: AppColors.softLavender.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(20),
                    )
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(type.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(height: 2),
                  Text(
                    type.label,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10,
                      color: isSelected
                          ? AppColors.textDark
                          : AppColors.textGrey,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
