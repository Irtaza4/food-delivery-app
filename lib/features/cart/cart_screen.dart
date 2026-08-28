import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/quantity_stepper.dart';
import '../checkout/payment_screen.dart';

class CartScreen extends StatefulWidget {
  final bool showBackButton;

  const CartScreen({super.key, this.showBackButton = false});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: widget.showBackButton
            ? GestureDetector(
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
              )
            : null,
        title: Text(
          'My Cart',
          style: AppTypography.heading2.copyWith(fontSize: 18),
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final items = provider.cartItems;

          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your cart is empty',
                      style: AppTypography.heading2.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover something delicious and start your next order.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 200,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => provider.setNavIndex(0),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text('Explore Food', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cart Items List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {

                    final item = items[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                        boxShadow: AppTheme.cardShadow,
                        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
                      ),
                      child: Row(
                        children: [
                          // Food Image
                          Container(
                            width: 72,
                            height: 72,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F6F4),
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                            ),
                            child: Image.asset(
                              item.food.image,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Name, portion, price
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.food.name,
                                  style: AppTypography.heading3.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.food.portion,
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textLight,
                                    fontSize: 11,
                                  ),
                                ),
                                if (item.selectedAddOns.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    '+ ${item.selectedAddOns.map((a) => a.name).join(', ')}',
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.primary,
                                      fontSize: 10,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                const SizedBox(height: 8),
                                Text(
                                  '\$${item.totalPrice.toStringAsFixed(2)}',
                                  style: AppTypography.heading3.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Vertical Stepper (+ 1 -)
                          QuantityStepper(
                            quantity: item.quantity,
                            style: StepperStyle.compactVertical,
                            onIncrement: () => provider.incrementQuantity(item.id),
                            onDecrement: () => provider.decrementQuantity(item.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Promo Code Box matching screenshots
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    boxShadow: AppTheme.cardShadow,
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.confirmation_number_outlined, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _promoController,
                          decoration: InputDecoration(
                            hintText: provider.appliedPromo.isNotEmpty ? provider.appliedPromo : 'Promo Code (e.g. FLAVOR27)',
                            hintStyle: AppTypography.bodySmall.copyWith(
                              color: provider.appliedPromo.isNotEmpty ? AppColors.primary : AppColors.textMuted,
                              fontWeight: provider.appliedPromo.isNotEmpty ? FontWeight.bold : FontWeight.normal,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () {
                            if (provider.appliedPromo.isNotEmpty) {
                              provider.removePromoCode();
                              _promoController.clear();
                            } else {
                              final success = provider.applyPromoCode(_promoController.text);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: AppColors.primary,
                                    content: Text('Promo Code ${_promoController.text} Applied!'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter a valid code (e.g. FLAVOR27)')),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: Text(
                            provider.appliedPromo.isNotEmpty ? 'Remove' : 'Apply Code',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Bill Details Section
                Text(
                  'Bill Details',
                  style: AppTypography.heading2.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    boxShadow: AppTheme.cardShadow,
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
                  ),
                  child: Column(
                    children: [
                      _buildBillRow('Product Price', '\$${provider.subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 10),
                      _buildBillRow('Delivery Charge', '\$${provider.deliveryFee.toStringAsFixed(2)}'),
                      if (provider.promoDiscount > 0) ...[
                        const SizedBox(height: 10),
                        _buildBillRow('Promo Discount', '-\$${provider.promoDiscount.toStringAsFixed(2)}', isDiscount: true),
                      ],
                      const SizedBox(height: 10),
                      _buildBillRow('VAT / Taxes (5%)', '\$${provider.vat.toStringAsFixed(2)}'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: AppColors.divider, height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grand Total',
                            style: AppTypography.heading3.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '\$${provider.grandTotal.toStringAsFixed(2)}',
                            style: AppTypography.heading1.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Proceed to Checkout CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PaymentCheckoutScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textPrimary,
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
                          'Proceed to Checkout',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '· \$${provider.grandTotal.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 15, color: Colors.white.withValues(alpha: 0.8)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBillRow(String label, String amount, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isDiscount ? AppColors.accent : AppColors.textLight,
            fontWeight: isDiscount ? FontWeight.w600 : FontWeight.w400,
            fontSize: 13,
          ),
        ),
        Text(
          amount,
          style: AppTypography.body.copyWith(
            fontWeight: FontWeight.w700,
            color: isDiscount ? AppColors.accent : AppColors.textPrimary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
