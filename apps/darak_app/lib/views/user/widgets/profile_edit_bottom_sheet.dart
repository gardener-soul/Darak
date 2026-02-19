import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';

class ProfileEditBottomSheet extends StatefulWidget {
  final VoidCallback? onSave;

  const ProfileEditBottomSheet({super.key, this.onSave});

  @override
  State<ProfileEditBottomSheet> createState() => _ProfileEditBottomSheetState();
}

class _ProfileEditBottomSheetState extends State<ProfileEditBottomSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.creamWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 핸들 바
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
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
              onPressed: () {
                // TODO: Firestore에 bio 저장 (고도화 시)
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
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('저장'),
            ),
          ),
        ],
      ),
    );
  }
}
