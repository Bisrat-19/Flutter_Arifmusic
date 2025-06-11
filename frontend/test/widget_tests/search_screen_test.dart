import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/services/search_service.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/common/search_screen.dart';

// 1. Create a mock class
class MockSearchService extends Mock implements SearchService {
  getSuggestions(any) {}
}

void main() {
  testWidgets('SearchScreen renders with mocked SearchService', (WidgetTester tester) async {
    final mockService = MockSearchService();
    // 2. Setup mock behavior
    when(mockService.search('Mock')).thenAnswer((_) async => [
      {'title': 'Mock Song', 'artistName': 'Mock Artist'}
    ]);
    
    await tester.pumpWidget(
      Provider<SearchService>.value(
        value: mockService,
        child: const MaterialApp(home: SearchScreen()),
      ),
    );

    expect(find.byType(SearchScreen), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('SearchScreen displays search results', (WidgetTester tester) async {
    final mockService = MockSearchService();
    when(mockService.search('Mock')).thenAnswer((_) async => [
      {'title': 'Mock Song', 'artistName': 'Mock Artist'}
    ]);

    await tester.pumpWidget(
      Provider<SearchService>.value(
        value: mockService,
        child: const MaterialApp(home: SearchScreen()),
      ),
    );

    // Enter text in the search field and trigger search
    await tester.enterText(find.byType(TextField), 'Mock');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    // Check for search result in the UI
    expect(find.text('Mock Song'), findsOneWidget);
    expect(find.text('Mock Artist'), findsOneWidget);
  });

  testWidgets('SearchScreen shows error when search fails', (WidgetTester tester) async {
    final mockService = MockSearchService();
    when(mockService.search('Error')).thenThrow(Exception('Search failed'));

    await tester.pumpWidget(
      Provider<SearchService>.value(
        value: mockService,
        child: const MaterialApp(home: SearchScreen()),
      ),
    );

    // Enter text in the search field and trigger search
    await tester.enterText(find.byType(TextField), 'Error');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();

    // Check for error message in the UI
    expect(find.textContaining('Search failed'), findsOneWidget);
  });

  testWidgets('SearchScreen shows suggestions as user types', (WidgetTester tester) async {
    final mockService = MockSearchService();
    when(mockService.getSuggestions('Sug')).thenAnswer((_) async => [
      'Suggestion 1',
      'Suggestion 2'
    ]);

    await tester.pumpWidget(
      Provider<SearchService>.value(
        value: mockService,
        child: const MaterialApp(home: SearchScreen()),
      ),
    );

    // Enter text in the search field
    await tester.enterText(find.byType(TextField), 'Sug');
    await tester.pumpAndSettle();

    // Check for suggestions in the UI
    expect(find.text('Suggestion 1'), findsOneWidget);
    expect(find.text('Suggestion 2'), findsOneWidget);
  });
} 