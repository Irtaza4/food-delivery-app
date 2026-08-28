import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class RatingBadge extends StatelessWidget {
  final double rating;
  final int? reviewsCount;
  final bool showStarIcon;
  final Color? textColor;

  const RatingBadge({
    super.key,
    required this.rating,
    this.reviewsCount,
    this.showStarIcon = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showStarIcon) ...[
          const Icon(
            Icons.star_rounded,
            size: 16,
            color: AppColors.gold,
          ),
          const SizedBox(width: 4),
        ],
        Text(
          rating.toStringAsFixed(1),
          style: AppTypography.caption.copyWith(
            color: textColor ?? AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        if (reviewsCount != null) ...[
          const SizedBox(width: 3),
          Text(
            '($reviewsCount+)',
            style: AppTypography.caption.copyWith(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w400,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }
}
