import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/data/mock_data.dart';
import '../../core/state/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/food_card.dart';
import '../../shared/widgets/restaurant_card.dart';
import '../food/food_detail_screen.dart';
import '../restaurant/restaurant_detail_screen.dart';
import '../category/category_grid_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (Menu, Location, Notification)
              _buildHeader(context),

              const SizedBox(height: 16),

              // 27% Extra Discount Banner
              _buildPromoBanner(context),

              const SizedBox(height: 20),

              // Search Bar & Filter Button
              _buildSearchBar(context),

              const SizedBox(height: 24),

              // Popular Restaurants Horizontal Carousel
              _buildPopularRestaurantsSection(context),

              const SizedBox(height: 24),

              // Popular Dishes 2-Column Grid
              _buildPopularFoodSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menu button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: AppTheme.cardShadow,
            ),
            child: const Icon(Icons.notes_rounded, color: AppColors.textPrimary, size: 22),
          ),

          // Location Selector
          Consumer<AppProvider>(
            builder: (context, provider, _) {
              return GestureDetector(
                onTap: () => _showLocationSelector(context, provider),
                child: Column(
                  children: [
                    Text(
                      'Delivery location',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on_rounded, size: 16, color: AppColors.accent),
                        const SizedBox(width: 4),
                        Text(
                          provider.deliveryLocation,
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textPrimary),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // Notification Bell
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('You have no new notifications!')),
              );
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: AppTheme.cardShadow,
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 22),
                  ),
                  Positioned(
                    top: 10,
                    right: 12,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          final provider = Provider.of<AppProvider>(context, listen: false);
          provider.applyPromoCode('FLAVOR27');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: AppColors.textPrimary,
              content: Text('Promo code FLAVOR27 applied! 27% discount active in cart.'),
            ),
          );
        },
        child: Container(
          height: 145,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF282424),
                Color(0xFF161313),
              ],
            ),
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Stack(
            children: [
              // Decorative circle
              Positioned(
                right: -20,
                bottom: -20,
                child: Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '27%',
                                style: AppTypography.display.copyWith(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFFE25B38),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'EXTRA\nDISCOUNT',
                                style: AppTypography.caption.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  height: 1.1,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enjoy your first order with a\nspecial discount!',
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 11.5,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/burger_hero.png',
                        fit: BoxFit.contain,
                        height: 110,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CategoryGridScreen(categoryTitle: 'Burgers')),
                );
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: AppTheme.cardShadow,
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'Search restaurants or dishes',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CategoryGridScreen(categoryTitle: 'All Food')),
              );
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: AppTheme.cardShadow,
                border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
              ),
              child: const Icon(Icons.tune_rounded, color: AppColors.textPrimary, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularRestaurantsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Restaurant',
                style: AppTypography.heading2.copyWith(fontSize: 18),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RestaurantDetailScreen(restaurant: MockData.restaurants[0]),
                    ),
                  );
                },
                child: Text(
                  'See All',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 255,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: MockData.restaurants.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {

              final restaurant = MockData.restaurants[index];
              return RestaurantCard(
                restaurant: restaurant,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RestaurantDetailScreen(restaurant: restaurant),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularFoodSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Most Loved Dishes',
                style: AppTypography.heading2.copyWith(fontSize: 18),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CategoryGridScreen(categoryTitle: 'All Dishes'),
                    ),
                  );
                },
                child: Text(
                  'See All',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: MockData.foodItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 14,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final food = MockData.foodItems[index];
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
        ),
      ],
    );
  }

  void _showLocationSelector(BuildContext context, AppProvider provider) {
    final locations = [
      'Manhattan, New York, USA',
      'Brooklyn, New York, USA',
      'Downtown, Los Angeles, CA',
      'South Beach, Miami, FL',
      'Lincoln Park, Chicago, IL',
      'Market St, San Francisco, CA',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Select Delivery Location', style: AppTypography.heading2.copyWith(fontSize: 18)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...locations.map((loc) {
                final isCurrent = provider.deliveryLocation == loc;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.location_on_rounded,
                    color: isCurrent ? AppColors.primary : AppColors.textMuted,
                  ),
                  title: Text(
                    loc,
                    style: TextStyle(
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  trailing: isCurrent ? const Icon(Icons.check, color: AppColors.primary) : null,
                  onTap: () {
                    provider.setDeliveryLocation(loc);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
