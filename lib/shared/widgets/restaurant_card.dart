import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/restaurant.dart';
import '../../core/state/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';
import 'rating_badge.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback? onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          boxShadow: AppTheme.cardShadow,
          border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXl)),
                  child: AspectRatio(
                    aspectRatio: 1.7,
                    child: Image.asset(
                      restaurant.bannerImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.background,
                          child: const Icon(Icons.restaurant, size: 40, color: AppColors.textMuted),
                        );
                      },
                    ),
                  ),
                ),
                // Discount tag
                if (restaurant.discountTag.isNotEmpty) ...[
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        restaurant.discountTag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<AppProvider>(
                    builder: (context, provider, _) {
                      final isFav = provider.isFavoriteRestaurant(restaurant.id);
                      return GestureDetector(
                        onTap: () => provider.toggleFavoriteRestaurant(restaurant.id),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                            color: isFav ? AppColors.primary : Colors.white,
                            size: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // Info content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: AppTypography.heading3.copyWith(fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      RatingBadge(rating: restaurant.rating),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.cuisine,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.deliveryTime,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(width: 3, height: 3, decoration: const BoxDecoration(color: AppColors.textMuted, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text(
                        '\$${restaurant.deliveryCharge.toStringAsFixed(2)} delivery',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
