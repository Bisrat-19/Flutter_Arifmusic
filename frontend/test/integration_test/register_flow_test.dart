import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/screens/auth/register_screen.dart';

void main() {
  group('Register Integration Test', () {
    testWidgets('User can enter registration info and select role', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
      await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
      await tester.enterText(find.byType(TextFormField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.enterText(find.byType(TextFormField).at(3), 'password123');
      await tester.tap(find.text('Artist'));
      await tester.pump();
      expect(find.text('Artist accounts require approval from our team'), findsOneWidget);
      // Tap register
      await tester.tap(find.text('Create account'));
      await tester.pump();
    });
  });
} 