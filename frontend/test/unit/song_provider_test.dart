import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/presentation/providers/song_provider.dart';
import 'package:frontend/data/datasources/song/song_service.dart';
import 'package:frontend/domain/entities/song_entity.dart';

import 'song_provider_test.mocks.dart';

@GenerateMocks([SongService])
void main() {
  group('SongProvider Tests', () {
    late ProviderContainer container;
    late MockSongService mockSongService;

    setUp(() {
      mockSongService = MockSongService();
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with empty state', () {
      // Act
      final songState = container.read(songProvider);

      // Assert
      expect(songState.isUploading, false);
      expect(songState.isLoadingSongs, false);
      expect(songState.mySongs, isNull);
      expect(songState.error, isNull);
    });

    test('should upload song successfully', () async {
      // Arrange
      const token = 'valid_token';
      const title = 'Test Song';
      const genre = 'Pop';
      const description = 'Test Description';
      const artistId = 'artist123';

      final mockAudioFile = PlatformFile(
        name: 'test.mp3',
        size: 1024,
        path: '/path/to/test.mp3',
      );

      final mockResult = {
        'success': true,
        'song': SongEntity(
          title: title,
          genre: genre,
          description: description,
          artistId: artistId,
          audioUrl: 'audio_url',
        ),
        'message': 'Song uploaded successfully',
      };

      when(mockSongService.uploadSong(
        token: token,
        title: title,
        genre: genre,
        description: description,
        artistId: artistId,
        audioFile: mockAudioFile,
        coverImage: null,
      )).thenAnswer((_) async => mockResult);

      when(mockSongService.fetchMySongs(token))
          .thenAnswer((_) async => []);

      // Act
      final notifier = container.read(songProvider.notifier);
      final result = await notifier.uploadSong(
        token: token,
        title: title,
        genre: genre,
        description: description,
        artistId: artistId,
        audioFile: mockAudioFile,
      );

      // Assert
      expect(result, true);
      final state = container.read(songProvider);
      expect(state.uploadedSong?.title, title);
      expect(state.message, 'Song uploaded successfully');
      expect(state.isUploading, false);
    });

    test('should handle upload failure', () async {
      // Arrange
      const token = 'valid_token';
      const title = 'Test Song';

      when(mockSongService.uploadSong(
        token: anyNamed('token'),
        title: anyNamed('title'),
        genre: anyNamed('genre'),
        description: anyNamed('description'),
        artistId: anyNamed('artistId'),
        audioFile: anyNamed('audioFile'),
        coverImage: anyNamed('coverImage'),
      )).thenThrow(Exception('Upload failed'));

      // Act
      final notifier = container.read(songProvider.notifier);
      final result = await notifier.uploadSong(
        token: token,
        title: title,
        genre: 'Pop',
        description: 'Test',
        artistId: 'artist123',
        audioFile: PlatformFile(name: 'test.mp3', size: 1024),
      );

      // Assert
      expect(result, false);
      final state = container.read(songProvider);
      expect(state.error, contains('Upload failed'));
      expect(state.isUploading, false);
    });

    test('should fetch my songs successfully', () async {
      // Arrange
      const token = 'valid_token';
      final mockSongs = [
        {
          '_id': '1',
          'title': 'Song 1',
          'genre': 'Pop',
          'description': 'Description 1',
          'artistId': 'artist1',
          'audioPath': '/audio1.mp3',
          'playCount': 10,
        },
        {
          '_id': '2',
          'title': 'Song 2',
          'genre': 'Rock',
          'description': 'Description 2',
          'artistId': 'artist1',
          'audioPath': '/audio2.mp3',
          'playCount': 5,
        },
      ];

      when(mockSongService.fetchMySongs(token))
          .thenAnswer((_) async => mockSongs);

      // Act
      final notifier = container.read(songProvider.notifier);
      final result = await notifier.fetchMySongs(token);

      // Assert
      expect(result.length, 2);
      expect(result[0].title, 'Song 1');
      expect(result[1].title, 'Song 2');
      final state = container.read(songProvider);
      expect(state.mySongs?.length, 2);
      expect(state.isLoadingSongs, false);
    });

    test('should increment play count', () async {
      // Arrange
      const token = 'valid_token';
      const songId = 'song123';

      when(mockSongService.incrementPlayCount(songId, token))
          .thenAnswer((_) async => {});

      // Act
      final notifier = container.read(songProvider.notifier);
      await notifier.incrementPlayCount(songId, token);

      // Assert
      verify(mockSongService.incrementPlayCount(songId, token)).called(1);
    });

    test('should clear upload state', () {
      // Arrange
      final notifier = container.read(songProvider.notifier);
      // Set some state first
      container.read(songProvider.notifier).state = container.read(songProvider).copyWith(
        message: 'Test message',
        error: 'Test error',
      );

      // Act
      notifier.clearUploadState();

      // Assert
      final state = container.read(songProvider);
      expect(state.message, isNull);
      expect(state.error, isNull);
      expect(state.uploadedSong, isNull);
    });
  });
}
