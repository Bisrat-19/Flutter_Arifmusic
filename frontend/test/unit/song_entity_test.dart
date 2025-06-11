import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/domain/entities/song_entity.dart';

void main() {
  group('SongEntity Tests', () {
    test('should create SongEntity with all fields', () {
      // Arrange & Act
      final song = SongEntity(
        title: 'Test Song',
        genre: 'Pop',
        description: 'A test song',
        artistId: 'artist123',
        audioUrl: 'https://example.com/audio.mp3',
        coverImageUrl: 'https://example.com/cover.jpg',
        artist: 'Test Artist',
      );

      // Assert
      expect(song.title, 'Test Song');
      expect(song.genre, 'Pop');
      expect(song.description, 'A test song');
      expect(song.artistId, 'artist123');
      expect(song.audioUrl, 'https://example.com/audio.mp3');
      expect(song.coverImageUrl, 'https://example.com/cover.jpg');
      expect(song.artist, 'Test Artist');
    });

    test('should create SongEntity with required fields only', () {
      // Arrange & Act
      final song = SongEntity(
        title: 'Test Song',
        genre: 'Pop',
        description: 'A test song',
        artistId: 'artist123',
      );

      // Assert
      expect(song.title, 'Test Song');
      expect(song.genre, 'Pop');
      expect(song.description, 'A test song');
      expect(song.artistId, 'artist123');
      expect(song.audioUrl, isNull);
      expect(song.coverImageUrl, isNull);
      expect(song.artist, isNull);
    });

    test('should handle empty strings', () {
      // Arrange & Act
      final song = SongEntity(
        title: '',
        genre: '',
        description: '',
        artistId: '',
        audioUrl: '',
        coverImageUrl: '',
        artist: '',
      );

      // Assert
      expect(song.title, '');
      expect(song.genre, '');
      expect(song.description, '');
      expect(song.artistId, '');
      expect(song.audioUrl, '');
      expect(song.coverImageUrl, '');
      expect(song.artist, '');
    });

    test('should create SongEntity with mixed null and non-null optional fields', () {
      // Arrange & Act
      final song = SongEntity(
        title: 'Test Song',
        genre: 'Rock',
        description: 'A rock song',
        artistId: 'artist456',
        audioUrl: 'https://example.com/audio.mp3',
        coverImageUrl: null,
        artist: 'Rock Artist',
      );

      // Assert
      expect(song.title, 'Test Song');
      expect(song.genre, 'Rock');
      expect(song.description, 'A rock song');
      expect(song.artistId, 'artist456');
      expect(song.audioUrl, 'https://example.com/audio.mp3');
      expect(song.coverImageUrl, isNull);
      expect(song.artist, 'Rock Artist');
    });

    test('should handle special characters in fields', () {
      // Arrange & Act
      final song = SongEntity(
        title: 'Test Song with "Quotes" & Symbols!',
        genre: 'Pop/Rock',
        description: 'A song with special chars: @#$%^&*()',
        artistId: 'artist_123-456',
        audioUrl: 'https://example.com/path/to/audio file.mp3',
        artist: 'Artist Name with Ñ and ü',
      );

      // Assert
      expect(song.title, 'Test Song with "Quotes" & Symbols!');
      expect(song.genre, 'Pop/Rock');
      expect(song.description, 'A song with special chars: @#$%^&*()');
      expect(song.artistId, 'artist_123-456');
      expect(song.audioUrl, 'https://example.com/path/to/audio file.mp3');
      expect(song.artist, 'Artist Name with Ñ and ü');
    });
  });
}
