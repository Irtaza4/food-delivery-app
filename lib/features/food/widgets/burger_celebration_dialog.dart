import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/models/burger_ingredient.dart';
import '../../../core/models/food_item.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class BurgerCelebrationDialog extends StatefulWidget {
  final List<BurgerIngredient> layers;
  final double totalPrice;
  final int totalCalories;
  final Function(String customName, FoodItem customFood) onAddToCart;

  const BurgerCelebrationDialog({
    super.key,
    required this.layers,
    required this.totalPrice,
    required this.totalCalories,
    required this.onAddToCart,
  });

  @override
  State<BurgerCelebrationDialog> createState() => _BurgerCelebrationDialogState();
}

class _BurgerCelebrationDialogState extends State<BurgerCelebrationDialog>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController;
  late AnimationController _celebrationController;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    // Generate cool default title
    final hasZinger = widget.layers.any((i) => i.id == 'zinger_chicken');
    final hasBeef = widget.layers.any((i) => i.id == 'beef_patty');
    final hasEgg = widget.layers.any((i) => i.id == 'fried_egg');
    final hasBacon = widget.layers.any((i) => i.id == 'crispy_bacon');

    String defaultTitle = 'My Legendary Burger';
    if (hasZinger && hasBeef) {
      defaultTitle = 'The Monster Zinger Beast';
    } else if (hasZinger) {
      defaultTitle = 'Ultra Crunchy Zinger King';
    } else if (hasBeef && hasBacon) {
      defaultTitle = 'Smoky Bacon Smash King';
    } else if (hasEgg) {
      defaultTitle = 'The Sunrise Royal Stack';
    }

    _nameController = TextEditingController(text: defaultTitle);
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _handleAddToCart() {
    final customName = _nameController.text.trim().isEmpty
        ? 'Custom Crafted Burger'
        : _nameController.text.trim();

    final ingredientsSummary = widget.layers
        .where((l) => !l.isTopBun && !l.isBottomBun)
        .map((l) => l.name)
        .join(', ');

    final customFood = FoodItem(
      id: 'custom_burger_${DateTime.now().millisecondsSinceEpoch}',
      name: customName,
      restaurantId: 'bk_bite',
      restaurantName: "BkBite's DIY Kitchen",
      description: 'Handcrafted custom burger featuring ${widget.layers.length} artisanal layers: $ingredientsSummary.',
      ingredients: ingredientsSummary.isEmpty ? 'Toasted Brioche Buns' : ingredientsSummary,
      price: widget.totalPrice,
      rating: 5.0,
      reviewsCount: 1,
      deliveryTime: '15-20 min',
      categoryId: 'burger',
      image: 'assets/images/burger_hero.png',
      portion: '${widget.totalCalories} kcal (${widget.layers.length} Layers)',
      isPopular: true,
      isFeatured: true,
    );

    widget.onAddToCart(customName, customFood);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Main Card
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Trophy & Badge
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFB800), Color(0xFFFF7A00)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF9800).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🏆', style: TextStyle(fontSize: 32)),
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'MASTERPIECE CREATED!',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 8),

                // Name TextField
                TextField(
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  style: AppTypography.heading2.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Name your burger',
                    hintStyle: AppTypography.heading2.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 20,
                    ),
                    suffixIcon: const Icon(Icons.edit, size: 18, color: AppColors.textMuted),
                  ),
                ),

                const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),

                // Nutrition & Specs Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatPill('Layers', '${widget.layers.length}', '🍔', const Color(0xFF3B82F6)),
                    _buildStatPill('Energy', '${widget.totalCalories} kcal', '🔥', const Color(0xFFEA580C)),
                    _buildStatPill('Total', '\$${widget.totalPrice.toStringAsFixed(2)}', '💳', const Color(0xFF16A34A)),
                  ],
                ),

                const SizedBox(height: 20),

                // Recipe Breakdown Chips
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: widget.layers
                      .map((layer) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(layer.emoji, style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 4),
                                Text(
                                  layer.name.length > 14 ? '${layer.name.substring(0, 12)}..' : layer.name,
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),

                const SizedBox(height: 24),

                // CTA Button: Add to Cart & Feast
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handleAddToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: AppColors.primary.withValues(alpha: 0.4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Add to Cart • \$${widget.totalPrice.toStringAsFixed(2)}',
                          style: AppTypography.button.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Keep Editing Button
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Keep Crafting',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Animated Confetti Bursts
          ...List.generate(16, (i) {
            final random = math.Random(i * 99);
            final angle = (i / 16.0) * math.pi * 2;
            final distance = 140.0 + random.nextDouble() * 50.0;
            final colors = [
              const Color(0xFFFF5722),
              const Color(0xFFFFC107),
              const Color(0xFF4CAF50),
              const Color(0xFF2196F3),
              const Color(0xFFE91E63),
              const Color(0xFF9C27B0),
            ];

            return AnimatedBuilder(
              animation: _celebrationController,
              builder: (context, _) {
                final progress = Curves.easeOutBack.transform(_celebrationController.value);
                final offset = Offset(
                  math.cos(angle) * distance * progress,
                  math.sin(angle) * distance * progress - (progress * 30),
                );

                return Transform.translate(
                  offset: offset,
                  child: Transform.rotate(
                    angle: progress * math.pi * 2,
                    child: Opacity(
                      opacity: (1.0 - _celebrationController.value * 0.4).clamp(0.0, 1.0),
                      child: Container(
                        width: 8 + (i % 4) * 2.0,
                        height: 8 + (i % 3) * 2.0,
                        decoration: BoxDecoration(
                          color: colors[i % colors.length],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatPill(String title, String value, String emoji, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 4),
              Text(
                value,
                style: AppTypography.heading3.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: AppTypography.caption.copyWith(
              fontSize: 11,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
