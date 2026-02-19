import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/auth/auth_view_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/bouncy_button.dart';

import '../../widgets/common/soft_text_field.dart';
import 'sign_up_screen.dart';
import 'verification_waiting_screen.dart';

/// 로그인 화면
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── 이메일 로그인 ─────────────────────────────────────
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authViewModelProvider.notifier)
        .signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) return;

    if (!success) {
      final error = ref.read(authViewModelProvider).error;

      // 이메일 미인증 → 인증 대기 화면
      if (error.toString().contains('email-not-verified')) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const VerificationWaitingScreen()),
        );
        return;
      }

      _showError(_formatError(error));
    }
    // 성공 시 현재 화면 종료 (AuthWrapper가 HomeScreen 표시)
    if (mounted) Navigator.of(context).pop();
  }

  // ─── 구글 로그인 ───────────────────────────────────────
  Future<void> _handleGoogleLogin() async {
    final success = await ref
        .read(authViewModelProvider.notifier)
        .signInWithGoogle();

    if (!mounted) return;

    if (!success) {
      final error = ref.read(authViewModelProvider).error;
      // 사용자 취소는 무시
      if (error.toString().contains('사용자가 로그인을 취소')) return;
      _showError(_formatError(error));
    }
    // 성공 시 현재 화면 종료 (AuthWrapper가 HomeScreen 표시)
    if (mounted) Navigator.of(context).pop();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.softCoral,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _formatError(Object? error) {
    final message = error?.toString() ?? '로그인에 실패했습니다';
    if (message.startsWith('Exception: ')) return message.substring(11);
    return message;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ─── 로고 & 타이틀 ──────────────────────
                  Column(
                    children: [
                      // Floating Animation Mockup (Static for now, can be animated with defined widget)
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.pureWhite,
                          boxShadow: AppDecorations.floatingShadow,
                        ),
                        child: Icon(
                          Icons.church_rounded,
                          size: 50,
                          color: AppColors.softCoral,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome to Darak! 👋',
                        style: AppTextStyles.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '로그인하고 우리 공동체를 다시 만나요',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // ─── 구글 로그인 (맨 위) ────────────────
                  BouncyButton(
                    onPressed: isLoading ? null : _handleGoogleLogin,
                    text: 'Google로 계속하기',
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        'G',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ), // Placeholder for Google Icon
                    ),
                    color: Colors.white,
                    textColor: AppColors.textDark,
                  ),

                  const SizedBox(height: 24),

                  // ─── 구분선 ──────────────────────────────
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.divider)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '또는 이메일로 로그인',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.divider)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ─── 이메일 입력 ─────────────────────────
                  SoftTextField(
                    controller: _emailController,
                    hintText: '이메일 주소',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.email_rounded,
                      color: AppColors.textGrey,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return '이메일을 입력해주세요';
                      if (!v.contains('@')) return '유효한 이메일을 입력해주세요';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ─── 비밀번호 입력 ───────────────────────
                  SoftTextField(
                    controller: _passwordController,
                    hintText: '비밀번호',
                    obscureText: _obscurePassword,
                    prefixIcon: Icon(
                      Icons.lock_rounded,
                      color: AppColors.textGrey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: AppColors.textGrey,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return '비밀번호를 입력해주세요';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // ─── 로그인 버튼 ─────────────────────────
                  BouncyButton(
                    onPressed: isLoading ? null : _handleLogin,
                    text: isLoading ? '로그인 중...' : '이메일로 로그인',
                    color: AppColors.softCoral,
                    textColor: Colors.white,
                  ),
                  const SizedBox(height: 24),

                  // ─── 회원가입 링크 ───────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('아직 계정이 없으신가요?', style: AppTextStyles.bodySmall),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        ),
                        child: Text(
                          '회원가입',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.softCoral,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
