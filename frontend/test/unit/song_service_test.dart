import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/song_service.dart';
import 'dart:convert';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('SongService', () {
    late SongService songService;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      songService = SongService();
    });

    test('fetchMySongs returns list of songs on success', () async {
      final mockResponse = [
        {
          '_id': '1',
          'title': 'Test Song',
          'artist': 'Test Artist',
          'duration': '3:30'
        }
      ];

      when(mockHttpClient.get(
        Uri.parse('http://localhost:3000/api/songs/my-songs'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await songService.fetchMySongs('test_token');
      expect(result.length, equals(1));
      expect(result[0]['title'], equals('Test Song'));
    });

    test('fetchMySongs throws on error', () async {
      when(mockHttpClient.get(
        Uri.parse('http://localhost:3000/api/songs/my-songs'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => songService.fetchMySongs('test_token'),
        throwsException,
      );
    });

    test('updateSongTitle returns updated song on success', () async {
      final mockResponse = {
        '_id': '1',
        'title': 'Updated Title',
        'artist': 'Test Artist',
        'duration': '3:30'
      };

      when(mockHttpClient.put(
        Uri.parse('http://localhost:3000/api/songs/1'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

      final result = await songService.updateSongTitle('test_token', '1', 'Updated Title');
      expect(result['title'], equals('Updated Title'));
    });

    test('deleteSong succeeds on valid request', () async {
      when(mockHttpClient.delete(
        Uri.parse('http://localhost:3000/api/songs/1'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('', 200));

      expect(
        () => songService.deleteSong('test_token', '1'),
        completes,
      );
    });
  });
} 