import 'package:flutter/material.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/food_item.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/food_card.dart';
import '../food/food_detail_screen.dart';

class CategoryGridScreen extends StatefulWidget {
  final String categoryTitle;
  final String? initialCategoryId;

  const CategoryGridScreen({
    super.key,
    required this.categoryTitle,
    this.initialCategoryId,
  });

  @override
  State<CategoryGridScreen> createState() => _CategoryGridScreenState();
}

class _CategoryGridScreenState extends State<CategoryGridScreen> {
  String _selectedSort = 'Popular';
  String _selectedOffer = 'All';
  String _selectedPriceFilter = 'All';
  final String _searchQuery = '';


  @override
  Widget build(BuildContext context) {
    // Filter food items based on category, search, and sort
    List<FoodItem> items = List.from(MockData.foodItems);

    if (widget.initialCategoryId != null && widget.initialCategoryId != 'all') {
      items = items.where((item) => item.categoryId == widget.initialCategoryId || widget.categoryTitle.toLowerCase().contains(item.categoryId)).toList();
      if (items.isEmpty) {
        items = List.from(MockData.foodItems); // fallback to all items if category has few
      }
    }

    if (_searchQuery.isNotEmpty) {
      items = items.where((item) =>
        item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        item.restaurantName.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Sort items
    if (_selectedSort == 'Price: Low to High') {
      items.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == 'Rating') {
      items.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: AppTheme.cardShadow,
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
          ),
        ),
        title: Text(
          widget.categoryTitle,
          style: AppTypography.heading2.copyWith(fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          // Filter and Sort Chips Row matching screenshots
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Filter icon chip
                  GestureDetector(
                    onTap: () => _showFilterSheet(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                        boxShadow: AppTheme.cardShadow,
                      ),
                      child: const Icon(Icons.tune_rounded, size: 18, color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Sort dropdown chip
                  _buildDropdownChip(
                    label: 'Sort',
                    currentValue: _selectedSort,
                    options: ['Popular', 'Rating', 'Price: Low to High'],
                    onSelected: (val) => setState(() => _selectedSort = val),
                  ),
                  const SizedBox(width: 8),

                  // Offer dropdown chip
                  _buildDropdownChip(
                    label: 'Offer',
                    currentValue: _selectedOffer,
                    options: ['All', '27% Off', '50% Off', 'Free Delivery'],
                    onSelected: (val) => setState(() => _selectedOffer = val),
                  ),
                  const SizedBox(width: 8),

                  // Price dropdown chip
                  _buildDropdownChip(
                    label: 'Price',
                    currentValue: _selectedPriceFilter,
                    options: ['All', 'Under \$4', 'Under \$6'],
                    onSelected: (val) => setState(() => _selectedPriceFilter = val),
                  ),
                ],
              ),
            ),
          ),

          // Food Grid (2 Columns)
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 64, color: AppColors.textMuted),
                        const SizedBox(height: 16),
                        Text(
                          'No dishes found',
                          style: AppTypography.heading3.copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Try clearing search or changing filters.',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (context, index) {
                      final food = items[index];
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
      ),
    );
  }

  Widget _buildDropdownChip({
    required String label,
    required String currentValue,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    final hasSelection = currentValue != 'Popular' && currentValue != 'All';
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (context) {
        return options.map((opt) {
          return PopupMenuItem<String>(
            value: opt,
            child: Text(opt, style: const TextStyle(fontSize: 13)),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: hasSelection ? AppColors.primary.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasSelection ? AppColors.primary : AppColors.border,
            width: hasSelection ? 1.5 : 1,
          ),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              hasSelection ? currentValue : label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: hasSelection ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: hasSelection ? AppColors.primary : AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
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
              Text('Filter Options', style: AppTypography.heading2.copyWith(fontSize: 18)),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Reset All Filters'),
                leading: const Icon(Icons.refresh_rounded),
                onTap: () {
                  setState(() {
                    _selectedSort = 'Popular';
                    _selectedOffer = 'All';
                    _selectedPriceFilter = 'All';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
