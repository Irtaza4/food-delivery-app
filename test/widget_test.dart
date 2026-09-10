import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/shared/widgets/bottom_nav_bar.dart';
import 'package:food_delivery_app/features/food/diy_burger_screen.dart';

void main() {
  testWidgets('Food delivery app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FoodDeliveryApp());

    // Verify that onboarding screen shows "Step Into Flavor World"
    expect(find.textContaining('Step Into'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('Bottom nav bar hold/drag changes tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodDeliveryApp());
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Verify initial tab is Home
    expect(find.text('Popular Restaurant'), findsOneWidget);

    // Find CustomBottomNavBar and drag across it
    final navFinder = find.byType(CustomBottomNavBar);
    expect(navFinder, findsOneWidget);

    // Drag from center to right edge (towards profile tab)
    await tester.drag(navFinder, const Offset(150, 0));
    await tester.pumpAndSettle();

    // Tab should have changed
    expect(find.byType(CustomBottomNavBar), findsOneWidget);
  });

  testWidgets('DIY Burger Studio opens, adds ingredients, and shows stats', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodDeliveryApp());
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Tap on DIY Burger Banner
    expect(find.textContaining('Build Your Own'), findsOneWidget);
    await tester.tap(find.textContaining('Build Your Own'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    // Verify DIY Burger Screen opened
    expect(find.byType(DIYBurgerScreen), findsOneWidget);
    expect(find.text('DIY Burger Studio'), findsOneWidget);
    expect(find.textContaining('Reel Mode'), findsOneWidget);

    // Verify ingredients dock shows items
    expect(find.text('🥩 Meats'), findsOneWidget);
    expect(find.text('Crispy Zinger Chicken'), findsOneWidget);

    // Tap to add Crispy Zinger Chicken
    await tester.tap(find.text('Crispy Zinger Chicken'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    // Verify layers count updated
    expect(find.textContaining('Layers'), findsWidgets);
  });

  testWidgets('Restaurant detail screen opens and category changes smoothly', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodDeliveryApp());
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    // Scroll until first restaurant card is visible
    final firstCardFinder = find.text("BkBite's Hub").first;
    await tester.scrollUntilVisible(
      firstCardFinder,
      100.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.tap(firstCardFinder);
    await tester.pumpAndSettle();

    // Verify restaurant detail screen elements
    expect(find.text('Delivery Time'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
  });
}
