import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/user_providers.dart';
import '../../../repositories/user_repository.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/common/core/app_bottom_sheet.dart';

/// 프로필 수정 바텀시트 (bio 상태 메시지 수정)
///
/// Phase 1에서 구축한 UserRepository를 통해
/// Firestore에 실제로 bio를 저장합니다.
class ProfileEditBottomSheet extends ConsumerStatefulWidget {
  final String? currentBio;
  final VoidCallback? onSave;

  const ProfileEditBottomSheet({super.key, this.currentBio, this.onSave});

  @override
  ConsumerState<ProfileEditBottomSheet> createState() =>
      _ProfileEditBottomSheetState();
}

class _ProfileEditBottomSheetState
    extends ConsumerState<ProfileEditBottomSheet> {
  late TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentBio ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ─── bio 저장 로직 ─────────────────────────────────────────
  Future<void> _saveBio() async {
    final uid = ref.read(currentUserIdProvider);
    if (uid == null) return;

    final newBio = _controller.text.trim();

    // ⚠️ 경고 대응: 기존 입력값과 똑같다면 불필요한 Firestore 쓰기 없이 조기 종료
    if (newBio == (widget.currentBio ?? '')) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref
          .read(userRepositoryProvider)
          .updateUserProfile(uid, bio: newBio);

      if (mounted) {
        widget.onSave?.call();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('프로필이 저장되었습니다! ✅'),
            backgroundColor: AppColors.sageGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장 실패: $e'),
            backgroundColor: AppColors.softCoral,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Phase 3 Migration: AppBottomSheet로 껍데기(핸들바, 둥근 모서리, 키보드 SafeArea) 위임
    return AppBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('프로필 수정', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 8),
          Text('상태 메시지를 입력해보세요 ✨', style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          // 상태 메시지 입력
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppDecorations.defaultRadius,
              boxShadow: AppDecorations.innerInputShadow,
            ),
            child: TextField(
              controller: _controller,
              maxLength: 50,
              maxLines: 2,
              enabled: !_isSaving,
              decoration: InputDecoration(
                hintText: '오늘 하루도 감사해요 🙏',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(20),
                counterStyle: AppTextStyles.bodySmall.copyWith(fontSize: 12),
              ),
              style: AppTextStyles.bodyMedium,
            ),
          ),
          const SizedBox(height: 20),
          // 저장 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveBio,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('저장'),
            ),
          ),
        ],
      ),
    );
  }
}
