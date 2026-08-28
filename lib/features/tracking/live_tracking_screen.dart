import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/order.dart';
import '../../core/state/app_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/interactive_map.dart';

class LiveTrackingScreen extends StatefulWidget {
  final OrderModel order;

  const LiveTrackingScreen({super.key, required this.order});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final TextEditingController _msgController = TextEditingController();

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              boxShadow: AppTheme.cardShadow,
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
          ),
        ),
        title: Text(
          'Tracking',
          style: AppTypography.heading2.copyWith(fontSize: 18),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Live delivery link shared!')),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.share_rounded, color: AppColors.textPrimary, size: 20),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final currentOrder = provider.activeOrder ?? widget.order;

          return Column(
            children: [
              // Interactive Vector Live Map with Courier Animation
              InteractiveTrackingMap(
                height: 280,
                estimatedTime: currentOrder.estimatedTime,
              ),

              // Bottom Details Sheet (Driver Info & Status Timeline)
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Driver Information Row matching screenshot
                        Row(
                          children: [
                            // Driver Avatar Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                currentOrder.driver.avatar,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Driver Name & subtext
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Being delivered by',
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.textMuted,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    currentOrder.driver.name,
                                    style: AppTypography.heading3.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Rating
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 16, color: AppColors.gold),
                                const SizedBox(width: 4),
                                Text(
                                  '${currentOrder.driver.rating}',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Rating',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Send Message Field & Call Button
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 46,
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(23),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppColors.textMuted),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: _msgController,
                                        decoration: InputDecoration(
                                          hintText: 'Send Message',
                                          hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                        onSubmitted: (val) {
                                          if (val.trim().isNotEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Message sent to ${currentOrder.driver.name}')),
                                            );
                                            _msgController.clear();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Orange round call button
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Calling ${currentOrder.driver.phone}...')),
                                );
                              },
                              child: Container(
                                width: 46,
                                height: 46,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE25B38), // Signature orange-red call button
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.phone_rounded, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Timeline Steps Section
                        ...List.generate(currentOrder.timelineSteps.length, (index) {
                          final step = currentOrder.timelineSteps[index];
                          final isLast = index == currentOrder.timelineSteps.length - 1;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Timeline indicator & line
                              Column(
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: step.isCompleted
                                          ? const Color(0xFF22C55E) // Green completed
                                          : (step.isActive ? AppColors.primary : Colors.white),
                                      border: Border.all(
                                        color: step.isCompleted
                                            ? const Color(0xFF22C55E)
                                            : (step.isActive ? AppColors.primary : AppColors.border),
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: step.isCompleted
                                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                                          : (step.isActive
                                              ? Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle))
                                              : null),
                                    ),
                                  ),
                                  if (!isLast)
                                    Container(
                                      width: 2,
                                      height: 32,
                                      color: step.isCompleted ? const Color(0xFF22C55E) : AppColors.border,
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),

                              // Title & Time
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        step.title,
                                        style: TextStyle(
                                          fontWeight: step.isActive ? FontWeight.w800 : (step.isCompleted ? FontWeight.w600 : FontWeight.w500),
                                          color: step.isActive ? AppColors.textPrimary : (step.isCompleted ? AppColors.textPrimary : AppColors.textLight),
                                          fontSize: 13.5,
                                        ),
                                      ),
                                      Text(
                                        step.time,
                                        style: AppTypography.caption.copyWith(
                                          color: AppColors.textLight,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),

                        const SizedBox(height: 20),

                        // Advance Status (Demo helper button)
                        Center(
                          child: TextButton.icon(
                            onPressed: () => provider.advanceOrderStatus(),
                            icon: const Icon(Icons.refresh_rounded, size: 16, color: AppColors.accent),
                            label: const Text(
                              'Simulate Next Delivery Status',
                              style: TextStyle(color: AppColors.accent, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
