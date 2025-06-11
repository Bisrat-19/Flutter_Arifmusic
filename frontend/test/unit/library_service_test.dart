import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/library_service.dart';
import 'dart:convert';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('LibraryService', () {
    late LibraryService libraryService;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      libraryService = LibraryService();
    });

    test('fetchWatchlist returns list of songs on success', () async {
      final mockResponse = [
        {
          '_id': '1',
          'title': 'Test Song',
          'artist': 'Test Artist',
          'duration': '3:30'
        }
      ];

      when(mockHttpClient.get(
        Uri.parse('http://localhost:3000/api/watchlist'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await libraryService.fetchWatchlist('test_token');
      expect(result.length, equals(1));
      expect(result[0]['title'], equals('Test Song'));
    });

    test('fetchWatchlist throws when no token provided', () async {
      expect(
        () => libraryService.fetchWatchlist(null),
        throwsException,
      );
    });

    test('addToWatchlist returns success response', () async {
      final mockResponse = {
        'success': true,
        'message': 'Added to watchlist'
      };

      when(mockHttpClient.post(
        Uri.parse('http://localhost:3000/api/watchlist'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await libraryService.addToWatchlist('test_token', '1');
      expect(result['success'], isTrue);
    });

    test('createPlaylist returns new playlist data', () async {
      final mockResponse = {
        '_id': '1',
        'name': 'Test Playlist',
        'songs': []
      };

      when(mockHttpClient.post(
        Uri.parse('http://localhost:3000/api/playlists'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 201));

      final result = await libraryService.createPlaylist('test_token', 'Test Playlist');
      expect(result['name'], equals('Test Playlist'));
    });
  });
} 