import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apexforge/core/theme/app_colors.dart';
import 'package:apexforge/widgets/apex_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  static const List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      emoji: '⚡',
      headline: 'TAKE BACK\nCONTROL',
      subtext: 'Your streak starts today.\nNo more excuses.',
      gradientStart: Color(0xFF0D0D0D),
      gradientEnd: Color(0xFF1B2A1B),
    ),
    _OnboardingSlide(
      emoji: '📊',
      headline: 'TRACK\nEVERYTHING',
      subtext: 'Unlimited trackers for\nevery area of your life.',
      gradientStart: Color(0xFF0D0D0D),
      gradientEnd: Color(0xFF0D1B2A),
    ),
    _OnboardingSlide(
      emoji: '🏆',
      headline: 'LEVEL UP\nYOUR LIFE',
      subtext: 'Earn XP, unlock badges,\ndominate all 4 domains.',
      gradientStart: Color(0xFF0D0D0D),
      gradientEnd: Color(0xFF2A1B0D),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return _SlideView(slide: _slides[index]);
            },
          ),
          // Skip button
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 20,
            child: TextButton(
              onPressed: () => context.go('/login'),
              child: const Text(
                'Skip',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  24, 20, 24, MediaQuery.of(context).padding.bottom + 24),
              child: Column(
                children: [
                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? AppColors.accentGold
                              : AppColors.surfaceBright,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ApexButton(
                    label: _currentPage == _slides.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: _next,
                    icon: _currentPage == _slides.length - 1
                        ? Icons.rocket_launch_rounded
                        : Icons.arrow_forward_rounded,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  final _OnboardingSlide slide;

  const _SlideView({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [slide.gradientStart, slide.gradientEnd],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                slide.emoji,
                style: const TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 32),
              Text(
                slide.headline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                slide.subtext,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16,
                  color: Color(0xFFB0B0B0),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  final String emoji;
  final String headline;
  final String subtext;
  final Color gradientStart;
  final Color gradientEnd;

  const _OnboardingSlide({
    required this.emoji,
    required this.headline,
    required this.subtext,
    required this.gradientStart,
    required this.gradientEnd,
  });
}
