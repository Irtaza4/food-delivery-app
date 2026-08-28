import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

enum StepperStyle { horizontalPill, compactVertical }

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final StepperStyle style;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.style = StepperStyle.horizontalPill,
  });

  @override
  Widget build(BuildContext context) {
    if (style == StepperStyle.compactVertical) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onIncrement,
              child: Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: AppColors.textPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, size: 16, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                '$quantity',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            GestureDetector(
              onTap: onDecrement,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.remove, size: 16, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      );
    }

    // Horizontal pill (Food detail screen)
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrement,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Icon(Icons.remove, size: 18, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            quantity.toString().padLeft(2, '0'),
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onIncrement,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Icon(Icons.add, size: 18, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
