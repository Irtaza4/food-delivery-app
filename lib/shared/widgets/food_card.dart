import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/food_item.dart';
import '../../core/state/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';
import 'rating_badge.dart';

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback? onTap;

  const FoodCard({
    super.key,
    required this.food,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
          boxShadow: AppTheme.cardShadow,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with add (+) button overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  child: AspectRatio(
                    aspectRatio: 1.25,
                    child: Image.asset(
                      food.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.background,
                          child: const Icon(Icons.fastfood, color: AppColors.textMuted, size: 36),
                        );
                      },
                    ),
                  ),
                ),
                // Plus button in circle
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<AppProvider>(
                    builder: (context, provider, _) {
                      return GestureDetector(
                        onTap: () {
                          provider.addToCart(food);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.textPrimary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              content: Text(
                                '${food.name} added to cart!',
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Title and rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    food.name,
                    style: AppTypography.heading3.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                RatingBadge(rating: food.rating),
              ],
            ),
            const SizedBox(height: 4),
            // Restaurant subtitle
            Text(
              food.restaurantName,
              style: AppTypography.caption.copyWith(
                color: AppColors.textLight,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Price
            Text(
              '${food.price.toStringAsFixed(2)}\$',
              style: AppTypography.heading3.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
