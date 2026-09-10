import 'package:flutter/material.dart';

enum IngredientCategory {
  bun,
  meat,
  cheese,
  veggie,
  sauce,
  extra,
}

class BurgerIngredient {
  final String id;
  final String name;
  final IngredientCategory category;
  final double price;
  final int calories;
  final String image;
  final double layerHeight;
  final Color colorAccent;
  final String emoji;
  final String tagline;
  final bool isSauce;
  final bool isTopBun;
  final bool isBottomBun;

  const BurgerIngredient({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.calories,
    required this.image,
    this.layerHeight = 32.0,
    required this.colorAccent,
    required this.emoji,
    required this.tagline,
    this.isSauce = false,
    this.isTopBun = false,
    this.isBottomBun = false,
  });

  static const BurgerIngredient bottomBun = BurgerIngredient(
    id: 'bun_bottom',
    name: 'Brioche Bun Base',
    category: IngredientCategory.bun,
    price: 1.50,
    calories: 140,
    image: 'assets/images/burger_components/bun_bottom.png',
    layerHeight: 30.0,
    colorAccent: Color(0xFFE28D38),
    emoji: '🍞',
    tagline: 'Warm toasted golden brioche',
    isBottomBun: true,
  );

  static const BurgerIngredient topBun = BurgerIngredient(
    id: 'bun_top',
    name: 'Brioche Sesame Crown',
    category: IngredientCategory.bun,
    price: 1.50,
    calories: 150,
    image: 'assets/images/burger_components/bun_top.png',
    layerHeight: 46.0,
    colorAccent: Color(0xFFD97706),
    emoji: '🥯',
    tagline: 'Toasted crown with toasted sesame',
    isTopBun: true,
  );

  static const List<BurgerIngredient> allIngredients = [
    // Buns
    bottomBun,
    topBun,

    // Meats / Patties
    BurgerIngredient(
      id: 'beef_patty',
      name: 'Flame-Grilled Beef Patty',
      category: IngredientCategory.meat,
      price: 3.50,
      calories: 280,
      image: 'assets/images/burger_components/patty_bottom.png',
      layerHeight: 24.0,
      colorAccent: Color(0xFF8B4513),
      emoji: '🥩',
      tagline: '100% Angus flame-grilled beef',
    ),
    BurgerIngredient(
      id: 'zinger_chicken',
      name: 'Crispy Zinger Chicken',
      category: IngredientCategory.meat,
      price: 3.80,
      calories: 310,
      image: 'assets/images/burger_components/zinger_chicken.png',
      layerHeight: 26.0,
      colorAccent: Color(0xFFEA580C),
      emoji: '🍗',
      tagline: 'Spicy marinated extra-crispy chicken',
    ),
    BurgerIngredient(
      id: 'crispy_bacon',
      name: 'Crispy Smoked Bacon',
      category: IngredientCategory.meat,
      price: 1.80,
      calories: 160,
      image: 'assets/images/burger_components/crispy_bacon.png',
      layerHeight: 14.0,
      colorAccent: Color(0xFFB91C1C),
      emoji: '🥓',
      tagline: 'Hickory wood smoked strips',
    ),

    // Cheese
    BurgerIngredient(
      id: 'cheddar_cheese',
      name: 'Melted Cheddar Slice',
      category: IngredientCategory.cheese,
      price: 1.20,
      calories: 110,
      image: 'assets/images/burger_components/melted_cheddar.png',
      layerHeight: 16.0,
      colorAccent: Color(0xFFF59E0B),
      emoji: '🧀',
      tagline: 'Aged Wisconsin gooey cheddar',
    ),
    BurgerIngredient(
      id: 'cheese_patty_combo',
      name: 'Cheesy Melt Patty',
      category: IngredientCategory.cheese,
      price: 4.20,
      calories: 360,
      image: 'assets/images/burger_components/cheese_patty.png',
      layerHeight: 26.0,
      colorAccent: Color(0xFFD97706),
      emoji: '🍔',
      tagline: 'Smash patty with melted cheddar',
    ),

    // Veggies
    BurgerIngredient(
      id: 'fresh_lettuce',
      name: 'Crisp Iceberg Lettuce',
      category: IngredientCategory.veggie,
      price: 0.60,
      calories: 15,
      image: 'assets/images/burger_components/lettuce.png',
      layerHeight: 20.0,
      colorAccent: Color(0xFF16A34A),
      emoji: '🥬',
      tagline: 'Farm fresh crunchy green leaf',
    ),
    BurgerIngredient(
      id: 'tomatoes_veggies',
      name: 'Sliced Tomatoes & Onion',
      category: IngredientCategory.veggie,
      price: 0.80,
      calories: 25,
      image: 'assets/images/burger_components/veggies.png',
      layerHeight: 18.0,
      colorAccent: Color(0xFFDC2626),
      emoji: '🍅',
      tagline: 'Vine-ripened red tomatoes & onions',
    ),
    BurgerIngredient(
      id: 'pickles_jalapenos',
      name: 'Pickles & Jalapeños',
      category: IngredientCategory.veggie,
      price: 0.75,
      calories: 20,
      image: 'assets/images/burger_components/pickles_jalapenos.png',
      layerHeight: 14.0,
      colorAccent: Color(0xFF65A30D),
      emoji: '🥒',
      tagline: 'Tangy dills and spicy jalapeño rings',
    ),

    // Sauces
    BurgerIngredient(
      id: 'ketchup_drizzle',
      name: 'Rich Ketchup & Mustard Drizzle',
      category: IngredientCategory.sauce,
      price: 0.50,
      calories: 45,
      image: 'assets/images/burger_components/ketchup_drizzle.png',
      layerHeight: 12.0,
      colorAccent: Color(0xFFE11D48),
      emoji: '🥫',
      tagline: 'Zesty ketchup & honey mustard swirl',
      isSauce: true,
    ),

    // Extras
    BurgerIngredient(
      id: 'fried_egg',
      name: 'Sunny-Side Fried Egg',
      category: IngredientCategory.extra,
      price: 1.50,
      calories: 130,
      image: 'assets/images/burger_components/fried_egg.png',
      layerHeight: 16.0,
      colorAccent: Color(0xFFFBBF24),
      emoji: '🍳',
      tagline: 'Crispy edges with rich runny yolk',
    ),
  ];
}

