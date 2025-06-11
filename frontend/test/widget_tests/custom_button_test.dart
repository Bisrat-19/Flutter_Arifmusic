import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/widgets/custom_button.dart';

void main() {
  testWidgets('CustomButton displays text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(text: 'Click Me', onPressed: () {}),
        ),
      ),
    );
    expect(find.text('Click Me'), findsOneWidget);
  });

  testWidgets('CustomButton calls onPressed', (WidgetTester tester) async {
    bool pressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Tap',
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Tap'));
    expect(pressed, isTrue);
  });

  testWidgets('CustomButton shows icon and trailingIcon', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Icons',
            icon: Icons.add,
            trailingIcon: Icons.arrow_forward,
            onPressed: () {},
          ),
        ),
      ),
    );
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
  });
} 