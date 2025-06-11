import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/common/library_screen.dart';
import 'package:frontend/services/library_service.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockLibraryService extends Mock implements LibraryService {}

void main() {
  late MockLibraryService mockLibraryService;

  setUp(() {
    mockLibraryService = MockLibraryService();
  });

  group('Library Management Flow', () {
    testWidgets('Displays watchlist and playlists', (WidgetTester tester) async {
      // Setup mock responses
      when(mockLibraryService.fetchWatchlist('test_token')).thenAnswer((_) async => [
        {
          '_id': '1',
          'title': 'Watchlist Song 1',
          'artist': 'Artist 1',
          'duration': '3:30'
        },
        {
          '_id': '2',
          'title': 'Watchlist Song 2',
          'artist': 'Artist 2',
          'duration': '4:00'
        }
      ]);

      when(mockLibraryService.fetchPlaylists('test_token')).thenAnswer((_) async => [
        {
          '_id': '1',
          'name': 'My Playlist 1',
          'songs': [
            {
              '_id': '1',
              'title': 'Playlist Song 1',
              'artist': 'Artist 1',
              'duration': '3:30'
            }
          ]
        },
        {
          '_id': '2',
          'name': 'My Playlist 2',
          'songs': [
            {
              '_id': '2',
              'title': 'Playlist Song 2',
              'artist': 'Artist 2',
              'duration': '4:00'
            }
          ]
        }
      ]);

      await tester.pumpWidget(
        Provider<LibraryService>.value(
          value: mockLibraryService,
          child: MaterialApp(
            home: LibraryScreen(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pumpAndSettle();

      // Verify watchlist songs are displayed
      expect(find.text('Watchlist Song 1'), findsOneWidget);
      expect(find.text('Watchlist Song 2'), findsOneWidget);

      // Verify playlists are displayed
      expect(find.text('My Playlist 1'), findsOneWidget);
      expect(find.text('My Playlist 2'), findsOneWidget);
    });

    testWidgets('Can add song to watchlist', (WidgetTester tester) async {
      // Setup mock responses
      when(mockLibraryService.fetchWatchlist('test_token')).thenAnswer((_) async => []);
      when(mockLibraryService.fetchPlaylists('test_token')).thenAnswer((_) async => []);
      when(mockLibraryService.addToWatchlist('test_token', 'song1')).thenAnswer((_) async => {
        'success': true,
        'message': 'Added to watchlist'
      });

      await tester.pumpWidget(
        Provider<LibraryService>.value(
          value: mockLibraryService,
          child: MaterialApp(
            home: LibraryScreen(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pumpAndSettle();

      // Find and tap add to watchlist button
      final addButton = find.byIcon(Icons.add);
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Verify success message
      expect(find.text('Added to watchlist'), findsOneWidget);
    });

    testWidgets('Can create new playlist', (WidgetTester tester) async {
      // Setup mock responses
      when(mockLibraryService.fetchWatchlist('test_token')).thenAnswer((_) async => []);
      when(mockLibraryService.fetchPlaylists('test_token')).thenAnswer((_) async => []);
      when(mockLibraryService.createPlaylist('test_token', 'New Playlist')).thenAnswer((_) async => {
        '_id': '3',
        'name': 'New Playlist',
        'songs': []
      });

      await tester.pumpWidget(
        Provider<LibraryService>.value(
          value: mockLibraryService,
          child: MaterialApp(
            home: LibraryScreen(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pumpAndSettle();

      // Find and tap create playlist button
      final createButton = find.byIcon(Icons.playlist_add);
      expect(createButton, findsOneWidget);
      await tester.tap(createButton);
      await tester.pumpAndSettle();

      // Enter playlist name
      await tester.enterText(find.byType(TextField), 'New Playlist');
      await tester.pumpAndSettle();

      // Tap create button
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify success message
      expect(find.text('Playlist created successfully'), findsOneWidget);
    });

    testWidgets('Shows error message when fetch fails', (WidgetTester tester) async {
      // Setup mock to throw error
      when(mockLibraryService.fetchWatchlist('test_token')).thenThrow(Exception('Failed to fetch watchlist'));
      when(mockLibraryService.fetchPlaylists('test_token')).thenAnswer((_) async => []);

      await tester.pumpWidget(
        Provider<LibraryService>.value(
          value: mockLibraryService,
          child: MaterialApp(
            home: LibraryScreen(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Failed to fetch watchlist'), findsOneWidget);
    });
  });
} 