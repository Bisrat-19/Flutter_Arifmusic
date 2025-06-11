import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/presentation/auth/login_screen.dart';
import 'package:frontend/presentation/providers/user_provider.dart';

import '../unit/user_provider_test.mocks.dart';

@GenerateMocks([GoRouter])
void main() {
  group('LoginScreen Widget Tests', () {
    late MockGoRouter mockRouter;

    setUp(() {
      mockRouter = MockGoRouter();
    });

    Widget createTestWidget() {
      return ProviderScope(
        child: MaterialApp(
          home: const LoginScreen(),
          theme: ThemeData.dark(),
        ),
      );
    }

    testWidgets('should display login form elements', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Login to your account'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); // Email and Password
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Don\'t have an account?'), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
    });

    testWidgets('should validate email field', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act - Try to submit with empty email
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pump();

      // Assert
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should validate invalid email format', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pump();

      // Assert
      expect(find.textContaining('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('should validate password field', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pump();

      // Assert
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      final passwordField = find.byType(TextFormField).last;
      final visibilityToggle = find.descendant(
        of: passwordField,
        matching: find.byIcon(Icons.visibility_off),
      );

      await tester.tap(visibilityToggle);
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('should show loading state during login', (WidgetTester tester) async {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          userProvider.overrideWith(() => TestUserNotifier(isLoading: true)),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: const LoginScreen(),
            theme: ThemeData.dark(),
          ),
        ),
      );

      // Assert
      expect(find.text('Logging in...'), findsOneWidget);
    });
  });
}

class TestUserNotifier extends UserNotifier {
  final bool isLoading;
  final String? error;

  TestUserNotifier({this.isLoading = false, this.error});

  @override
  UserState build() {
    return UserState(
      isLoading: isLoading,
      error: error,
      role: null,
    );
  }
}
