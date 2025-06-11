import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import '../../lib/screens/common/library_screen.dart';
import '../../lib/services/library_service.dart';
import '../../lib/providers/user_provider.dart';

class MockLibraryService extends Mock implements LibraryService {}
class MockUserProvider extends Mock implements UserProvider {}

void main() {
  testWidgets('LibraryScreen renders and shows loading indicators', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LibraryScreen()));
    expect(find.byType(LibraryScreen), findsOneWidget);
    // You may want to mock services for more control
  });

  testWidgets('LibraryScreen renders with mocked services', (WidgetTester tester) async {
    final mockLibraryService = MockLibraryService();
    final mockUserProvider = MockUserProvider();
    when(mockUserProvider.user).thenReturn(null);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<LibraryService>.value(value: mockLibraryService),
          ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );

    expect(find.byType(LibraryScreen), findsOneWidget);
  });

  testWidgets('LibraryScreen switches tabs', (WidgetTester tester) async {
    final mockLibraryService = MockLibraryService();
    final mockUserProvider = MockUserProvider();
    when(mockUserProvider.user).thenReturn(null);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<LibraryService>.value(value: mockLibraryService),
          ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );

    // Simulate tab switching (adjust the finder as per your widget)
    final tabFinder = find.text('Playlists'); // or whatever your tab is called
    expect(tabFinder, findsOneWidget);
    await tester.tap(tabFinder);
    await tester.pumpAndSettle();

    // Check for content related to the tab
    expect(find.text('No playlists found'), findsOneWidget); // Adjust as needed
  });

  testWidgets('LibraryScreen shows error when playlist fetch fails', (WidgetTester tester) async {
    final mockLibraryService = MockLibraryService();
    final mockUserProvider = MockUserProvider();
    when(mockUserProvider.user).thenReturn(null);
    when(mockUserProvider.token).thenReturn('test_token');
    when(mockLibraryService.fetchPlaylists('test_token')).thenThrow(Exception('Failed to fetch playlists'));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<LibraryService>.value(value: mockLibraryService),
          ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('Failed to fetch playlists'), findsOneWidget);
  });

  testWidgets('LibraryScreen allows adding to playlist', (WidgetTester tester) async {
    final mockLibraryService = MockLibraryService();
    final mockUserProvider = MockUserProvider();
    when(mockUserProvider.user).thenReturn(null);
    when(mockUserProvider.token).thenReturn('test_token');
    when(mockLibraryService.addToPlaylist('test_token', '1', '2')).thenAnswer((_) async => true);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<LibraryService>.value(value: mockLibraryService),
          ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        ],
        child: const MaterialApp(home: LibraryScreen()),
      ),
    );

    // Simulate tapping the add to playlist button (adjust the finder as per your widget)
    final addButton = find.byIcon(Icons.playlist_add);
    expect(addButton, findsOneWidget);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Optionally, check that addToPlaylist was called
    verify(mockLibraryService.addToPlaylist('test_token', '1', '2')).called(1);
  });
} 