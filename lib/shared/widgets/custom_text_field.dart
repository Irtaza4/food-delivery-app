import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final String? label;
  final VoidCallback? onSuffixTap;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.label,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: AppTypography.body.copyWith(color: AppColors.textMuted),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (suffixIcon != null) ...[
                GestureDetector(
                  onTap: onSuffixTap,
                  child: suffixIcon!,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
