import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../bouncy_tap_wrapper.dart';

/// 범용 클레이 리스트 타일 (Phase 2 Core Component)
///
/// 기존 `UserMenuTile`(마이페이지 전용)을 범용화하여
/// 어느 화면의 리스트에서든 재사용할 수 있도록 파라미터를 유연화했습니다.
///
/// - 내부적으로 `BouncyTapWrapper`로 래핑되어 쫀득한 터치 인터랙션 제공
/// - `leading`을 직접 커스터마이즈하거나, `leadingIcon` + `leadingColor`로 간편하게 생성 가능
/// - `trailing`을 커스터마이즈하거나, 기본 chevron 아이콘 자동 표시
///
/// 사용법:
/// ```dart
/// ClayListTile(
///   leadingIcon: Icons.people_rounded,
///   leadingColor: AppColors.softLavender,
///   title: '내 다락방(공동체)',
///   subtitle: '소속 공동체 확인',
///   onTap: () => ...,
/// )
/// ```
class ClayListTile extends StatelessWidget {
  /// 좌측에 표시할 커스텀 위젯 (leading 직접 지정 시 leadingIcon/leadingColor 무시)
  final Widget? leading;

  /// 편의 파라미터: 아이콘 배지 자동 생성용
  final IconData? leadingIcon;

  /// 편의 파라미터: 아이콘 배지 색상
  final Color? leadingColor;

  /// 타일 제목 (필수)
  final String title;

  /// 타일 부제목 (선택)
  final String? subtitle;

  /// 우측에 표시할 커스텀 위젯 (기본: chevron 아이콘)
  final Widget? trailing;

  /// 탭 콜백
  final VoidCallback? onTap;

  /// 위험 동작(로그아웃, 삭제 등) 여부 — true이면 제목 색상이 Coral로 변경
  final bool isDestructive;

  /// 로딩 상태 — true이면 trailing이 CircularProgressIndicator로 교체
  final bool isLoading;

  /// 콘텐츠 패딩 커스터마이즈
  final EdgeInsetsGeometry? contentPadding;

  const ClayListTile({
    super.key,
    this.leading,
    this.leadingIcon,
    this.leadingColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
    this.isLoading = false,
    this.contentPadding,
  }) : assert(
         !(leading != null && leadingIcon != null),
         'leading과 leadingIcon을 동시에 지정할 수 없습니다. leading이 우선됩니다.',
       );

  @override
  Widget build(BuildContext context) {
    final titleColor = isDestructive ? AppColors.softCoral : AppColors.textDark;

    return BouncyTapWrapper(
      onTap: onTap,
      child: Padding(
        padding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            // ─── Leading (아이콘 배지 또는 커스텀 위젯) ───────────
            if (leading != null || leadingIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: leading ?? _buildDefaultLeading(),
              ),
            // ─── 타이틀 & 서브타이틀 ──────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            // ─── Trailing (화살표 / 로딩 / 커스텀) ───────────────
            _buildTrailing(),
          ],
        ),
      ),
    );
  }

  /// `leadingIcon` + `leadingColor`로 기본 아이콘 배지 생성
  Widget _buildDefaultLeading() {
    final iconColor = leadingColor ?? AppColors.softCoral;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(leadingIcon, color: iconColor, size: 22),
    );
  }

  /// Trailing 위젯 결정 로직
  Widget _buildTrailing() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.softCoral,
        ),
      );
    }

    return trailing ??
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: AppColors.textGrey.withValues(alpha: 0.5),
        );
  }
}
