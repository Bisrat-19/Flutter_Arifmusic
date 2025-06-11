import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/auth/register_screen.dart';

void main() {
  group('RegisterScreen Widget Tests', () {
    Widget createTestWidget() {
      return ProviderScope(
        child: MaterialApp(
          home: const RegisterScreen(),
          theme: ThemeData.dark(),
        ),
      );
    }

    testWidgets('should display registration form elements', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Create an account'), findsOneWidget);
      expect(find.text('Sign up to get started'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.text('Register as'), findsOneWidget);
      expect(find.text('Listener'), findsOneWidget);
      expect(find.text('Artist'), findsOneWidget);
    });

    testWidgets('should validate full name field', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      final createButton = find.text('Create account');
      await tester.tap(createButton);
      await tester.pump();

      // Assert
      expect(find.text('Enter full name'), findsOneWidget);
    });

    testWidgets('should validate email field', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.enterText(find.widgetWithText(TextFormField, 'Enter Your Full Name...'), 'John Doe');
      final createButton = find.text('Create account');
      await tester.tap(createButton);
      await tester.pump();

      // Assert
      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('should show password requirements when invalid', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      final passwordField = find.widgetWithText(TextFormField, '•••••').first;
      await tester.enterText(passwordField, 'weak');
      await tester.pump();

      // Assert
      expect(find.text('Password must:'), findsOneWidget);
      expect(find.text('• Be at least 8 characters long'), findsOneWidget);
      expect(find.text('• Contain an uppercase letter'), findsOneWidget);
      expect(find.text('• Contain a lowercase letter'), findsOneWidget);
      expect(find.text('• Contain a number'), findsOneWidget);
      expect(find.text('• Contain a special character'), findsOneWidget);
    });

    testWidgets('should validate password confirmation', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      final passwordFields = find.widgetWithText(TextFormField, '•••••');
      await tester.enterText(passwordFields.first, 'Password123!');
      await tester.enterText(passwordFields.last, 'DifferentPassword123!');
      await tester.pump();

      // Assert
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should toggle between listener and artist roles', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      final artistRadio = find.widgetWithText(Row, 'Artist');
      await tester.tap(artistRadio);
      await tester.pump();

      // Assert
      expect(find.text('Artist accounts require approval from our team'), findsOneWidget);
    });
  });
}
