import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/models/burger_ingredient.dart';
import '../../core/state/app_provider.dart';
import '../../core/theme/app_typography.dart';
import 'widgets/burger_stack_canvas.dart';
import 'widgets/burger_celebration_dialog.dart';

class DIYBurgerScreen extends StatefulWidget {
  const DIYBurgerScreen({super.key});

  @override
  State<DIYBurgerScreen> createState() => _DIYBurgerScreenState();
}

class _DIYBurgerScreenState extends State<DIYBurgerScreen> {
  // Current burger stack
  late List<BurgerIngredient> _layers;

  // Selected Category filter for ingredients dock
  IngredientCategory? _selectedCategory;

  // Exploded slow-mo view toggle
  bool _isExploded = false;
  bool _showLabels = false;

  // Active sauce splatter
  Color? _activeSauceColor;

  @override
  void initState() {
    super.initState();
    _resetToDefault();
  }

  void _resetToDefault() {
    _layers = [
      BurgerIngredient.bottomBun,
      BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'beef_patty'),
      BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'cheddar_cheese'),
      BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'fresh_lettuce'),
      BurgerIngredient.topBun,
    ];
  }

  double get _totalPrice => _layers.fold(0.0, (sum, item) => sum + item.price);
  int get _totalCalories => _layers.fold(0, (sum, item) => sum + item.calories);
  bool get _hasTopBun => _layers.isNotEmpty && _layers.last.isTopBun;

  void _addIngredient(BurgerIngredient ingredient) {
    HapticFeedback.mediumImpact();

    setState(() {
      if (ingredient.isSauce) {
        _activeSauceColor = ingredient.colorAccent;
      }

      if (ingredient.isTopBun) {
        // Remove existing top bun if present and put at top
        _layers.removeWhere((l) => l.isTopBun);
        _layers.add(ingredient);
      } else if (ingredient.isBottomBun) {
        // Replace base
        _layers[0] = ingredient;
      } else {
        // Insert right before top bun if top bun exists, else at end
        if (_hasTopBun) {
          _layers.insert(_layers.length - 1, ingredient);
        } else {
          _layers.add(ingredient);
        }
      }
    });
  }

  void _removeLayer(int index) {
    if (index >= 0 && index < _layers.length) {
      if (_layers[index].isBottomBun) return; // Don't remove bottom bun
      HapticFeedback.lightImpact();
      setState(() {
        _layers.removeAt(index);
      });
    }
  }

  void _undoLast() {
    if (_layers.length > 1) {
      HapticFeedback.lightImpact();
      setState(() {
        if (_hasTopBun && _layers.length > 2) {
          _layers.removeAt(_layers.length - 2);
        } else {
          _layers.removeLast();
        }
      });
    }
  }

  void _applyPreset(PresetBurgerRecipe preset) {
    HapticFeedback.heavyImpact();
    setState(() {
      _layers = List.from(preset.ingredients);
    });
  }

  void _showFinishDialog() {
    HapticFeedback.heavyImpact();

    // If no top bun, close it automatically for presentation
    if (!_hasTopBun) {
      _layers.add(BurgerIngredient.topBun);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => BurgerCelebrationDialog(
        layers: _layers,
        totalPrice: _totalPrice,
        totalCalories: _totalCalories,
        onAddToCart: (customName, customFood) {
          Navigator.of(dialogCtx).pop();

          final provider = Provider.of<AppProvider>(context, listen: false);
          provider.addToCart(customFood, quantity: 1);

          // Show success snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '🎉 $customName added to cart!',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF22C55E),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              action: SnackBarAction(
                label: 'VIEW CART',
                textColor: Colors.white,
                onPressed: () {
                  provider.setNavIndex(1); // switch to cart
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredIngredients = _selectedCategory == null
        ? BurgerIngredient.allIngredients.where((i) => !i.isBottomBun).toList()
        : BurgerIngredient.allIngredients
            .where((i) => i.category == _selectedCategory && !i.isBottomBun)
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121418), // Sleek Studio Dark Background
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Navigation & Actions Bar
            _buildTopAppBar(context),

            // Real-time Live Stats Pill (Price, Calories, Layers)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: _buildLiveStatsPill(),
            ),

            // Center Interactive Burger Stage Canvas
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Ambient Stage Glow
                  Positioned(
                    top: 40,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFFFF6A00).withValues(alpha: 0.18),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // The Burger Stack Canvas
                  BurgerStackCanvas(
                    layers: _layers,
                    isExploded: _isExploded,
                    showLabels: _showLabels,
                    hasTopBun: _hasTopBun,
                    activeSauceSplatter: _activeSauceColor,
                    onSauceSplatterComplete: () {
                      setState(() => _activeSauceColor = null);
                    },
                    onRemoveLayer: _removeLayer,
                    onAddTopBun: () => _addIngredient(BurgerIngredient.topBun),
                  ),

                  // Floating View Controls (Explode / Reset / Preset)
                  Positioned(
                    right: 16,
                    top: 12,
                    child: Column(
                      children: [
                        // Explode 3D Toggle Button (Reel feature)
                        _buildFloatingActionButton(
                          icon: _isExploded ? Icons.layers_clear_rounded : Icons.layers_rounded,
                          tooltip: _isExploded ? 'Collapse' : 'Explode View',
                          isActive: _isExploded,
                          activeColor: const Color(0xFFFF8800),
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _isExploded = !_isExploded);
                          },
                        ),
                        const SizedBox(height: 10),

                        // Layer Info Toggle Button
                        _buildFloatingActionButton(
                          icon: Icons.info_outline_rounded,
                          tooltip: 'Show Info',
                          isActive: _showLabels,
                          activeColor: const Color(0xFF3B82F6),
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() => _showLabels = !_showLabels);
                          },
                        ),
                        const SizedBox(height: 10),

                        // Undo Last Button
                        _buildFloatingActionButton(
                          icon: Icons.undo_rounded,
                          tooltip: 'Undo Layer',
                          isActive: false,
                          onTap: _undoLast,
                        ),
                      ],
                    ),
                  ),

                  // Presets Quick Chip
                  Positioned(
                    left: 16,
                    top: 12,
                    child: GestureDetector(
                      onTap: _showPresetsSheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('✨', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(
                              'Presets',
                              style: AppTypography.caption.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down_rounded, color: Colors.white70, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Ingredients Dock with Category Tabs
            Container(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              decoration: const BoxDecoration(
                color: Color(0xFF1E222B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 24,
                    offset: Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category Tabs Bar
                  _buildCategoryFilterTabs(),

                  const SizedBox(height: 14),

                  // Horizontal Ingredients Cards Dock
                  SizedBox(
                    height: 148,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredIngredients.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final ingredient = filteredIngredients[index];
                        final countInBurger = _layers.where((l) => l.id == ingredient.id).length;

                        return _buildIngredientCard(ingredient, countInBurger);
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Finish & Order Action Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        // Clear All Button
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            setState(() => _resetToDefault());
                          },
                          child: Container(
                            width: 50,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                            ),
                            child: const Icon(Icons.refresh_rounded, color: Colors.white70, size: 22),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Finish & Order Button
                        Expanded(
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6A00), Color(0xFFEE0979)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF6A00).withValues(alpha: 0.45),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _showFinishDialog,
                                borderRadius: BorderRadius.circular(16),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Finish & Feast • \$${_totalPrice.toStringAsFixed(2)}',
                                        style: AppTypography.button.copyWith(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
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
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            ),
          ),

          // Title
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🍔', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 6),
                  Text(
                    'DIY Burger Studio',
                    style: AppTypography.heading2.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              Text(
                'Reel Mode • Tap to Stack',
                style: AppTypography.caption.copyWith(
                  color: const Color(0xFFFF8800),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),

          // Reel Camera / Share Button
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('📸 Reel Camera Mode Ready! Record your screen & craft your burger!'),
                  backgroundColor: const Color(0xFFE11D48),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE11D48), Color(0xFF9333EA)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE11D48).withValues(alpha: 0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveStatsPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Total Price
          Row(
            children: [
              const Text('💳', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 6),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  '\$${_totalPrice.toStringAsFixed(2)}',
                  key: ValueKey('price_$_totalPrice'),
                  style: AppTypography.heading3.copyWith(
                    color: const Color(0xFF22C55E),
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),

          Container(width: 1, height: 16, color: Colors.white24),

          // Total Calories
          Row(
            children: [
              const Text('🔥', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 6),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  '$_totalCalories kcal',
                  key: ValueKey('cal_$_totalCalories'),
                  style: AppTypography.heading3.copyWith(
                    color: const Color(0xFFF97316),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          Container(width: 1, height: 16, color: Colors.white24),

          // Layer Count
          Row(
            children: [
              const Text('🥞', style: TextStyle(fontSize: 13)),
              const SizedBox(width: 6),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  '${_layers.length} Layers',
                  key: ValueKey('layers_${_layers.length}'),
                  style: AppTypography.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton({
    required IconData icon,
    required String tooltip,
    required bool isActive,
    Color activeColor = const Color(0xFFFF6A00),
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.black.withValues(alpha: 0.5),
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isActive ? activeColor.withValues(alpha: 0.4) : Colors.black38,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildCategoryFilterTabs() {
    final categories = [
      (null, '✨ All'),
      (IngredientCategory.meat, '🥩 Meats'),
      (IngredientCategory.cheese, '🧀 Cheese'),
      (IngredientCategory.veggie, '🥬 Veggies'),
      (IngredientCategory.sauce, '🥫 Sauces'),
      (IngredientCategory.extra, '🍳 Extras'),
      (IngredientCategory.bun, '🍞 Buns'),
    ];

    return SizedBox(
      height: 34,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index].$1;
          final label = categories[index].$2;
          final isSelected = _selectedCategory == cat;

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selectedCategory = cat);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF6A00) : Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.white.withValues(alpha: 0.12),
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIngredientCard(BurgerIngredient ingredient, int countInBurger) {
    return GestureDetector(
      onTap: () => _addIngredient(ingredient),
      child: Container(
        width: 132,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2B303C),
              const Color(0xFF1E222B),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: countInBurger > 0
                ? ingredient.colorAccent.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.12),
            width: countInBurger > 0 ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: countInBurger > 0
                  ? ingredient.colorAccent.withValues(alpha: 0.3)
                  : Colors.black26,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Image.asset(
                        ingredient.image,
                        fit: BoxFit.contain,
                        height: 52,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                // Name with Emoji
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(ingredient.emoji, style: const TextStyle(fontSize: 11)),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        ingredient.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Price & Add Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '+\$${ingredient.price.toStringAsFixed(2)}',
                      style: AppTypography.caption.copyWith(
                        color: const Color(0xFF22C55E),
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: ingredient.colorAccent.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: ingredient.colorAccent, size: 14),
                    ),
                  ],
                ),
              ],
            ),

            // Active Count Badge if > 0
            if (countInBurger > 0)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: ingredient.colorAccent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: ingredient.colorAccent.withValues(alpha: 0.4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    'x$countInBurger',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showPresetsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E222B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chef Preset Recipes 👨‍🍳',
                    style: AppTypography.heading2.copyWith(color: Colors.white, fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...PresetBurgerRecipe.presets.map((preset) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    title: Row(
                      children: [
                        Text(
                          preset.name,
                          style: AppTypography.heading3.copyWith(color: Colors.white, fontSize: 15),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6A00).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            preset.badge,
                            style: const TextStyle(
                              color: Color(0xFFFF8800),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        preset.description,
                        style: AppTypography.caption.copyWith(color: Colors.white60, fontSize: 11),
                      ),
                    ),
                    trailing: Text(
                      '\$${preset.totalPrice.toStringAsFixed(2)}',
                      style: AppTypography.heading3.copyWith(color: const Color(0xFF22C55E), fontSize: 15),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _applyPreset(preset);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
