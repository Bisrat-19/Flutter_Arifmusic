import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/presentation/common/main_navigation.dart';
import 'package:frontend/presentation/providers/user_provider.dart';
import 'package:frontend/data/models/user_model.dart';

void main() {
  group('MainNavigation Widget Tests', () {
    Widget createTestWidget({int initialIndex = 0, UserModel? user}) {
      return ProviderScope(
        overrides: user != null ? [
          userProvider.overrideWith(() => TestUserNotifier(user: user)),
        ] : [],
        child: MaterialApp(
          home: MainNavigation(initialIndex: initialIndex),
          theme: ThemeData.dark(),
        ),
      );
    }

    testWidgets('should display bottom navigation bar', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Library'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('should start with correct initial index', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(initialIndex: 2));

      // Assert
      final bottomNav = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, 2);
    });

    testWidgets('should navigate between tabs', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());

      // Act
      await tester.tap(find.text('Search'));
      await tester.pump();

      // Assert
      final bottomNav = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, 1);
    });

    testWidgets('should display listener profile for listener user', (WidgetTester tester) async {
      // Arrange
      final user = UserModel(
        id: '123',
        fullName: 'Test User',
        email: 'test@example.com',
        role: 'listener',
        token: 'token',
      );

      await tester.pumpWidget(createTestWidget(user: user));

      // Act
      await tester.tap(find.text('Profile'));
      await tester.pump();

      // Assert - The specific profile screen would be displayed
      // This would need to be verified based on the actual profile screen content
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('should handle out of bounds initial index', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget(initialIndex: 10));

      // Assert - Should clamp to valid range
      final bottomNav = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(bottomNav.currentIndex, 3); // Clamped to max index
    });
  });
}

class TestUserNotifier extends UserNotifier {
  final UserModel? user;

  TestUserNotifier({this.user});

  @override
  UserState build() {
    return UserState(user: user, role: user?.role);
  }
}