class PresetBurgerRecipe {
  final String id;
  final String name;
  final String description;
  final String badge;
  final List<BurgerIngredient> ingredients;

  const PresetBurgerRecipe({
    required this.id,
    required this.name,
    required this.description,
    required this.badge,
    required this.ingredients,
  });

  double get totalPrice => ingredients.fold(0.0, (sum, i) => sum + i.price);
  int get totalCalories => ingredients.fold(0, (sum, i) => sum + i.calories);

  static final List<PresetBurgerRecipe> presets = [
    PresetBurgerRecipe(
      id: 'classic_cheeseburger',
      name: 'The Golden Classic',
      description: 'The timeless juicy smash beef with melted cheddar & fresh greens',
      badge: 'POPULAR ⭐',
      ingredients: [
        BurgerIngredient.bottomBun,
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'beef_patty'),
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'cheddar_cheese'),
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'fresh_lettuce'),
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'tomatoes_veggies'),
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'ketchup_drizzle'),
        BurgerIngredient.topBun,
      ],
    ),
    PresetBurgerRecipe(
      id: 'zinger_crunch_tower',
      name: 'Spicy Zinger Crunch',
      description: 'Extra crispy zinger chicken layered with melted cheese, bacon & jalapeños',
      badge: 'FIRE 🔥',
      ingredients: [
        BurgerIngredient.bottomBun,
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'zinger_chicken'),
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'cheddar_cheese'),
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'crispy_bacon'),
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'pickles_jalapenos'),
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'ketchup_drizzle'),
        BurgerIngredient.topBun,
      ],
    ),
    PresetBurgerRecipe(
      id: 'beast_monster',
      name: 'Monster Beast Stack',
      description: 'Double beef, crispy zinger chicken, sizzling egg & triple cheese',
      badge: 'ULTIMATE 👑',
      ingredients: [
        BurgerIngredient.bottomBun,
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'beef_patty'),
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'cheddar_cheese'),
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'zinger_chicken'),
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'crispy_bacon'),
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'fried_egg'),
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'fresh_lettuce'),
        BurgerIngredient.allIngredients.firstWhere((i) => i.id == 'ketchup_drizzle'),
        BurgerIngredient.topBun,
      ],
    ),
  ];
}
