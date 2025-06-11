import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/search_service.dart';
import 'dart:convert';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('SearchService', () {
    late SearchService searchService;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      searchService = SearchService();
    });

    test('search returns combined results on success', () async {
      final mockSongResponse = [
        {
          '_id': '1',
          'title': 'Test Song',
          'artist': 'Test Artist',
          'type': 'song'
        }
      ];

      final mockArtistResponse = [
        {
          '_id': '2',
          'name': 'Test Artist',
          'type': 'artist'
        }
      ];

      when(mockHttpClient.get(Uri.parse('http://localhost:3000/api/search/songs?query=test')))
          .thenAnswer((_) async => http.Response(jsonEncode(mockSongResponse), 200));
      
      when(mockHttpClient.get(Uri.parse('http://localhost:3000/api/search/artists?query=test')))
          .thenAnswer((_) async => http.Response(jsonEncode(mockArtistResponse), 200));

      final result = await searchService.search('test');
      expect(result.length, equals(2));
      expect(result[0]['type'], equals('song'));
      expect(result[1]['type'], equals('artist'));
    });

    test('search throws on song search error', () async {
      when(mockHttpClient.get(Uri.parse('http://localhost:3000/api/search/songs?query=test')))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => searchService.search('test'),
        throwsException,
      );
    });

    test('search throws on artist search error', () async {
      when(mockHttpClient.get(Uri.parse('http://localhost:3000/api/search/songs?query=test')))
          .thenAnswer((_) async => http.Response(jsonEncode([]), 200));
      
      when(mockHttpClient.get(Uri.parse('http://localhost:3000/api/search/artists?query=test')))
          .thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => searchService.search('test'),
        throwsException,
      );
    });

    test('search returns empty list when no results found', () async {
      when(mockHttpClient.get(Uri.parse('http://localhost:3000/api/search/songs?query=nonexistent')))
          .thenAnswer((_) async => http.Response(jsonEncode([]), 200));
      
      when(mockHttpClient.get(Uri.parse('http://localhost:3000/api/search/artists?query=nonexistent')))
          .thenAnswer((_) async => http.Response(jsonEncode([]), 200));

      final result = await searchService.search('nonexistent');
      expect(result, isEmpty);
    });
  });
} 