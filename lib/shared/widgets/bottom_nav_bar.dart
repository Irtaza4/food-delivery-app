import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/models/food_item.dart';
import '../../core/state/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int? _hoverIndex;
  bool _isHolding = false;

  int _calculateIndexFromX(double localX, double totalWidth) {
    if (totalWidth <= 0) return widget.currentIndex;
    const tabCount = 5;
    final tabWidth = totalWidth / tabCount;
    return (localX / tabWidth).floor().clamp(0, tabCount - 1);
  }

  void _onPointerDown(double localX, double totalWidth) {
    final targetIndex = _calculateIndexFromX(localX, totalWidth);
    setState(() {
      _isHolding = true;
      _hoverIndex = targetIndex;
    });
    HapticFeedback.selectionClick();
  }

  void _onPointerMove(double localX, double totalWidth) {
    final targetIndex = _calculateIndexFromX(localX, totalWidth);
    if (targetIndex != _hoverIndex) {
      setState(() {
        _hoverIndex = targetIndex;
      });
      HapticFeedback.selectionClick();
    }
  }

  void _onPointerRelease() {
    if (_isHolding && _hoverIndex != null) {
      final commitIndex = _hoverIndex!;
      setState(() {
        _isHolding = false;
        _hoverIndex = null;
      });
      widget.onTap(commitIndex);
      HapticFeedback.lightImpact();
    } else {
      setState(() {
        _isHolding = false;
        _hoverIndex = null;
      });
    }
  }

  void _onPointerCancel() {
    setState(() {
      _isHolding = false;
      _hoverIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayIndex = _isHolding && _hoverIndex != null ? _hoverIndex! : widget.currentIndex;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      margin: EdgeInsets.fromLTRB(
        18,
        0,
        18,
        bottomInset > 0 ? (bottomInset * 0.75).clamp(18.0, 26.0) : 20.0,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
            final barWidth = constraints.maxWidth;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (details) => _onPointerDown(details.localPosition.dx, barWidth),
              onPanUpdate: (details) => _onPointerMove(details.localPosition.dx, barWidth),
              onPanEnd: (_) => _onPointerRelease(),
              onPanCancel: _onPointerCancel,
              child: AnimatedScale(
                scale: _isHolding ? 0.985 : 1.0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutCubic,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: _isHolding
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : AppTheme.floatingShadow,
                    border: Border.all(
                      color: _isHolding
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : AppColors.border.withValues(alpha: 0.8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNavItem(0, Icons.home_rounded, 'Home', displayIndex),
                      _buildCartItem(1, displayIndex),
                      _buildNavItem(2, Icons.search_rounded, 'Explore', displayIndex),
                      _buildNavItem(3, Icons.favorite_border_rounded, 'Favorites', displayIndex, activeIcon: Icons.favorite_rounded),
                      _buildNavItem(4, Icons.person_outline_rounded, 'Profile', displayIndex, activeIcon: Icons.person_rounded),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
  }

  Widget _buildNavItem(int index, IconData icon, String label, int activeIndex, {IconData? activeIcon}) {
    final isSelected = activeIndex == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(
        horizontal: isSelected ? 14 : 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
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
    );
  }

  Widget _buildCartItem(int index, int activeIndex) {
    final isSelected = activeIndex == index;
    return DragTarget<FoodItem>(
      onWillAcceptWithDetails: (details) {
        HapticFeedback.selectionClick();
        return true;
      },
      onAcceptWithDetails: (details) {
        final provider = Provider.of<AppProvider>(context, listen: false);
        provider.addToCart(details.data);
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.textPrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${details.data.name} dropped into cart!',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'VIEW CART',
              textColor: AppColors.gold,
              onPressed: () => provider.setNavIndex(1),
            ),
          ),
        );
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return Consumer<AppProvider>(
          builder: (context, provider, _) {
            final count = provider.cartCount;
            return AnimatedScale(
              scale: isHovering ? 1.25 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected || isHovering ? 14 : 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isHovering
                      ? AppColors.primary.withValues(alpha: 0.25)
                      : isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  border: isHovering
                      ? Border.all(color: AppColors.primary, width: 1.5)
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          isHovering ? Icons.shopping_cart_rounded : Icons.shopping_bag_outlined,
                          color: isSelected || isHovering ? AppColors.primary : AppColors.textMuted,
                          size: isHovering ? 24 : 22,
                        ),
                        if (count > 0)
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
                    ),
                    if (isSelected || isHovering) ...[
                      const SizedBox(width: 6),
                      Text(
                        isHovering ? 'Drop Here' : 'Cart',
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
      },
    );
  }
}
