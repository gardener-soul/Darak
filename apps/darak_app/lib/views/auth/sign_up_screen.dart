import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/auth/auth_view_model.dart';
import 'verification_waiting_screen.dart';

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
      // 가입 성공 → 인증 대기 화면으로 이동 (이전 화면 모두 교체)
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const VerificationWaitingScreen()),
        (route) => false,
      );
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
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _formatError(Object? error) {
    final message = error?.toString() ?? '회원가입에 실패했습니다';
    if (message.contains('email-already-in-use')) return '이미 사용 중인 이메일입니다';
    if (message.contains('weak-password')) return '비밀번호가 너무 약합니다 (6자 이상)';
    if (message.contains('invalid-email')) return '유효하지 않은 이메일 형식입니다';
    if (message.startsWith('Exception: ')) return message.substring(11);
    return message;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState.isLoading;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('회원가입'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),

                // ─── 안내 문구 ──────────────────────────
                Text(
                  '공동체에 합류하세요',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '간편하게 가입하고 시작하세요',
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
                const SizedBox(height: 24),

                // ─── 구글 가입 ──────────────────────────
                _GoogleSignUpButton(
                  onPressed: isLoading ? null : _handleGoogleSignUp,
                ),
                const SizedBox(height: 20),

                // ─── 구분선 ────────────────────────────
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[300])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        '또는 이메일로 가입',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[300])),
                  ],
                ),
                const SizedBox(height: 20),

                // ─── 이름 ──────────────────────────────
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '이름',
                    hintText: '홍길동',
                    prefixIcon: Icon(Icons.person_outlined),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return '이름을 입력해주세요';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // ─── 이메일 ────────────────────────────
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: '이메일',
                    hintText: 'example@email.com',
                    prefixIcon: const Icon(Icons.email_outlined),
                    helperText: '가입 후 인증 메일이 발송됩니다',
                    helperStyle: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 12,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  validator: (v) {
                    if (v == null || v.isEmpty) return '이메일을 입력해주세요';
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                      return '유효한 이메일을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // ─── 비밀번호 ──────────────────────────
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    hintText: '8자 이상',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.isEmpty) return '비밀번호를 입력해주세요';
                    if (v.length < 8) return '비밀번호는 8자 이상이어야 합니다';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // ─── 비밀번호 확인 ─────────────────────
                TextFormField(
                  controller: _passwordConfirmController,
                  decoration: InputDecoration(
                    labelText: '비밀번호 확인',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePasswordConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () => setState(
                        () =>
                            _obscurePasswordConfirm = !_obscurePasswordConfirm,
                      ),
                    ),
                  ),
                  obscureText: _obscurePasswordConfirm,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.isEmpty) return '비밀번호를 다시 입력해주세요';
                    if (v != _passwordController.text) return '비밀번호가 일치하지 않습니다';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // ─── 핸드폰 ────────────────────────────
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: '연락처',
                    hintText: '010-1234-5678',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return '연락처를 입력해주세요';
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // ─── 가입 버튼 ─────────────────────────
                FilledButton(
                  onPressed: isLoading ? null : _handleSignUp,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.mail_outline, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '가입하고 인증 메일 받기',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 12),

                // 안내
                Text(
                  '가입 후 인증 메일의 링크를 클릭해야 로그인할 수 있습니다.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // ─── [임시] 로그아웃 버튼 ──────────────────
                TextButton(
                  onPressed: () async {
                    await ref.read(authViewModelProvider.notifier).signOut();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('로그아웃 되었습니다')),
                      );
                    }
                  },
                  child: const Text('임시 로그아웃'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 구글로 시작 버튼
class _GoogleSignUpButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _GoogleSignUpButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'G',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4285F4),
            ),
          ),
          SizedBox(width: 10),
          Text(
            'Google로 시작하기',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF3C4043),
            ),
          ),
        ],
      ),
    );
  }
}
