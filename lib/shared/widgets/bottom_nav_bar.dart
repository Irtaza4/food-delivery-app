import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(36),
          boxShadow: AppTheme.floatingShadow,
          border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(0, Icons.home_rounded, 'Home'),
            _buildCartItem(1),
            _buildNavItem(2, Icons.search_rounded, 'Explore'),
            _buildNavItem(3, Icons.favorite_border_rounded, 'Favorites', activeIcon: Icons.favorite_rounded),
            _buildNavItem(4, Icons.person_outline_rounded, 'Profile', activeIcon: Icons.person_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {IconData? activeIcon}) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 14 : 10,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? (activeIcon ?? icon) : icon,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 22,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(int index) {
    final isSelected = currentIndex == index;
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final count = provider.cartCount;
        return GestureDetector(
          onTap: () => onTap(index),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: isSelected ? 14 : 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: isSelected ? AppColors.primary : AppColors.textMuted,
                      size: 22,
                    ),
                    if (count > 0) ...[
                      Positioned(
                        right: -6,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Center(
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (isSelected) ...[
                  const SizedBox(width: 6),
                  Text(
                    'Cart',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
