import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/food_item.dart';
import '../../core/state/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/animated_entry.dart';
import '../../shared/widgets/quantity_stepper.dart';
import '../../shared/widgets/rating_badge.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodItem food;

  const FoodDetailScreen({super.key, required this.food});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;
  late List<AddOn> _availableAddOns;
  final Set<String> _selectedAddOnIds = {};
  String? _note;

  @override
  void initState() {
    super.initState();
    _availableAddOns = widget.food.addOns.isNotEmpty
        ? widget.food.addOns
        : [
            AddOn(id: 'extra_cheese', name: 'Extra Cheese', price: 1.00, image: 'assets/images/beef_spicy_burger.png'),
            AddOn(id: 'crispy_fries', name: 'Crispy Fries', price: 2.50, image: 'assets/images/bbq_burger.png'),
            AddOn(id: 'iced_drink', name: 'Cold Beverage', price: 1.50, image: 'assets/images/vanilla_icecream.png'),
            AddOn(id: 'spicy_sauce', name: 'Spicy Dip', price: 0.75, image: 'assets/images/chicken_rice.png'),
          ];
  }

  double get _currentTotalPrice {
    double base = widget.food.price;
    for (var addon in _availableAddOns) {
      if (_selectedAddOnIds.contains(addon.id)) {
        base += addon.price;
      }
    }
    return base * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Hero Section with dynamic warm gradient background
                Stack(
                  children: [
                    Container(
                      height: 380,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFE23829),
                            Color(0xFFF37335),
                            Colors.white,
                          ],
                        ),
                      ),
                    ),

                    // Top Bar (Back, Details, Favorite)
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                              ),
                            ),
                            Text(
                              'Details',
                              style: AppTypography.heading3.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Consumer<AppProvider>(
                              builder: (context, provider, _) {
                                final isFav = provider.isFavoriteFood(widget.food.id);
                                return GestureDetector(
                                  onTap: () => provider.toggleFavoriteFood(widget.food.id),
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                      color: isFav ? AppColors.primary : Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Floating 3D Food Hero Image
                    Positioned(
                      top: 80,
                      left: 20,
                      right: 20,
                      child: Center(
                        child: Hero(
                          tag: 'food_${widget.food.id}',
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Ambient soft shadow under food
                              Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.22),
                                      blurRadius: 36,
                                      spreadRadius: 4,
                                      offset: const Offset(0, 16),
                                    ),
                                  ],
                                ),
                              ),
                              // Floating transparent food image
                              Container(
                                height: 280,
                                constraints: const BoxConstraints(maxWidth: 320),
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(
                                  widget.food.image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Dish Info Body
                AnimatedEntry(
                  direction: SlideDirection.fromBottom,
                  delay: const Duration(milliseconds: 150),
                  duration: const Duration(milliseconds: 500),
                  distance: 0.2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.food.name,
                          style: AppTypography.heading1.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      const SizedBox(height: 8),

                      // Rating & Delivery info
                      Row(
                        children: [
                          RatingBadge(
                            rating: widget.food.rating,
                            reviewsCount: widget.food.reviewsCount,
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              color: AppColors.textMuted,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.access_time_filled, size: 16, color: Color(0xFF22C55E)),
                          const SizedBox(width: 4),
                          Text(
                            'Delivery in ${widget.food.deliveryTime}',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Price and Quantity Stepper
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$ ${widget.food.price.toStringAsFixed(2)}',
                            style: AppTypography.display.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          QuantityStepper(
                            quantity: _quantity,
                            onIncrement: () => setState(() => _quantity++),
                            onDecrement: () {
                              if (_quantity > 1) {
                                setState(() => _quantity--);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Ingredients
                      Text(
                        'Ingredients',
                        style: AppTypography.heading3.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.food.ingredients,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textLight,
                          height: 1.5,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Add More Food / Add-Ons
                      Text(
                        'Add More Food',
                        style: AppTypography.heading3.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),

                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _availableAddOns.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {

                            final addon = _availableAddOns[index];
                            final isSelected = _selectedAddOnIds.contains(addon.id);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedAddOnIds.remove(addon.id);
                                  } else {
                                    _selectedAddOnIds.add(addon.id);
                                  }
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 140,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : AppColors.background,
                                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : AppColors.border,
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    if (addon.image != null) ...[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          addon.image!,
                                          width: 44,
                                          height: 44,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            addon.name,
                                            style: AppTypography.bodySmall.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textPrimary,
                                              fontSize: 12,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '+\$${addon.price.toStringAsFixed(2)}',
                                            style: AppTypography.caption.copyWith(
                                              color: isSelected ? AppColors.primary : AppColors.textLight,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      isSelected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                                      size: 18,
                                      color: isSelected ? AppColors.primary : AppColors.textMuted,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ],
            ),
          ),

          // Sticky Bottom Add To Cart Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedEntry(
              direction: SlideDirection.fromBottom,
              delay: const Duration(milliseconds: 250),
              duration: const Duration(milliseconds: 500),
              distance: 0.3,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: AppTheme.floatingShadow,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      final chosenAddOns = _availableAddOns
                          .where((a) => _selectedAddOnIds.contains(a.id))
                          .toList();

                      final provider = Provider.of<AppProvider>(context, listen: false);
                      provider.addToCart(
                        widget.food,
                        quantity: _quantity,
                        addOns: chosenAddOns,
                        note: _note,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.textPrimary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          content: Text(
                            'Added $_quantity x ${widget.food.name} to Cart!',
                            style: const TextStyle(color: Colors.white),
                          ),
                          action: SnackBarAction(
                            label: 'VIEW CART',
                            textColor: AppColors.gold,
                            onPressed: () {
                              Navigator.of(context).pop();
                              provider.setNavIndex(1);
                            },
                          ),
                        ),
                      );

                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textPrimary, // Dark black pill CTA from screenshot
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Add To Cart',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '· \$${_currentTotalPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.85)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }
}
