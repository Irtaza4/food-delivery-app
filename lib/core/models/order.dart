import 'cart_item.dart';

enum OrderDeliveryStatus {
  orderAccepted,
  checkingFood,
  foodsOnTheWay,
  deliveredToYou,
}

class TrackingTimelineStep {
  final String title;
  final String time;
  final bool isCompleted;
  final bool isActive;

  TrackingTimelineStep({
    required this.title,
    required this.time,
    required this.isCompleted,
    this.isActive = false,
  });
}

class DriverInfo {
  final String name;
  final String avatar;
  final double rating;
  final String phone;
  final String vehicle;

  DriverInfo({
    required this.name,
    required this.avatar,
    required this.rating,
    required this.phone,
    required this.vehicle,
  });
}

class OrderModel {
  final String id;
  final String restaurantName;
  final String restaurantLogo;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double vat;
  final double grandTotal;
  final String deliveryAddress;
  final DateTime orderTime;
  final String estimatedTime; // e.g. "5-10 min"
  final OrderDeliveryStatus status;
  final DriverInfo driver;
  final List<TrackingTimelineStep> timelineSteps;

  OrderModel({
    required this.id,
    required this.restaurantName,
    required this.restaurantLogo,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.vat,
    required this.grandTotal,
    required this.deliveryAddress,
    required this.orderTime,
    required this.estimatedTime,
    required this.status,
    required this.driver,
    required this.timelineSteps,
  });

  bool get isDelivered => status == OrderDeliveryStatus.deliveredToYou;
}
