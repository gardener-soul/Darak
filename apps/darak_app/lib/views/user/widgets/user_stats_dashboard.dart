import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// 마이페이지 통계 대시보드 (MYPAGE_PLAN §6.2)
///
/// 디자인 사양:
/// - 배경: 연한 오프화이트/파스텔 솔리드 톤 (순백색 아님)
/// - borderRadius: 24px
/// - padding: EdgeInsets.all(24)
/// - 숫자: 아주 크고 볼드(FontWeight.w900)
/// - 라벨: Soft Gray로 작게 배치하여 시각적 위계 확립
@Deprecated(
  'SpiritualDashboardCard로 대체됨. 이 위젯은 다음 릴리즈에서 삭제될 예정입니다.',
)
class UserStatsDashboard extends StatelessWidget {
  final String? groupName;
  final int? attendanceTotal;
  final int? attendanceAttended;
  final int prayerRequestCount;

  const UserStatsDashboard({
    super.key,
    this.groupName,
    this.attendanceTotal,
    this.attendanceAttended,
    this.prayerRequestCount = 0,
  });

  /// 출석률 계산 (0~100%)
  String get _attendanceRate {
    if (attendanceTotal == null || attendanceTotal == 0) return '--';
    if (attendanceAttended == null) return '--';
    final rate = (attendanceAttended! / attendanceTotal! * 100).round();
    return '$rate%';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24), // §6.2: 최소 24px
      decoration: BoxDecoration(
        // §6.2: 순백색 대신 연한 오프화이트 파스텔 배경
        color: const Color(0xFFF8F6FF), // 아주 연한 라벤더 오프화이트
        borderRadius: BorderRadius.circular(24), // §6.2: 24px 강제
        boxShadow: [
          BoxShadow(
            color: AppColors.clayShadow.withValues(alpha: 0.4),
            offset: const Offset(6, 6),
            blurRadius: 12,
          ),
          BoxShadow(
            color: AppColors.clayHighlight.withValues(alpha: 0.9),
            offset: const Offset(-4, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          // 출석률
          Expanded(
            child: _StatItem(
              icon: Icons.check_circle_rounded,
              iconColor: AppColors.sageGreen,
              value: _attendanceRate,
              label: '출석률',
            ),
          ),
          _buildVerticalDivider(),
          // 기도 제목 수
          Expanded(
            child: _StatItem(
              icon: Icons.favorite_rounded,
              iconColor: AppColors.softCoral,
              value: '$prayerRequestCount건',
              label: '기도 제목',
            ),
          ),
          _buildVerticalDivider(),
          // 소속 다락방
          Expanded(
            child: _StatItem(
              icon: Icons.people_rounded,
              iconColor: AppColors.softLavender,
              value: groupName ?? '--',
              label: '다락방',
              isSmallValue: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 48,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: AppColors.divider.withValues(alpha: 0.5),
    );
  }
}

/// 개별 통계 아이템 위젯 (내부 전용)
class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool isSmallValue;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.isSmallValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 아이콘 배지
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(height: 12),
        // §6.2: 숫자는 아주 크고 볼드하게 (w900)
        Text(
          value,
          style: isSmallValue
              ? AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                )
              : AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // §6.2: 라벨은 Soft Gray로 작게
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 12,
            color: AppColors.textGrey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
