import 'package:mockito/mockito.dart';
import 'package:frontend/data/datasources/user/auth_service.dart';
import 'package:frontend/data/datasources/song/song_service.dart';
import 'package:frontend/data/datasources/home/home_service.dart';

class MockAuthService extends Mock implements AuthService {}
class MockSongService extends Mock implements SongService {}
class MockHomeService extends Mock implements HomeService {}

// Mock responses for testing
class MockResponses {
  static const Map<String, dynamic> successfulLogin = {
    'success': true,
    'token': 'mock_jwt_token',
    'user': {
      '_id': '123456789',
      'fullName': 'Test User',
      'email': 'test@example.com',
      'role': 'listener',
      'profileImage': null,
    }
  };

  static const Map<String, dynamic> successfulRegistration = {
    'success': true,
    'token': 'mock_jwt_token',
    'user': {
      '_id': '123456789',
      'fullName': 'New User',
      'email': 'new@example.com',
      'role': 'listener',
      'profileImage': null,
    }
  };

  static const List<Map<String, dynamic>> mockSongs = [
    {
      '_id': '1',
      'title': 'Test Song 1',
      'genre': 'Pop',
      'description': 'A test song',
      'artistId': 'artist1',
      'artistName': 'Test Artist 1',
      'audioPath': '/audio1.mp3',
      'coverImagePath': '/cover1.jpg',
      'playCount': 100,
    },
    {
      '_id': '2',
      'title': 'Test Song 2',
      'genre': 'Rock',
      'description': 'Another test song',
      'artistId': 'artist2',
      'artistName': 'Test Artist 2',
      'audioPath': '/audio2.mp3',
      'coverImagePath': '/cover2.jpg',
      'playCount': 50,
    },
  ];

  static const List<Map<String, dynamic>> mockArtists = [
    {
      '_id': 'artist1',
      'fullName': 'Test Artist 1',
      'email': 'artist1@example.com',
      'role': 'artist',
      'avatarPath': '/avatar1.jpg',
      'followerCount': 1000,
    },
    {
      '_id': 'artist2',
      'fullName': 'Test Artist 2',
      'email': 'artist2@example.com',
      'role': 'artist',
      'avatarPath': '/avatar2.jpg',
      'followerCount': 500,
    },
  ];
}
