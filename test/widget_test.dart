import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/main.dart';

void main() {
  testWidgets('Food delivery app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FoodDeliveryApp());

    // Verify that onboarding screen shows "Step Into Flavor World"
    expect(find.textContaining('Step Into'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
