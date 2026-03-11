import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

/// 클레이 아바타 크기 Variant (Enum 패턴)
///
/// 컨벤션 규칙: 버튼이나 아바타 생성 시 크기를 Enum으로 받아
/// 내부에서 토큰을 매핑합니다.
enum AvatarSize {
  /// 리스트 아이템, 댓글 등 소형 아바타 (반지름 24px)
  small(24),

  /// 프로필 헤더 등 중간 아바타 (반지름 40px)
  medium(40),

  /// 프로필 상세, 풀스크린 등 대형 아바타 (반지름 56px)
  large(56);

  const AvatarSize(this.radius);

  /// CircleAvatar의 반지름
  final double radius;

  /// 폴백 아이콘 크기 (반지름과 동일하게)
  double get iconSize => radius;
}

/// 입체감 있는 클레이모피즘 아바타 (Phase 1 Core Component)
///
/// DESIGN.md§3의 Clay 질감을 구현합니다:
/// - 4px 두께의 Soft Lavender 보더
/// - 이중 BoxShadow (하단 깊이감 + 상단 하이라이트)
/// - 크기별 Variant 지원 (small/medium/large)
///
/// `imageUrl`이 null이면 `Icons.person_rounded` 폴백 아이콘을 표시합니다.
///
/// 사용법:
/// ```dart
/// ClayAvatar(
///   imageUrl: user.photoUrl,
///   size: AvatarSize.medium,
/// )
/// ```
class ClayAvatar extends StatelessWidget {
  final String? imageUrl;
  final AvatarSize size;
  final Color? borderColor;
  final Color? backgroundColor;
  final Widget? fallbackIcon;

  const ClayAvatar({
    super.key,
    this.imageUrl,
    this.size = AvatarSize.medium,
    this.borderColor,
    this.backgroundColor,
    this.fallbackIcon,
  });

  /// 유효한 이미지 URL인지 판별 (빈 문자열, null 방어)
  bool get _hasValidImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? AppColors.softLavender;
    final effectiveBackgroundColor = backgroundColor ?? AppColors.sageGreen;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // §6.1: 4px 두께의 Clay 보더
        border: Border.all(color: effectiveBorderColor, width: 4),
        // 이중 그림자로 입체감(Tactile) 연출
        boxShadow: [
          // 하단 메인 그림자 (깊이감)
          BoxShadow(
            color: effectiveBorderColor.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          // 상단 하이라이트 (톡 튀어나온 듯한 느낌)
          BoxShadow(
            color: AppColors.clayHighlight.withValues(alpha: 0.8),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: size.radius,
        backgroundImage: _hasValidImage ? NetworkImage(imageUrl!) : null,
        // 🚨 CRITICAL FIX: 이미지 로딩 실패(404, 만료 URL 등) 시 크래시 방지
        onBackgroundImageError: _hasValidImage
            ? (exception, stackTrace) {
                debugPrint('ClayAvatar image load failed: $exception');
              }
            : null,
        backgroundColor: effectiveBackgroundColor,
        child: !_hasValidImage
            ? fallbackIcon ??
                  Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: size.iconSize,
                  )
            : null,
      ),
    );
  }
}
