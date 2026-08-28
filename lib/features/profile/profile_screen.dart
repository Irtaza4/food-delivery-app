import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';
import '../onboarding/onboarding_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTypography.heading2.copyWith(fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        child: Column(
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                boxShadow: AppTheme.cardShadow,
                border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/images/driver_avatar.jpg',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'David Williamson',
                          style: AppTypography.heading3.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'david.williamson@flavor.app',
                          style: AppTypography.caption.copyWith(color: AppColors.textLight, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+1 (555) 382-9910',
                          style: AppTypography.caption.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Profile Options Menu
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                boxShadow: AppTheme.cardShadow,
                border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Personal Information',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  Consumer<AppProvider>(
                    builder: (context, provider, _) {
                      return _buildMenuItem(
                        icon: Icons.location_on_outlined,
                        title: 'Saved Addresses',
                        subtitle: provider.deliveryLocation,
                        onTap: () {},
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.credit_card_rounded,
                    title: 'Payment Methods',
                    subtitle: 'Mastercard •••• 4242',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    trailing: Switch.adaptive(
                      value: true,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) {},
                    ),
                  ),

                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Terms & Privacy',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Log Out Button
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                boxShadow: AppTheme.cardShadow,
                border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
              ),
              child: _buildMenuItem(
                icon: Icons.logout_rounded,
                iconColor: AppColors.primary,
                title: 'Log Out',
                textColor: AppColors.primary,
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color iconColor = AppColors.textPrimary,
    Color textColor = AppColors.textPrimary,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textLight))
          : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(color: AppColors.divider, height: 1),
    );
  }
}
