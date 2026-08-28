import 'food_item.dart';

class CartItem {
  final String id;
  final FoodItem food;
  int quantity;
  final List<AddOn> selectedAddOns;
  final String? specialInstructions;

  CartItem({
    required this.id,
    required this.food,
    this.quantity = 1,
    this.selectedAddOns = const [],
    this.specialInstructions,
  });

  double get unitPrice {
    double total = food.price;
    for (var addon in selectedAddOns) {
      total += addon.price;
    }
    return total;
  }

  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    String? id,
    FoodItem? food,
    int? quantity,
    List<AddOn>? selectedAddOns,
    String? specialInstructions,
  }) {
    return CartItem(
      id: id ?? this.id,
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      selectedAddOns: selectedAddOns ?? this.selectedAddOns,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}
