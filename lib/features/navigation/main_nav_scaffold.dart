import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_provider.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import '../home/home_screen.dart';
import '../cart/cart_screen.dart';
import '../category/category_grid_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';

class MainNavScaffold extends StatelessWidget {
  const MainNavScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final screens = [
          const HomeScreen(),
          const CartScreen(),
          const CategoryGridScreen(categoryTitle: 'Explore Menu'),
          const FavoritesScreen(),
          const ProfileScreen(),
        ];

        return Scaffold(
          extendBody: true,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.03, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(provider.currentNavIndex),
              child: screens[provider.currentNavIndex],
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: provider.currentNavIndex,
            onTap: (index) => provider.setNavIndex(index),
          ),
        );
      },
    );
  }
}
