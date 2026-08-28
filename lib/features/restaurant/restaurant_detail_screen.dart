import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/restaurant.dart';
import '../../core/data/mock_data.dart';
import '../../core/state/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/food_card.dart';
import '../food/food_detail_screen.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  late String _selectedCategory;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.restaurant.categories.isNotEmpty
        ? widget.restaurant.categories.first
        : 'Popular';
  }

  @override
  Widget build(BuildContext context) {
    // Filter food items for this restaurant or show mock items
    final restaurantFoods = MockData.foodItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Collapsible Hero Banner App Bar
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              ),
            ),
            actions: [
              Consumer<AppProvider>(
                builder: (context, provider, _) {
                  final isFav = provider.isFavoriteRestaurant(widget.restaurant.id);
                  return GestureDetector(
                    onTap: () => provider.toggleFavoriteRestaurant(widget.restaurant.id),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFav ? AppColors.primary : Colors.white,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Restaurant link copied to clipboard!')),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.restaurant.bannerImage,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Restaurant Header Profile Card
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                children: [
                  // Overlapping Circular Logo
                  Transform.translate(
                    offset: const Offset(0, -28),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3.5),
                        boxShadow: AppTheme.cardShadow,
                      ),
                      child: Center(
                        child: Text(
                          widget.restaurant.logo,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'serif',
                          ),
                        ),
                      ),
                    ),
                  ),

                  Transform.translate(
                    offset: const Offset(0, -16),
                    child: Column(
                      children: [
                        // Restaurant Name
                        Text(
                          widget.restaurant.name,
                          style: AppTypography.heading1.copyWith(fontSize: 22),
                        ),
                        const SizedBox(height: 16),

                        // Stats Row: Followers | Products | Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn(widget.restaurant.followers, 'Followers'),
                            Container(width: 1, height: 28, color: AppColors.divider),
                            _buildStatColumn('${widget.restaurant.productsCount}', 'Products'),
                            Container(width: 1, height: 28, color: AppColors.divider),
                            _buildRatingStat(widget.restaurant.rating, 'Rating'),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Follow & Chat Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() => _isFollowing = !_isFollowing);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isFollowing ? AppColors.background : AppColors.textPrimary,
                                    foregroundColor: _isFollowing ? AppColors.textPrimary : Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: Text(
                                    _isFollowing ? 'Following' : 'Follow',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: _isFollowing ? AppColors.textPrimary : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 44,
                                child: OutlinedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Opening chat with restaurant support...')),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.border, width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: Text(
                                    'Chat',
                                    style: AppTypography.button.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Delivery Info Pill Container
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.delivery_dining_rounded,
                                  color: AppColors.accent,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Delivery Time: ${widget.restaurant.deliveryTime}',
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Charge: ${widget.restaurant.deliveryCharge}\$ · Min. Order: ${widget.restaurant.minOrder.toStringAsFixed(0)}\$',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textLight,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Category Filter Tabs
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: widget.restaurant.categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.textPrimary : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textLight,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Menu Food Grid (2 Columns)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 14,
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final food = restaurantFoods[index % restaurantFoods.length];
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
                childCount: restaurantFoods.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.heading3.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingStat(double rating, String label) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, size: 16, color: AppColors.gold),
            const SizedBox(width: 2),
            Text(
              rating.toStringAsFixed(1),
              style: AppTypography.heading3.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
