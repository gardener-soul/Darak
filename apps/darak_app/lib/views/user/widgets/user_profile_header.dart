import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';
import '../../../widgets/common/core/clay_avatar.dart';

/// 마이페이지 프로필 헤더 섹션
///
/// 디자인 컨셉 (MYPAGE_PLAN §6.1):
/// - 둥근 아바타 이미지에 4px 두께의 Soft Indigo 보더로 Clay 질감
/// - 아바타 하단에 은은한 BoxShadow로 입체감(Tactile)
/// - 이름, 이메일(마스킹), 상태 메시지(bio), 함께한 지 N일째 표시
class UserProfileHeader extends StatelessWidget {
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? bio;
  final DateTime? registerDate;
  final VoidCallback onEditPressed;

  /// 교인 검색 탭 콜백
  final VoidCallback? onSearchTap;

  const UserProfileHeader({
    super.key,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.onEditPressed,
    this.bio,
    this.registerDate,
    this.onSearchTap,
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

  // ─── 날짜 포맷 헬퍼 (함께한 지 N일째) ────────────────────────
  String _formatJoinDays(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    // 시간 부분을 제거하고 날짜만 비교
    final today = DateTime(now.year, now.month, now.day);
    final joinDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(joinDate).inDays + 1;

    if (diff < 365) {
      return '함께한 지 ${diff}일째';
    } else {
      final years = diff ~/ 365;
      final days = diff % 365;
      if (days == 0) return '함께한 지 ${years}년째';
      return '함께한 지 ${years}년 ${days}일째';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      child: Column(
        children: [
          Row(
            children: [
              // ─── 클레이 아바타 (§6.1 사양) ──────────────────────
              _buildClayAvatar(),
              const SizedBox(width: 20),
              // ─── 사용자 정보 ────────────────────────────────────
              Expanded(child: _buildUserInfo()),
            ],
          ),
          // ─── 상태 메시지(bio) ────────────────────────────────
          if (bio != null && bio!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildBioSection(),
          ],
          const SizedBox(height: 20),
          // ─── 프로필 수정 + 교인 찾기 버튼 행 ───────────────
          _buildActionButtons(),
        ],
      ),
    );
  }

  /// §6.1: ClayAvatar 공통 컴포넌트로 교체 (Phase 3 Migration)
  Widget _buildClayAvatar() {
    return ClayAvatar(imageUrl: photoUrl, size: AvatarSize.medium);
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName,
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 4),
        // 이메일 (마스킹)
        Row(
          children: [
            Icon(Icons.email_rounded, size: 14, color: AppColors.textGrey),
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
        // 함께한 지 N일째 표시
        if (registerDate != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.favorite_rounded,
                size: 14,
                color: AppColors.softCoral,
              ),
              const SizedBox(width: 6),
              Text(
                _formatJoinDays(registerDate),
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 12,
                  color: AppColors.softCoral,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// 상태 메시지 영역: 연한 파스텔 배경의 말풍선 느낌
  Widget _buildBioSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.softLavender.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('💬', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              bio!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textDark,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// 프로필 수정 + 교인 찾기 버튼 행
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
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
        if (onSearchTap != null) ...[
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: onSearchTap,
            icon: const Icon(Icons.person_search_rounded, size: 18),
            label: const Text('교인 찾기'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.warmTangerine,
              side: const BorderSide(
                color: AppColors.warmTangerine,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: AppDecorations.buttonRadius,
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              textStyle: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
