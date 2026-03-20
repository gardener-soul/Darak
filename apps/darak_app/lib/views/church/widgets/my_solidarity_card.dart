import 'package:flutter/material.dart';

import '../../../models/church_member.dart';
import '../../../models/village_with_groups.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';

/// 내 소속 카드 위젯
/// 공동체 탭 상단에서 현재 로그인 유저의 마을/다락방 소속을 요약 표시
class MySolidarityCard extends StatelessWidget {
  final ChurchMember currentMember;
  final List<VillageWithGroups> villages;

  const MySolidarityCard({
    super.key,
    required this.currentMember,
    required this.villages,
  });

  /// 소속 마을 이름 (없으면 null)
  String? get _villageName {
    if (currentMember.villageId == null) return null;
    try {
      return villages
          .firstWhere((v) => v.village.id == currentMember.villageId)
          .village
          .name;
    } catch (_) {
      return null;
    }
  }

  /// 소속 다락방 이름 (없으면 null)
  String? get _groupName {
    if (currentMember.groupId == null) return null;
    for (final v in villages) {
      try {
        return v.groups.firstWhere((g) => g.id == currentMember.groupId).name;
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final villageName = _villageName;
    final groupName = _groupName;

    // 소속이 전혀 없으면 표시 안 함
    if (villageName == null && groupName == null) return const SizedBox.shrink();

    return ClayCard(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.softCoral.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person_pin_rounded,
              color: AppColors.softCoral,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('내 소속', style: AppTextStyles.bodySmall),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (villageName != null)
                      _SolidarityChip(
                        label: villageName,
                        color: AppColors.softCoral,
                      ),
                    if (villageName != null && groupName != null)
                      const SizedBox(width: 8),
                    if (groupName != null)
                      _SolidarityChip(
                        label: groupName,
                        color: AppColors.warmTangerine,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

class _SolidarityChip extends StatelessWidget {
  final String label;
  final Color color;

  const _SolidarityChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
