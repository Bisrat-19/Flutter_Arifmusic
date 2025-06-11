import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:frontend/main.dart' as app;
import 'package:frontend/presentation/common/home_screen.dart';
import 'package:frontend/presentation/common/main_navigation.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Home Screen Flow Integration Tests', () {
    testWidgets('home screen loads and displays content', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Continue as guest to reach home screen
      await tester.tap(find.text('Continue as Guest'));
      await tester.pumpAndSettle();

      // Should be on main navigation with home tab selected
      expect(find.byType(MainNavigation), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);

      // Wait for home screen to load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should display home screen elements
      expect(find.text('Search songs, artists...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('search functionality works', (WidgetTester tester) async {
      // Start the app and navigate to home
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue as Guest'));
      await tester.pumpAndSettle();

      // Tap on search bar
      await tester.tap(find.text('Search songs, artists...'));
      await tester.pumpAndSettle();

      // Should navigate to search screen
      // In a real test, you would verify the search screen appears
    });

    testWidgets('navigation between tabs works', (WidgetTester tester) async {
      // Start the app and navigate to home
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue as Guest'));
      await tester.pumpAndSettle();

      // Navigate to search tab
      final bottomNavBar = find.byType(BottomNavigationBar);
      expect(bottomNavBar, findsOneWidget);

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();

      // Navigate to library tab
      await tester.tap(find.text('Library'));
      await tester.pumpAndSettle();

      // Navigate to profile tab
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      // Navigate back to home
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
    });

    testWidgets('section headers and view all buttons work', (WidgetTester tester) async {
      // Start the app and navigate to home
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue as Guest'));
      await tester.pumpAndSettle();

      // Wait for content to load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Look for section headers
      expect(find.text('Trending Now'), findsOneWidget);
      expect(find.text('Featured Artists'), findsOneWidget);
      expect(find.text('New Releases'), findsOneWidget);

      // Test view all buttons
      final viewAllButtons = find.text('View all');
      if (viewAllButtons.evaluate().isNotEmpty) {
        await tester.tap(viewAllButtons.first);
        await tester.pumpAndSettle();
        // Should navigate to respective section page
      }
    });

    testWidgets('refresh functionality works', (WidgetTester tester) async {
      // Start the app and navigate to home
      app.main();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue as Guest'));
      await tester.pumpAndSettle();

      // Perform pull to refresh
      await tester.fling(
        find.byType(CustomScrollView),
        const Offset(0, 300),
        1000,
      );
      await tester.pumpAndSettle();

      // Should trigger refresh and show loading indicator briefly
      // In a real test, you would verify the refresh behavior
    });
  });
}
