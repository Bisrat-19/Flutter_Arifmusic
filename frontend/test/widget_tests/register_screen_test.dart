import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/screens/auth/register_screen.dart';

void main() {
  testWidgets('RegisterScreen renders and validates', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    expect(find.text('Create an account'), findsOneWidget);
    await tester.tap(find.text('Create account'));
    await tester.pump();
    expect(find.text('Enter your full name'), findsOneWidget);
    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('Role selection works', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: RegisterScreen()));
    await tester.tap(find.text('Artist'));
    await tester.pump();
    expect(find.text('Artist accounts require approval from our team'), findsOneWidget);
  });
} 