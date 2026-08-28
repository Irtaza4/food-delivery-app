import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';

enum ButtonVariant { primary, secondary, dark, outlineWhite }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final double height;
  final double? width;
  final Widget? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.height = AppTheme.buttonHeight,
    this.width,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    BorderSide borderSide = BorderSide.none;

    switch (variant) {
      case ButtonVariant.primary:
        bgColor = AppColors.primary;
        textColor = Colors.white;
        break;
      case ButtonVariant.secondary:
        bgColor = Colors.transparent;
        textColor = AppColors.primary;
        borderSide = const BorderSide(color: AppColors.primary, width: 1.5);
        break;
      case ButtonVariant.dark:
        bgColor = AppColors.textPrimary;
        textColor = Colors.white;
        break;
      case ButtonVariant.outlineWhite:
        bgColor = Colors.transparent;
        textColor = Colors.white;
        borderSide = const BorderSide(color: Colors.white, width: 1.5);
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            side: borderSide,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: AppTypography.button.copyWith(color: textColor),
                  ),
                ],
              ),
      ),
    );
  }
}
