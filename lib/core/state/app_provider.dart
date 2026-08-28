import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/cart_item.dart';

import '../models/order.dart';
import '../data/mock_data.dart';

class AppProvider extends ChangeNotifier {
  int _currentNavIndex = 0;
  String _selectedCategory = 'burger';
  String _searchQuery = '';
  String _deliveryLocation = 'Mirpur, Dhaka Bangladesh';
  
  // Promo code state
  String _appliedPromo = '';
  double _promoDiscountPercent = 0.0;

  // Cart
  final List<CartItem> _cartItems = [
    CartItem(
      id: 'cart_item_1',
      food: MockData.foodItems[4], // Vanilla Ice Cream $3.00
      quantity: 1,
    ),
    CartItem(
      id: 'cart_item_2',
      food: MockData.foodItems[5], // Hotdog Platter $4.00
      quantity: 1,
    ),
    CartItem(
      id: 'cart_item_3',
      food: MockData.foodItems[0], // Beef Spicy Burger $4.00
      quantity: 1,
    ),
  ];

  // Favorites
  final Set<String> _favoriteFoodIds = {'beef_spicy_burger', 'fried_chicken', 'vanilla_ice_cream'};
  final Set<String> _favoriteRestaurantIds = {'bk_bite', 'spice_craft'};

  // Orders
  OrderModel? _activeOrder = MockData.activeOrder;
  final List<OrderModel> _pastOrders = List.from(MockData.pastOrders);

