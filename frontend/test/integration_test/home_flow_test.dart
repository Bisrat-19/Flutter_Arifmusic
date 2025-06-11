import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/services/home_service.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockHomeService extends Mock implements HomeService {}

void main() {
  late MockHomeService mockHomeService;

  setUp(() {
    mockHomeService = MockHomeService();
  });

  group('Home Screen Flow', () {
    testWidgets('Displays released songs and artists', (WidgetTester tester) async {
      // Setup mock responses
      when(mockHomeService.fetchReleasedSongs()).thenAnswer((_) async => [
        {
          '_id': '1',
          'title': 'Test Song 1',
          'artist': 'Test Artist 1',
          'duration': '3:30'
        },
        {
          '_id': '2',
          'title': 'Test Song 2',
          'artist': 'Test Artist 2',
          'duration': '4:00'
        }
      ]);

      when(mockHomeService.fetchArtists()).thenAnswer((_) async => [
        {
          '_id': '1',
          'name': 'Test Artist 1',
          'genre': 'Pop'
        },
        {
          '_id': '2',
          'name': 'Test Artist 2',
          'genre': 'Rock'
        }
      ]);

      await tester.pumpWidget(
        Provider<HomeService>.value(
          value: mockHomeService,
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pumpAndSettle();

      // Verify songs are displayed
      expect(find.text('Test Song 1'), findsOneWidget);
      expect(find.text('Test Song 2'), findsOneWidget);

      // Verify artists are displayed
      expect(find.text('Test Artist 1'), findsOneWidget);
      expect(find.text('Test Artist 2'), findsOneWidget);
    });

    testWidgets('Shows error message when songs fetch fails', (WidgetTester tester) async {
      // Setup mock to throw error for songs
      when(mockHomeService.fetchReleasedSongs()).thenThrow(Exception('Failed to fetch songs'));
      when(mockHomeService.fetchArtists()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        Provider<HomeService>.value(
          value: mockHomeService,
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Failed to fetch songs'), findsOneWidget);
    });

    testWidgets('Shows error message when artists fetch fails', (WidgetTester tester) async {
      // Setup mock to throw error for artists
      when(mockHomeService.fetchReleasedSongs()).thenAnswer((_) async => []);
      when(mockHomeService.fetchArtists()).thenThrow(Exception('Failed to fetch artists'));

      await tester.pumpWidget(
        Provider<HomeService>.value(
          value: mockHomeService,
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Failed to fetch artists'), findsOneWidget);
    });

    testWidgets('Shows empty state when no content available', (WidgetTester tester) async {
      // Setup mock to return empty lists
      when(mockHomeService.fetchReleasedSongs()).thenAnswer((_) async => []);
      when(mockHomeService.fetchArtists()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        Provider<HomeService>.value(
          value: mockHomeService,
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Wait for data to load
      await tester.pumpAndSettle();

      // Verify empty state messages
      expect(find.text('No songs available'), findsOneWidget);
      expect(find.text('No artists available'), findsOneWidget);
    });
  });
} 