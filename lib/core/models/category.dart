class FoodCategory {
  final String id;
  final String name;
  final String iconEmoji;
  final String? imageAsset;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.iconEmoji,
    this.imageAsset,
  });
}
