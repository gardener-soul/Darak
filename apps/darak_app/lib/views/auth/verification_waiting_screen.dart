import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/auth_service.dart';

/// 이메일 인증 대기 화면
/// - 회원가입 직후 자동 진입 (signup → pushAndRemoveUntil)
/// - 미인증 로그인 시 자동 진입 (login → pushReplacement)
/// - AuthWrapper에서도 미인증 유저 감지 시 표시
///
/// 3초마다 자동 확인 + 수동 확인 가능
/// 인증 완료 시: signOut 후 AuthWrapper가 WelcomeScreen을 다시 보여줌
///   → 유저가 인증된 상태로 로그인할 수 있도록.
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

        // 인증 완료 메시지 표시 후 로그아웃 → 다시 로그인하게 유도
        // (AuthWrapper가 다시 WelcomeScreen 표시)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('이메일 인증이 완료되었습니다! 로그인해주세요.'),
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        // 약간의 딜레이 후 로그아웃 (스낵바를 볼 수 있도록)
        await Future.delayed(const Duration(milliseconds: 500));
        await authService.signOut();
        // AuthWrapper가 자동으로 WelcomeScreen을 표시
      } else if (!auto && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('아직 인증이 완료되지 않았습니다. 메일함을 확인해주세요.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // 무시 (네트워크 오류 등)
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
            backgroundColor: Colors.green[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('메일 전송 실패: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
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
    // AuthWrapper가 자동으로 WelcomeScreen을 표시
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ─── 아이콘 ──────────────────────────────
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.mark_email_unread_outlined,
                  size: 50,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 28),

              // ─── 타이틀 ──────────────────────────────
              Text(
                '인증 메일을 확인해주세요',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),

              // ─── 설명 ────────────────────────────────
              Text(
                '가입하신 이메일로 인증 링크를 보냈습니다.\n메일의 링크를 클릭하면 자동으로 인증됩니다.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // 힌트
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Colors.amber[800],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '메일이 안 오면 스팸함을 확인해주세요!',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.amber[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // ─── 인증 확인 버튼 ──────────────────────
              FilledButton.icon(
                onPressed: _isChecking
                    ? null
                    : () => _checkEmailVerified(auto: false),
                icon: _isChecking
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.refresh),
                label: const Text('인증 완료 확인'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 12),

              // ─── 메일 재전송 ─────────────────────────
              OutlinedButton.icon(
                onPressed: _isChecking ? null : _resendEmail,
                icon: const Icon(Icons.send_outlined, size: 18),
                label: Text(_emailSent ? '인증 메일 다시 보내기 ✓' : '인증 메일 다시 보내기'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 20),

              // ─── 취소 / 다른 계정 ────────────────────
              TextButton(
                onPressed: _handleCancel,
                child: Text(
                  '다른 계정으로 로그인',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),

              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
