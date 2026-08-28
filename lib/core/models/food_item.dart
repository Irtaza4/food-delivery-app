class AddOn {
  final String id;
  final String name;
  final double price;
  final String? image;
  bool isSelected;

  AddOn({
    required this.id,
    required this.name,
    required this.price,
    this.image,
    this.isSelected = false,
  });

  AddOn copyWith({
    String? id,
    String? name,
    double? price,
    String? image,
    bool? isSelected,
  }) {
    return AddOn(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class FoodItem {
  final String id;
  final String name;
  final String restaurantId;
  final String restaurantName;
  final String description;
  final String ingredients;
  final double price;
  final double rating;
  final int reviewsCount;
  final String deliveryTime;
  final String categoryId;
  final String image;
  final String portion; // e.g. "250g (1 pcs)" or "1 Cup"
  final List<AddOn> addOns;
  final bool isPopular;
  final bool isFeatured;

  FoodItem({
    required this.id,
    required this.name,
    required this.restaurantId,
    required this.restaurantName,
    required this.description,
    required this.ingredients,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    required this.deliveryTime,
    required this.categoryId,
    required this.image,
    this.portion = "250g (1 pcs)",
    this.addOns = const [],
    this.isPopular = false,
    this.isFeatured = false,
  });
}
