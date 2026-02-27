import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/clay_card.dart';

/// 마이페이지 프로필 헤더 섹션
///
/// 디자인 컨셉 (MYPAGE_PLAN §6.1):
/// - 둥근 아바타 이미지에 4px 두께의 Soft Indigo 보더로 Clay 질감
/// - 아바타 하단에 은은한 BoxShadow로 입체감(Tactile)
/// - 이름, 이메일(마스킹), 상태 메시지(bio), 교회 등록일 표시
class UserProfileHeader extends StatelessWidget {
  final String displayName;
  final String email;
  final String? photoUrl;
  final String? bio;
  final DateTime? registerDate;
  final VoidCallback onEditPressed;

  const UserProfileHeader({
    super.key,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.onEditPressed,
    this.bio,
    this.registerDate,
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

  // ─── 날짜 포맷 헬퍼 ─────────────────────────────────────────
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
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
          // ─── 프로필 수정 버튼 ───────────────────────────────
          _buildEditButton(),
        ],
      ),
    );
  }

  /// §6.1: 4px 두께의 Soft Lavender 보더 + 하단 그림자 입체감
  Widget _buildClayAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Clay 보더: 4px 두께의 Soft Lavender 계열
        border: Border.all(
          color: AppColors.softLavender,
          width: 4,
        ),
        // 입체감을 위한 이중 그림자
        boxShadow: [
          // 하단 메인 그림자 (깊이감)
          BoxShadow(
            color: AppColors.softLavender.withValues(alpha: 0.4),
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
        radius: 40,
        backgroundImage:
            photoUrl != null ? NetworkImage(photoUrl!) : null,
        backgroundColor: AppColors.sageGreen,
        child: photoUrl == null
            ? const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 40,
              )
            : null,
      ),
    );
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
            Icon(
              Icons.email_rounded,
              size: 14,
              color: AppColors.textGrey,
            ),
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
        // 교회 등록일
        if (registerDate != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 14,
                color: AppColors.textGrey,
              ),
              const SizedBox(width: 6),
              Text(
                '등록일 ${_formatDate(registerDate)}',
                style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
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

  Widget _buildEditButton() {
    return SizedBox(
      width: double.infinity,
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
    );
  }
}
