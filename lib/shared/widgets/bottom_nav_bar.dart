import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final count = provider.cartCount;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
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
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                    size: 22,
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
        );
      },
    );
  }
}
