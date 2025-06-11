import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/main.dart' as app;
import 'package:frontend/presentation/auth/login_screen.dart';
import 'package:frontend/presentation/auth/register_screen.dart';
import 'package:frontend/presentation/welcome/welcome_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Tests', () {
    testWidgets('complete registration flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Should start at welcome screen
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.text('ArifMusic'), findsOneWidget);

      // Tap Register button
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Should navigate to register screen
      expect(find.byType(RegisterScreen), findsOneWidget);
      expect(find.text('Create an account'), findsOneWidget);

      // Fill in registration form
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter Your Full Name...'),
        'Test User',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'yourname@gmail.com'),
        'test@example.com',
      );

      final passwordFields = find.widgetWithText(TextFormField, '•••••');
      await tester.enterText(passwordFields.first, 'TestPassword123!');
      await tester.enterText(passwordFields.last, 'TestPassword123!');

      await tester.pumpAndSettle();

      // Select listener role (should be default)
      expect(find.text('Listener'), findsOneWidget);

      // Note: In a real integration test, you would mock the API calls
      // or use a test backend to avoid making actual network requests
    });

    testWidgets('complete login flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Tap Login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Should navigate to login screen
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Welcome back'), findsOneWidget);

      // Fill in login form
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'TestPassword123!');
      await tester.pumpAndSettle();

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Note: In a real test, you would verify navigation to main screen
      // after successful login, but this requires mocking the auth service
    });

    testWidgets('navigation between login and register', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Go to login screen
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);

      // Navigate to register from login
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();
      expect(find.byType(RegisterScreen), findsOneWidget);

      // Navigate back to login from register
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('form validation works correctly', (WidgetTester tester) async {
      // Start the app and navigate to login
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Try to login with empty fields
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Should show validation errors
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.textContaining('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('continue as guest flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Tap Continue as Guest
      await tester.tap(find.text('Continue as Guest'));
      await tester.pumpAndSettle();

      // Should navigate to main navigation
      // In a real test, you would verify the main navigation screen appears
      // This requires the actual navigation logic to be implemented
    });
  });
}
