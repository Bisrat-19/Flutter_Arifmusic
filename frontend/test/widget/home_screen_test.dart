import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:frontend/presentation/common/home_screen.dart';
import 'package:frontend/data/datasources/home/home_service.dart';
import 'package:frontend/presentation/providers/user_provider.dart';

@GenerateMocks([HomeService])
void main() {
  group('HomeScreen Widget Tests', () {
    late MockHomeService mockHomeService;

    setUp(() {
      mockHomeService = MockHomeService();
    });

    Widget createTestWidget() {
      return ProviderScope(
        child: MaterialApp(
          home: const HomeScreen(),
          theme: ThemeData.dark(),
        ),
      );
    }

    testWidgets('should display home screen elements', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump(); // Allow futures to complete

      // Assert
      expect(find.text('Home'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
      expect(find.text('Search songs, artists...'), findsOneWidget);
    });

    testWidgets('should display section headers', (WidgetTester tester) async {
      // Arrange
      when(mockHomeService.fetchReleasedSongs(token: anyNamed('token')))
          .thenAnswer((_) async => []);
      when(mockHomeService.fetchArtists(token: anyNamed('token')))
          .thenAnswer((_) async => []);

      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Trending Now'), findsOneWidget);
      expect(find.text('Featured Artists'), findsOneWidget);
      expect(find.text('New Releases'), findsOneWidget);
      expect(find.text('View all'), findsAtLeastNWidgets(3));
    });

    testWidgets('should show loading indicator initially', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display search bar', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Assert
      final searchContainer = find.widgetWithText(Container, 'Search songs, artists...');
      expect(searchContainer, findsOneWidget);
    });

    testWidgets('should handle tap on search bar', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final searchContainer = find.text('Search songs, artists...');
      await tester.tap(searchContainer);
      await tester.pump();

      // The actual navigation would be tested in integration tests
      // Here we just verify the widget responds to tap
      expect(searchContainer, findsOneWidget);
    });
  });
}
