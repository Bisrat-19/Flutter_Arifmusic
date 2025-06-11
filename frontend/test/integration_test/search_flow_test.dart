import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/common/search_screen.dart';
import 'package:frontend/services/search_service.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockSearchService extends Mock implements SearchService {}

void main() {
  late MockSearchService mockSearchService;

  setUp(() {
    mockSearchService = MockSearchService();
  });

  group('Search Flow', () {
    testWidgets('User can search and see results', (WidgetTester tester) async {
      // Setup mock response
      when(mockSearchService.search('test')).thenAnswer((_) async => [
        {
          '_id': '1',
          'title': 'Test Song',
          'artist': 'Test Artist',
          'type': 'song'
        },
        {
          '_id': '2',
          'name': 'Test Artist',
          'type': 'artist'
        }
      ]);

      await tester.pumpWidget(
        Provider<SearchService>.value(
          value: mockSearchService,
          child: MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );

      // Enter search query
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();

      // Verify search was called
      verify(mockSearchService.search('test')).called(1);

      // Verify results are displayed
      expect(find.text('Test Song'), findsOneWidget);
      expect(find.text('Test Artist'), findsOneWidget);
    });

    testWidgets('Shows error message on search failure', (WidgetTester tester) async {
      // Setup mock to throw error
      when(mockSearchService.search('test')).thenThrow(Exception('Search failed'));

      await tester.pumpWidget(
        Provider<SearchService>.value(
          value: mockSearchService,
          child: MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );

      // Enter search query
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Search failed'), findsOneWidget);
    });

    testWidgets('Shows empty state when no results found', (WidgetTester tester) async {
      // Setup mock to return empty list
      when(mockSearchService.search('nonexistent')).thenAnswer((_) async => []);

      await tester.pumpWidget(
        Provider<SearchService>.value(
          value: mockSearchService,
          child: MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );

      // Enter search query
      await tester.enterText(find.byType(TextField), 'nonexistent');
      await tester.pumpAndSettle();

      // Verify empty state is shown
      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('Debounces search input', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<SearchService>.value(
          value: mockSearchService,
          child: MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );

      // Enter search query character by character
      await tester.enterText(find.byType(TextField), 't');
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'te');
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'tes');
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();

      // Verify search was called only once with final query
      verify(mockSearchService.search('test')).called(1);
    });
  });
} 