  // Getters
  int get currentNavIndex => _currentNavIndex;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get deliveryLocation => _deliveryLocation;
  String get appliedPromo => _appliedPromo;
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);
  Set<String> get favoriteFoodIds => _favoriteFoodIds;
  Set<String> get favoriteRestaurantIds => _favoriteRestaurantIds;
  OrderModel? get activeOrder => _activeOrder;
  List<OrderModel> get pastOrders => List.unmodifiable(_pastOrders);

  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => _cartItems.isEmpty ? 0.0 : 2.00;
  double get promoDiscount => subtotal * _promoDiscountPercent;
  double get vat => subtotal > 0 ? (subtotal * 0.05) : 0.0; // 5% VAT
  double get grandTotal => (subtotal + deliveryFee + vat - promoDiscount).clamp(0.0, double.infinity);

  // Actions
  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  void setSelectedCategory(String categoryId) {
    _selectedCategory = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setDeliveryLocation(String location) {
    _deliveryLocation = location;
    notifyListeners();
  }

  // Cart actions
  void addToCart(FoodItem food, {int quantity = 1, List<AddOn> addOns = const [], String? note}) {
    // Check if same food with same addons exists
    final index = _cartItems.indexWhere((item) => item.food.id == food.id && _areAddOnsEqual(item.selectedAddOns, addOns));
    if (index != -1) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(CartItem(
        id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
        food: food,
        quantity: quantity,
        selectedAddOns: List.from(addOns),
        specialInstructions: note,
      ));
    }
    notifyListeners();
  }

  bool _areAddOnsEqual(List<AddOn> a, List<AddOn> b) {
    if (a.length != b.length) return false;
    final aIds = a.map((e) => e.id).toSet();
    final bIds = b.map((e) => e.id).toSet();
    return aIds.containsAll(bIds);
  }

  void incrementQuantity(String cartItemId) {
    final index = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      _cartItems[index].quantity += 1;
      notifyListeners();
    }
  }

  void decrementQuantity(String cartItemId) {
    final index = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity -= 1;
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String cartItemId) {
    _cartItems.removeWhere((item) => item.id == cartItemId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _appliedPromo = '';
    _promoDiscountPercent = 0.0;
    notifyListeners();
  }

  bool applyPromoCode(String code) {
    final clean = code.trim().toUpperCase();
    if (clean == 'FLAVOR27' || clean == 'DISCOUNT27' || clean == 'FOOD27') {
      _appliedPromo = clean;
      _promoDiscountPercent = 0.27; // 27% discount per banner
      notifyListeners();
      return true;
    } else if (clean == 'SAVE50' || clean == 'SPECIAL50') {
      _appliedPromo = clean;
      _promoDiscountPercent = 0.50;
      notifyListeners();
      return true;
    } else if (clean.isNotEmpty) {
      // General promo
      _appliedPromo = clean;
      _promoDiscountPercent = 0.15;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromoCode() {
    _appliedPromo = '';
    _promoDiscountPercent = 0.0;
    notifyListeners();
  }

  // Favorite actions
  bool isFavoriteFood(String foodId) => _favoriteFoodIds.contains(foodId);
  bool isFavoriteRestaurant(String restaurantId) => _favoriteRestaurantIds.contains(restaurantId);

  void toggleFavoriteFood(String foodId) {
    if (_favoriteFoodIds.contains(foodId)) {
      _favoriteFoodIds.remove(foodId);
    } else {
      _favoriteFoodIds.add(foodId);
    }
    notifyListeners();
  }

  void toggleFavoriteRestaurant(String restaurantId) {
    if (_favoriteRestaurantIds.contains(restaurantId)) {
      _favoriteRestaurantIds.remove(restaurantId);
    } else {
      _favoriteRestaurantIds.add(restaurantId);
    }
    notifyListeners();
  }

  // Order Placement
  OrderModel placeOrder({
    required String deliveryAddress,
    required String paymentMethod,
    String? promoCode,
  }) {
    final newOrder = OrderModel(
      id: '${10000 + DateTime.now().millisecond * 13}',
      restaurantName: _cartItems.isNotEmpty ? _cartItems.first.food.restaurantName : "BkBite's Hub",
      restaurantLogo: 'b',
      items: List.from(_cartItems),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: promoDiscount,
      vat: vat,
      grandTotal: grandTotal,
      deliveryAddress: deliveryAddress,
      orderTime: DateTime.now(),
      estimatedTime: '15-20 min',
      status: OrderDeliveryStatus.orderAccepted,
      driver: DriverInfo(
        name: 'David Williamson',
        avatar: 'assets/images/driver_avatar.jpg',
        rating: 4.8,
        phone: '+1 (555) 382-9910',
        vehicle: 'Yamaha Scooter • Red',
      ),
      timelineSteps: [
        TrackingTimelineStep(title: 'Order Accepted', time: 'Just now', isCompleted: true, isActive: true),
        TrackingTimelineStep(title: 'Checking Food', time: 'In 5 min', isCompleted: false),
        TrackingTimelineStep(title: 'Foods On the way', time: 'In 12 min', isCompleted: false),
        TrackingTimelineStep(title: 'Delivered to you', time: 'In 20 min', isCompleted: false),
      ],
    );

    _activeOrder = newOrder;
    clearCart();
    notifyListeners();
    return newOrder;
  }

  void advanceOrderStatus() {
    if (_activeOrder == null) return;
    final current = _activeOrder!.status;
    OrderDeliveryStatus next;
    List<TrackingTimelineStep> newSteps = List.from(_activeOrder!.timelineSteps);

    if (current == OrderDeliveryStatus.orderAccepted) {
      next = OrderDeliveryStatus.checkingFood;
      newSteps[0] = TrackingTimelineStep(title: 'Order Accepted', time: '06:20pm', isCompleted: true);
      newSteps[1] = TrackingTimelineStep(title: 'Checking Food', time: '06:30pm', isCompleted: true, isActive: true);
    } else if (current == OrderDeliveryStatus.checkingFood) {
      next = OrderDeliveryStatus.foodsOnTheWay;
      newSteps[1] = TrackingTimelineStep(title: 'Checking Food', time: '06:30pm', isCompleted: true);
      newSteps[2] = TrackingTimelineStep(title: 'Foods On the way', time: '06:36pm', isCompleted: true, isActive: true);
    } else {
      next = OrderDeliveryStatus.deliveredToYou;
      newSteps[2] = TrackingTimelineStep(title: 'Foods On the way', time: '06:36pm', isCompleted: true);
      newSteps[3] = TrackingTimelineStep(title: 'Delivered to you', time: '06:54pm', isCompleted: true, isActive: true);
      _pastOrders.insert(0, _activeOrder!);
    }

    _activeOrder = OrderModel(
      id: _activeOrder!.id,
      restaurantName: _activeOrder!.restaurantName,
      restaurantLogo: _activeOrder!.restaurantLogo,
      items: _activeOrder!.items,
      subtotal: _activeOrder!.subtotal,
      deliveryFee: _activeOrder!.deliveryFee,
      discount: _activeOrder!.discount,
      vat: _activeOrder!.vat,
      grandTotal: _activeOrder!.grandTotal,
      deliveryAddress: _activeOrder!.deliveryAddress,
      orderTime: _activeOrder!.orderTime,
      estimatedTime: next == OrderDeliveryStatus.deliveredToYou ? 'Delivered' : '5-10 min',
      status: next,
      driver: _activeOrder!.driver,
      timelineSteps: newSteps,
    );
    notifyListeners();
  }

  void reorder(OrderModel order) {
    clearCart();
    for (var item in order.items) {
      _cartItems.add(CartItem(
        id: 'reorder_${DateTime.now().millisecondsSinceEpoch}_${item.food.id}',
        food: item.food,
        quantity: item.quantity,
        selectedAddOns: List.from(item.selectedAddOns),
      ));
    }
    setNavIndex(1); // switch to Cart tab
    notifyListeners();
  }
}
