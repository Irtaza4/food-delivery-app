import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/data/mock_data.dart';
import '../../core/state/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/animated_entry.dart';
import '../../shared/widgets/food_card.dart';
import '../../shared/widgets/restaurant_card.dart';
import '../food/food_detail_screen.dart';
import '../restaurant/restaurant_detail_screen.dart';


class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Favorites',
          style: AppTypography.heading2.copyWith(fontSize: 18),
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final favFoods = MockData.foodItems
              .where((item) => provider.isFavoriteFood(item.id))
              .toList();

          final favRestaurants = MockData.restaurants
              .where((res) => provider.isFavoriteRestaurant(res.id))
              .toList();

          if (favFoods.isEmpty && favRestaurants.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border_rounded, size: 64, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  Text('No favorites yet', style: AppTypography.heading3),
                  const SizedBox(height: 8),
                  Text('Save restaurants and dishes you love for quick access.', style: AppTypography.bodySmall),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (favRestaurants.isNotEmpty) ...[
                  AnimatedEntry(
                    direction: SlideDirection.fromLeft,
                    delay: const Duration(milliseconds: 60),
                    duration: const Duration(milliseconds: 500),
                    distance: 0.35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Favorite Restaurants',
                          style: AppTypography.heading2.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 255,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: favRestaurants.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 14),
                            itemBuilder: (context, index) {
                              final res = favRestaurants[index];
                              return RestaurantCard(
                                restaurant: res,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => RestaurantDetailScreen(restaurant: res),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                if (favFoods.isNotEmpty) ...[
                  AnimatedEntry(
                    direction: SlideDirection.fromBottom,
                    delay: const Duration(milliseconds: 160),
                    duration: const Duration(milliseconds: 550),
                    distance: 0.25,
                    enableScale: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Favorite Dishes',
                          style: AppTypography.heading2.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: favFoods.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.72,
                          ),
                          itemBuilder: (context, index) {
                            final food = favFoods[index];
                            return FoodCard(
                              food: food,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => FoodDetailScreen(food: food),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
