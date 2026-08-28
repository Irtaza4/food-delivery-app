import 'package:flutter/material.dart';
import '../../core/models/order.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

import '../tracking/live_tracking_screen.dart';

class OrderConfirmedDialog extends StatelessWidget {
  final OrderModel order;

  const OrderConfirmedDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Confetti Delivery Box Asset
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.05),
              ),
              padding: const EdgeInsets.all(12),
              child: Image.asset(
                'assets/images/order_box.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),

            // Heading
            Text(
              'Order Confirmed!',
              style: AppTypography.heading1.copyWith(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Your order #${order.id} has been sent to ${order.restaurantName}. Preparing now!',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textLight,
                height: 1.4,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),

            // Info Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Est. Delivery', style: AppTypography.caption.copyWith(color: AppColors.textMuted)),
                      const SizedBox(height: 2),
                      Text(order.estimatedTime, style: AppTypography.heading3.copyWith(fontSize: 14, color: AppColors.textPrimary)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Total Paid', style: AppTypography.caption.copyWith(color: AppColors.textMuted)),
                      const SizedBox(height: 2),
                      Text('\$${order.grandTotal.toStringAsFixed(2)}', style: AppTypography.heading3.copyWith(fontSize: 14, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Track Order CTA
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LiveTrackingScreen(order: order),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text('Track Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
            const SizedBox(height: 10),

            // Back to Home
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text(
                'Back to Home',
                style: AppTypography.button.copyWith(color: AppColors.textLight, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
