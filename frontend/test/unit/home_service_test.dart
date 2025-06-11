import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/home_service.dart';
import 'dart:convert';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('HomeService', () {
    late HomeService homeService;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      homeService = HomeService();
    });

    test('fetchReleasedSongs returns list of songs on success', () async {
      final mockResponse = [
        {
          '_id': '1',
          'title': 'Test Song',
          'artist': 'Test Artist',
          'duration': '3:30'
        }
      ];

      when(mockHttpClient.get(Uri.parse('http://localhost:3000/api/songs/released')))
          .thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await homeService.fetchReleasedSongs();
      expect(result.length, equals(1));
      expect(result[0]['title'], equals('Test Song'));
    });

    test('fetchReleasedSongs throws on error', () async {
      when(mockHttpClient.get(Uri.parse('http://localhost:3000/api/songs/released')))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => homeService.fetchReleasedSongs(),
        throwsException,
      );
    });

    test('fetchArtists returns list of artists on success', () async {
      final mockResponse = [
        {
          '_id': '1',
          'name': 'Test Artist',
          'genre': 'Pop'
        }
      ];

      when(mockHttpClient.get(Uri.parse('http://localhost:3000/api/artists')))
          .thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await homeService.fetchArtists();
      expect(result.length, equals(1));
      expect(result[0]['name'], equals('Test Artist'));
    });

    test('fetchArtists throws on error', () async {
      when(mockHttpClient.get(Uri.parse('http://localhost:3000/api/artists')))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => homeService.fetchArtists(),
        throwsException,
      );
    });
  });
} 