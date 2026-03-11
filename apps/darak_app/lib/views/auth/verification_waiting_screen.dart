import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/bouncy_button.dart';
import '../../widgets/common/clay_card.dart';

/// 이메일 인증 대기 화면
class VerificationWaitingScreen extends ConsumerStatefulWidget {
  const VerificationWaitingScreen({super.key});

  @override
  ConsumerState<VerificationWaitingScreen> createState() =>
      _VerificationWaitingScreenState();
}

class _VerificationWaitingScreenState
    extends ConsumerState<VerificationWaitingScreen> {
  Timer? _timer;
  bool _isChecking = false;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    // 3초마다 자동으로 인증 여부 확인
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkEmailVerified(auto: true),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// 이메일 인증 여부 확인
  Future<void> _checkEmailVerified({bool auto = false}) async {
    if (_isChecking) return;

    if (!auto && mounted) {
      setState(() => _isChecking = true);
    }

    try {
      final authService = ref.read(authServiceProvider);
      await authService.reloadUser();

      if (authService.isEmailVerified && mounted) {
        _timer?.cancel();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('이메일 인증이 완료되었습니다! 로그인해주세요.'),
            backgroundColor: AppColors.sageGreen,
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        await authService.signOut();
      } else if (!auto && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('아직 인증이 완료되지 않았습니다. 메일함을 확인해주세요.'),
            backgroundColor: AppColors.warmTangerine,
          ),
        );
      }
    } catch (e) {
      // Ignore
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  /// 인증 메일 재전송
  Future<void> _resendEmail() async {
    setState(() => _isChecking = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.resendEmailVerification();

      if (mounted) {
        setState(() => _emailSent = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('인증 메일을 다시 보냈습니다. 스팸함도 확인해주세요!'),
            backgroundColor: AppColors.sageGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('메일 전송 실패: $e'),
            backgroundColor: AppColors.softCoral,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isChecking = false);
    }
  }

  /// 로그아웃 & 돌아가기
  Future<void> _handleCancel() async {
    final authService = ref.read(authServiceProvider);
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      // 닫기 버튼을 상단에 추가 (모달/페이지 종료)
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, color: AppColors.textGrey),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // ─── Main Content Card ────────────────────────────────
              ClayCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppColors.softLavender,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mark_email_unread_rounded,
                        size: 48,
                        color: AppColors.pureWhite,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '메일함을 확인해주세요',
                      style: AppTextStyles.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '가입하신 이메일로 인증 링크를 보냈어요.\n링크를 누르면 자동으로 시작됩니다!',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.warmTangerine.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.warmTangerine,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '메일이 안 오면 스팸함을 꼭 확인해주세요!',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.warmTangerine,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ─── Action Buttons ───────────────────────────────────

              // 1. Check Verification
              BouncyButton(
                onPressed: _isChecking
                    ? null
                    : () => _checkEmailVerified(auto: false),
                text: _isChecking ? '확인 중...' : '인증 완료 확인하기',
                color: AppColors.softCoral,
                textColor: Colors.white,
                icon: _isChecking
                    ? null
                    : const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                      ),
              ),
              const SizedBox(height: 16),

              // 2. Resend Email
              BouncyButton(
                onPressed: _isChecking ? null : _resendEmail,
                text: _emailSent ? '메일 다시 보내기 ✓' : '인증 메일 다시 보내기',
                color: AppColors.pureWhite,
                textColor: AppColors.textDark,
                icon: const Icon(Icons.send_rounded, color: AppColors.textDark),
              ),

              const Spacer(),

              // ─── Cancel Link ─────────────────────────────────────
              TextButton(
                onPressed: _handleCancel,
                child: Text(
                  '다른 이메일로 시작하기',
                  style: AppTextStyles.bodySmall.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
