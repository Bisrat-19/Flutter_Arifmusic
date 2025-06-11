import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:frontend/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Artist Dashboard Flow Integration Tests', () {
    testWidgets('artist can access dashboard after login', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Login as artist
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Fill in artist credentials
      await tester.enterText(find.byType(TextFormField).first, 'artist@test.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.pumpAndSettle();

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify we're on the artist dashboard
      expect(find.text('Artist Dashboard'), findsOneWidget);
    });

    testWidgets('artist can upload new song', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login first
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'artist@test.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Navigate to upload screen
      await tester.tap(find.text('Upload Song'));
      await tester.pumpAndSettle();

      // Fill in song details
      await tester.enterText(find.byType(TextFormField).first, 'Test Song');
      await tester.enterText(find.byType(TextFormField).at(1), 'Test Artist');
      await tester.pumpAndSettle();

      // Verify upload button is present
      expect(find.text('Upload'), findsOneWidget);
    });

    testWidgets('artist can view their uploaded songs', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login first
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'artist@test.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Navigate to My Songs
      await tester.tap(find.text('My Songs'));
      await tester.pumpAndSettle();

      // Verify songs list is present
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('artist can edit song details', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login first
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'artist@test.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Navigate to My Songs
      await tester.tap(find.text('My Songs'));
      await tester.pumpAndSettle();

      // Tap on first song to edit
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Verify edit form is present
      expect(find.text('Edit Song'), findsOneWidget);
    });

    testWidgets('artist dashboard analytics display', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login first
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'artist@test.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify analytics widgets are present
      expect(find.text('Total Plays'), findsOneWidget);
      expect(find.text('Followers'), findsOneWidget);
      expect(find.text('Following'), findsOneWidget);
    });
  });
}
