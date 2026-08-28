import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_provider.dart';
import '../../core/theme/app_colors.dart';

import '../../core/theme/app_typography.dart';
import '../../core/theme/app_theme.dart';
import '../tracking/live_tracking_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Orders',
          style: AppTypography.heading2.copyWith(fontSize: 18),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textLight,
          labelStyle: AppTypography.heading3.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Active Order'),
            Tab(text: 'Past Orders'),
          ],
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return TabBarView(
            controller: _tabController,
            children: [
              // Active Orders Tab
              _buildActiveOrdersTab(context, provider),

              // Past Orders Tab
              _buildPastOrdersTab(context, provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActiveOrdersTab(BuildContext context, AppProvider provider) {
    final active = provider.activeOrder;
    if (active == null || active.isDelivered) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text('No active orders right now', style: AppTypography.heading3),
            const SizedBox(height: 8),
            Text('Order your favorite food to track delivery in real time.', style: AppTypography.bodySmall),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => provider.setNavIndex(0),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Order Now', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          boxShadow: AppTheme.cardShadow,
          border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      active.restaurantName,
                      style: AppTypography.heading3.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Order #${active.id} · Arriving in ${active.estimatedTime}',
                      style: AppTypography.caption.copyWith(color: AppColors.textLight),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'In Transit',
                    style: TextStyle(color: Color(0xFF22C55E), fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.divider),
            ),

            // Items list
            ...active.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(item.food.image, width: 44, height: 44, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${item.quantity}x ${item.food.name}',
                        style: AppTypography.body.copyWith(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: AppTypography.body.copyWith(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ],
                ),
              );
            }),

            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: AppColors.divider),
            ),

            // Total & Track Order Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Grand Total', style: AppTypography.caption.copyWith(color: AppColors.textLight)),
                    Text('\$${active.grandTotal.toStringAsFixed(2)}', style: AppTypography.heading2.copyWith(fontSize: 18, color: AppColors.textPrimary)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LiveTrackingScreen(order: active),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.near_me_rounded, size: 16, color: Colors.white),
                  label: const Text('Track Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastOrdersTab(BuildContext context, AppProvider provider) {
    final past = provider.pastOrders;
    if (past.isEmpty) {
      return Center(
        child: Text('No past orders yet', style: AppTypography.bodySmall),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: past.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {

        final order = past[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            boxShadow: AppTheme.cardShadow,
            border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Date & Delivered badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Oct 02 • 09:30pm',
                    style: AppTypography.caption.copyWith(color: AppColors.textLight, fontSize: 12),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Delivered',
                      style: TextStyle(color: Color(0xFF22C55E), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Restaurant & items
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      order.items.isNotEmpty ? order.items.first.food.image : 'assets/images/burger_hero.jpg',
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.items.isNotEmpty ? order.items.first.food.name : order.restaurantName,
                          style: AppTypography.heading3.copyWith(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Order ID: ${order.id} · ${order.items.length} Items',
                          style: AppTypography.caption.copyWith(color: AppColors.textLight, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${order.grandTotal.toStringAsFixed(2)}',
                    style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w800, fontSize: 14),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      provider.reorder(order);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Items added to cart! Proceeding to checkout.')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Order Again', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
