import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../confirmation/order_confirmed_dialog.dart';

class PaymentCheckoutScreen extends StatefulWidget {
  const PaymentCheckoutScreen({super.key});

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  int _selectedPaymentMethod = 1; // 0: PayPal, 1: Card, 2: Apple Pay
  bool _termsAccepted = true;

  final TextEditingController _nameController = TextEditingController(text: 'David Williamson');
  final TextEditingController _cardController = TextEditingController(text: '5399 4820 1934 4242');
  final TextEditingController _expiryController = TextEditingController(text: '08/28');
  final TextEditingController _cvcController = TextEditingController(text: '884');

  @override
  void dispose() {
    _nameController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Payment',
          style: AppTypography.heading2.copyWith(fontSize: 18),
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment Methods Selection Cards
                _buildPaymentMethodTile(
                  index: 0,
                  title: 'Pay with PayPal',
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: const Color(0xFF003087),
                ),
                const SizedBox(height: 12),
                _buildPaymentMethodTile(
                  index: 1,
                  title: 'Credit & Debit Cards',
                  icon: Icons.credit_card_rounded,
                  iconColor: AppColors.primary,
                  trailingLogos: true,
                ),

                const SizedBox(height: 20),

                // Card Input Details Container
                if (_selectedPaymentMethod == 1) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      boxShadow: AppTheme.cardShadow,
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Cardholder Name',
                          hintText: 'Full Name on Card',
                          controller: _nameController,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          label: 'Card Number',
                          hintText: '•••• •••• •••• ••••',
                          controller: _cardController,
                          keyboardType: TextInputType.number,
                          suffixIcon: const Icon(Icons.credit_card, color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: 'MM/YY',
                                hintText: 'MM/YY',
                                controller: _expiryController,
                                keyboardType: TextInputType.datetime,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: CustomTextField(
                                label: 'CVC',
                                hintText: 'CVC',
                                controller: _cvcController,
                                keyboardType: TextInputType.number,
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Terms of use Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _termsAccepted,
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (val) => setState(() => _termsAccepted = val ?? false),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'I have read and accept the terms of use, rules of delivery and privacy policy',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Delivery Address with Map Thumbnail Card
                Text(
                  'Delivery Address',
                  style: AppTypography.heading3.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    boxShadow: AppTheme.cardShadow,
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
                  ),
                  child: Row(
                    children: [
                      // Mini Map Thumbnail
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            CustomPaint(
                              size: const Size(70, 70),
                              painter: _MiniMapPainter(),
                            ),
                            const Center(
                              child: Icon(Icons.location_on_rounded, color: AppColors.primary, size: 24),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Address info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Home',
                              style: AppTypography.heading3.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              provider.deliveryLocation,
                              style: AppTypography.bodySmall.copyWith(fontSize: 12, color: AppColors.textLight),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),

                      // Change action
                      TextButton(
                        onPressed: () {},
                        child: const Text('Change', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Price Summary Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount',
                          style: AppTypography.caption.copyWith(color: AppColors.textMuted, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '\$${provider.grandTotal.toStringAsFixed(2)}',
                          style: AppTypography.display.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'See price details',
                      style: AppTypography.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Place Order Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _termsAccepted
                        ? () {
                            final order = provider.placeOrder(
                              deliveryAddress: provider.deliveryLocation,
                              paymentMethod: _selectedPaymentMethod == 1 ? 'Credit Card' : 'PayPal',
                            );

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => OrderConfirmedDialog(order: order),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Place Order · \$${provider.grandTotal.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
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

  Widget _buildPaymentMethodTile({
    required int index,
    required String title,
    required IconData icon,
    required Color iconColor,
    bool trailingLogos = false,
  }) {
    final isSelected = _selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: AppTypography.heading3.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (trailingLogos) ...[
              const Row(
                children: [
                  Text('VISA', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF1A1F71), fontSize: 12)),
                  SizedBox(width: 6),
                  Text('MC', style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFEB001B), fontSize: 12)),
                  SizedBox(width: 8),
                ],
              ),
            ],
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(const Offset(0, 20), Offset(size.width, 35), paint);
    canvas.drawLine(const Offset(20, 0), Offset(30, size.height), paint);
    canvas.drawLine(const Offset(0, 55), Offset(size.width, 50), paint);
    canvas.drawLine(const Offset(50, 0), Offset(45, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
