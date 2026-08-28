class Restaurant {
  final String id;
  final String name;
  final String logo;
  final String bannerImage;
  final double rating;
  final String followers; // e.g. "234K"
  final int productsCount; // e.g. 5467
  final String cuisine;
  final String deliveryTime; // e.g. "10-20 min"
  final double deliveryCharge; // e.g. 3.5
  final double minOrder; // e.g. 37.0
  final String discountTag; // e.g. "50% Off" or "27% EXTRA DISCOUNT"
  final bool isFavorite;
  final List<String> categories;

  Restaurant({
    required this.id,
    required this.name,
    required this.logo,
    required this.bannerImage,
    required this.rating,
    required this.followers,
    required this.productsCount,
    required this.cuisine,
    required this.deliveryTime,
    required this.deliveryCharge,
    required this.minOrder,
    this.discountTag = "",
    this.isFavorite = false,
    this.categories = const ["Popular", "Burger", "Steak", "Pizza", "Appetizer"],
  });

  Restaurant copyWith({
    String? id,
    String? name,
    String? logo,
    String? bannerImage,
    double? rating,
    String? followers,
    int? productsCount,
    String? cuisine,
    String? deliveryTime,
    double? deliveryCharge,
    double? minOrder,
    String? discountTag,
    bool? isFavorite,
    List<String>? categories,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      bannerImage: bannerImage ?? this.bannerImage,
      rating: rating ?? this.rating,
      followers: followers ?? this.followers,
      productsCount: productsCount ?? this.productsCount,
      cuisine: cuisine ?? this.cuisine,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      minOrder: minOrder ?? this.minOrder,
      discountTag: discountTag ?? this.discountTag,
      isFavorite: isFavorite ?? this.isFavorite,
      categories: categories ?? this.categories,
    );
  }
}
