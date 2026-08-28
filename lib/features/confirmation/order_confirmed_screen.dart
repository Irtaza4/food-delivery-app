import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../core/models/order.dart';
import '../../core/state/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/animated_entry.dart';
import '../tracking/live_tracking_screen.dart';

class OrderConfirmedScreen extends StatelessWidget {
  final OrderModel order;

  const OrderConfirmedScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Animated Cooking Lottie Banner
              AnimatedEntry(
                direction: SlideDirection.fromTop,
                duration: const Duration(milliseconds: 600),
                distance: 0.3,
                enableScale: true,
                child: Center(
                  child: Container(
                    width: 220,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          blurRadius: 32,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Lottie.asset(
                        'assets/animations/chef_cooking.json',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.restaurant_menu_rounded,
                              size: 72,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Heading & Subtitle
              AnimatedEntry(
                direction: SlideDirection.fromBottom,
                delay: const Duration(milliseconds: 150),
                duration: const Duration(milliseconds: 500),
                distance: 0.2,
                child: Column(
                  children: [
                    Text(
                      'Order Confirmed!',
                      style: AppTypography.display.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your order #${order.id} has been received and is being freshly cooked at ${order.restaurantName}!',
                      textAlign: TextAlign.center,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textLight,
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Status Pill
              AnimatedEntry(
                direction: SlideDirection.fromBottom,
                delay: const Duration(milliseconds: 220),
                duration: const Duration(milliseconds: 450),
                distance: 0.2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.soup_kitchen_rounded, color: Color(0xFF22C55E), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Preparing in Kitchen · ETA: ${order.estimatedTime}',
                        style: const TextStyle(
                          color: Color(0xFF15803D),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Order Summary Card
              AnimatedEntry(
                direction: SlideDirection.fromBottom,
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 500),
                distance: 0.2,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.7)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Summary',
                            style: AppTypography.heading3.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${order.items.length} ${order.items.length == 1 ? 'Item' : 'Items'}',
                            style: AppTypography.caption.copyWith(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                      const Divider(height: 20, color: AppColors.divider),
                      ...order.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(item.food.image, width: 36, height: 36, fit: BoxFit.cover),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    '${item.quantity}x ${item.food.name}',
                                    style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
                                  ),
                                ),
                                Text(
                                  '\$${item.totalPrice.toStringAsFixed(2)}',
                                  style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                              ],
                            ),
                          )),
                      const Divider(height: 16, color: AppColors.divider),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Paid', style: AppTypography.heading3.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                          Text(
                            '\$${order.grandTotal.toStringAsFixed(2)}',
                            style: AppTypography.heading2.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Action Buttons
              AnimatedEntry(
                direction: SlideDirection.fromBottom,
                delay: const Duration(milliseconds: 380),
                duration: const Duration(milliseconds: 450),
                distance: 0.25,
                enableScale: true,
                child: Column(
                  children: [
                    // Track Order CTA
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => LiveTrackingScreen(order: order),
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
                        icon: const Icon(Icons.near_me_rounded, color: Colors.white, size: 18),
                        label: const Text(
                          'Track Live Order',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Back to Home Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          final provider = Provider.of<AppProvider>(context, listen: false);
                          provider.setNavIndex(0);
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.border, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Back to Home',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
