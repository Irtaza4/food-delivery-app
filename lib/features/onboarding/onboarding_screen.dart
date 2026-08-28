import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../navigation/main_nav_scaffold.dart';
import 'widgets/animated_burger_hero.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, String>> _pages = [
    {
      'title': 'Step Into\nFlavor World',
      'image': 'assets/images/burger_hero.png',
      'tagline': 'Discover mouth-watering gourmet dishes and fast delivery.',
    },
    {
      'title': 'Dive Into\nPure Flavor',
      'image': 'assets/images/pizza_hero.png',
      'tagline': 'Hot artisan pizzas crafted fresh with premium ingredients.',
    },
    {
      'title': 'Flavor\nAwaits You',
      'image': 'assets/images/dessert_hero.png',
      'tagline': 'Sweet treats, sundaes and refreshing beverages on demand.',
    },
  ];

  void _onGetStarted() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, anim, secAnim) => const MainNavScaffold(),
        transitionsBuilder: (context, anim, secAnim, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC92014), // Signature vibrant red from screenshots
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 24),

            // PageView with title and hero food image
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return Column(
                    children: [
                      // Large bold heading matching screenshot style
                      Text(
                        item['title']!,
                        textAlign: TextAlign.center,
                        style: AppTypography.display.copyWith(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.15,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Floating visual food asset with soft depth
                      Expanded(
                        child: Center(
                          child: index == 0
                              ? const AnimatedBurgerHero(size: 320)
                              : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Ambient soft underglow shadow
                                    Container(
                                      width: 220,
                                      height: 220,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.28),
                                            blurRadius: 40,
                                            spreadRadius: 6,
                                            offset: const Offset(0, 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Floating transparent food image
                                    Container(
                                      constraints: const BoxConstraints(maxWidth: 320, maxHeight: 320),
                                      padding: const EdgeInsets.all(8),
                                      child: Image.asset(
                                        item['image']!,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Bottom CTA actions & terms container
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // "Get Started" White Pill Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _onGetStarted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFBF4F3),
                        foregroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Get Started',
                        style: AppTypography.button.copyWith(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // "I already have an account" Transparent outline pill button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: _onGetStarted,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'I already have an account',
                        style: AppTypography.button.copyWith(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Legal subtext
                  Text(
                    'By continuing with Email, Google, or Social accounts, you confirm that you accept our Terms of Service and Privacy Policy to enjoy safe food delivery.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
