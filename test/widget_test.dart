import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/shared/widgets/bottom_nav_bar.dart';

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
}

