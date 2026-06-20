import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/providers/auth_provider.dart';
import 'package:apexforge/widgets/apex_button.dart';
import 'package:apexforge/widgets/apex_text_field.dart';

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

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authNotifierProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (success && mounted) {
      context.go('/home');
    }
  }

  Future<void> _signInWithGoogle() async {
    final success =
        await ref.read(authNotifierProvider.notifier).signInWithGoogle();
    if (success && mounted) {
      context.go('/home');
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email first')),
      );
      return;
    }
    await ref.read(authNotifierProvider.notifier).resetPassword(email);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: AppColors.accentGold,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'APEXFORGE',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentGold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 32),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome Back, Warrior',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ApexTextField(
                  label: 'Email',
                  controller: _emailController,
                  hint: 'warrior@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ApexTextField(
                  label: 'Password',
                  controller: _passwordController,
                  obscure: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    return null;
                  },
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        color: AppColors.accentGold,
                      ),
                    ),
                  ),
                ),
                if (authState.error != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withAlpha(30),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: AppColors.error.withAlpha(80)),
                    ),
                    child: Text(
                      authState.error!,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ApexButton(
                  label: 'Sign In',
                  onPressed: _signIn,
                  isLoading: authState.isLoading,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                        child: Divider(color: AppColors.surfaceBright)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          color: AppColors.textHint,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Divider(color: AppColors.surfaceBright)),
                  ],
                ),
                const SizedBox(height: 24),
                ApexButton(
                  label: 'Continue with Google',
                  onPressed: _signInWithGoogle,
                  isOutlined: true,
                  icon: Icons.g_mobiledata_rounded,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/register'),
                      child: const Text(
                        'Create account',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentGold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
