import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/auth/auth_view_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/bouncy_button.dart';
import '../../widgets/common/soft_text_field.dart';

/// 회원가입 화면
/// 흐름: 정보 입력 → 가입 & 인증메일 발송 → VerificationWaitingScreen
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ─── 회원가입 핸들러 ───────────────────────────────────
  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authViewModelProvider.notifier)
        .signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        );

    if (!mounted) return;

    if (success) {
      // 가입 성공 → 홈 화면으로 바로 이동 (선사용 후인증)
      // 스택을 모두 비우고 홈으로 이동
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      final error = ref.read(authViewModelProvider).error;
      _showError(_formatError(error));
    }
  }

  // ─── 구글 회원가입 ────────────────────────────────────
  Future<void> _handleGoogleSignUp() async {
    final success = await ref
        .read(authViewModelProvider.notifier)
        .signInWithGoogle();

    if (!mounted) return;

    if (!success) {
      final error = ref.read(authViewModelProvider).error;
      if (error.toString().contains('사용자가 로그인을 취소')) return;
      _showError(_formatError(error));
    }
    // 성공 시 모든 화면 종료하고 홈으로 (AuthWrapper가 HomeScreen 표시)
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
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
    // 친절한 한글 에러 메시지로 변환
    final message = error?.toString() ?? '회원가입에 실패했습니다';
    if (message.contains('email-already-in-use')) return '이미 가입된 이메일이에요!';
    if (message.contains('weak-password')) return '비밀번호는 6자 이상이어야 안전해요';
    if (message.contains('invalid-email')) return '이메일 형식이 올바르지 않아요';
    if (message.contains('network-request-failed')) return '인터넷 연결을 확인해주세요';
    if (message.startsWith('Exception: ')) return message.substring(11);
    return '잠시 후 다시 시도해주세요 ($message)';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.creamWhite,
      appBar: AppBar(
        title: const Text('회원가입'),
        backgroundColor: AppColors.creamWhite,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),

                // ─── 안내 문구 ──────────────────────────
                Text(
                  '반가워요! 👋',
                  style: AppTextStyles.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '새로운 시작을 함께해요',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // ─── 구글 가입 ──────────────────────────
                BouncyButton(
                  onPressed: isLoading ? null : _handleGoogleSignUp,
                  text: 'Google ID로 회원 가입',
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
                    ),
                  ),
                  color: Colors.white,
                  textColor: AppColors.textDark,
                ),

                const SizedBox(height: 24),

                // ─── 구분선 ────────────────────────────
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.divider)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '또는 정보 직접 입력',
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.divider)),
                  ],
                ),
                const SizedBox(height: 24),

                // ─── 이름 ──────────────────────────────
                SoftTextField(
                  controller: _nameController,
                  hintText: '이름',
                  prefixIcon: Icon(
                    Icons.person_rounded,
                    color: AppColors.textGrey,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return '이름을 입력해주세요';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ─── 연락처 ────────────────────────────
                SoftTextField(
                  controller: _phoneController,
                  hintText: '연락처 (010-0000-0000)',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icon(
                    Icons.phone_rounded,
                    color: AppColors.textGrey,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return '연락처를 입력해주세요';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ─── 이메일 ────────────────────────────
                SoftTextField(
                  controller: _emailController,
                  hintText: '이메일',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(
                    Icons.email_rounded,
                    color: AppColors.textGrey,
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return '이메일을 입력해주세요';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                      return '유효한 이메일을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ─── 비밀번호 ──────────────────────────
                SoftTextField(
                  controller: _passwordController,
                  hintText: '비밀번호 (영문, 숫자, 특수문자 포함 8자 이상)',
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
                    if (v.length < 8) return '비밀번호는 8자 이상이어야 합니다';

                    // 영문, 숫자, 특수문자 포함 여부 확인 정규식
                    // (?=.*[A-Za-z]): 영문 포함
                    // (?=.*\d): 숫자 포함
                    // (?=.*[@$!%*#?&]): 특수문자 포함

                    // 조금 더 유연한 특수문자 허용 (모든 특수문자) - 위 패턴은 특정 문자만 허용함.
                    // 개선된 패턴: 영문, 숫자, 특수문자 각각 하나 이상 포함
                    bool hasLetter = RegExp(r'[A-Za-z]').hasMatch(v);
                    bool hasDigit = RegExp(r'\d').hasMatch(v);
                    bool hasSpecial = RegExp(
                      r'[!@#\$%^&*(),.?":{}|<>]',
                    ).hasMatch(v);

                    if (!hasLetter || !hasDigit || !hasSpecial) {
                      return '영문, 숫자, 특수문자를 모두 포함해야 합니다';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ─── 비밀번호 확인 ─────────────────────
                SoftTextField(
                  controller: _passwordConfirmController,
                  hintText: '비밀번호 확인',
                  obscureText: _obscurePasswordConfirm,
                  prefixIcon: Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.textGrey,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePasswordConfirm
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.textGrey,
                    ),
                    onPressed: () => setState(
                      () => _obscurePasswordConfirm = !_obscurePasswordConfirm,
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return '비밀번호를 다시 입력해주세요';
                    if (v != _passwordController.text) return '비밀번호가 일치하지 않습니다';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // ─── 가입 버튼 ─────────────────────────
                BouncyButton(
                  onPressed: isLoading ? null : _handleSignUp,
                  text: isLoading ? '가입 처리 중...' : '회원가입 완료하기',
                  color: AppColors.softCoral,
                  textColor: Colors.white,
                  icon: isLoading
                      ? null
                      : const Icon(Icons.check_rounded, color: Colors.white),
                ),
                const SizedBox(height: 24),

                // 안내
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.sageGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.sageGreen,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '가입 후 이메일 인증을 완료해야 모든 기능을 사용할 수 있습니다.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
