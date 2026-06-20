import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/providers/auth_provider.dart';
import 'package:apexforge/providers/user_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      _scheduleNavigation();
    });
  }

  void _scheduleNavigation() {
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted || _navigated) return;
      _checkAndNavigate();
    });
  }

  void _checkAndNavigate() {
    if (_navigated) return;
    final authValue = ref.read(authStateProvider);
    final user = authValue.value;

    if (user == null) {
      _navigated = true;
      if (mounted) context.go('/login');
      return;
    }

    final profileValue = ref.read(userProfileProvider);
    final profile = profileValue.value;

    if (profile == null) {
      _navigated = true;
      if (mounted) context.go('/home');
      return;
    }

    _navigated = true;
    if (mounted) {
      if (!profile.onboardingComplete) {
        context.go('/onboarding');
      } else {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateProvider, (_, next) {
      if (!next.isLoading && !_navigated) {
        Future.delayed(const Duration(milliseconds: 300), _checkAndNavigate);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      color: AppColors.accentGold,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'APEXFORGE',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentGold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'LIFE MASTERY TRACKER',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreenBright,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 60),
            child: LinearProgressIndicator(
              backgroundColor: AppColors.surfaceVariant,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.accentGold),
              minHeight: 2,
            ),
          ),
        ],
      ),
    );
  }
}
