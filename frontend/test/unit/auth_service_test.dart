import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/local_storage_service.dart';
import 'package:frontend/models/user_model.dart';
import 'dart:convert';

class MockHttpClient extends Mock implements http.Client {}
class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockLocalStorageService mockStorage;

    setUp(() {
      mockStorage = MockLocalStorageService();
      authService = AuthService();
    });

    test('login returns user data on success', () async {
      final response = {
        'token': 'abc123',
        'user': {
          '_id': '1',
          'fullName': 'Test User',
          'email': 'test@example.com',
          'role': 'listener'
        }
      };

      when(mockStorage.saveUserData('abc123', response['user'] as Map<String, dynamic>))
          .thenAnswer((_) async => null);

      final result = await authService.login('test@example.com', 'password123');
      
      expect(result['token'], equals('abc123'));
      expect(result['user']['_id'], equals('1'));
      expect(result['user']['role'], equals('listener'));
      
      verify(mockStorage.saveUserData('abc123', response['user'] as Map<String, dynamic>)).called(1);
    });

    test('login throws on error', () async {
      expect(
        () => authService.login('test@example.com', 'wrongpass'),
        throwsException,
      );
    });

    test('register returns user data on success', () async {
      final response = {
        'token': 'abc123',
        'user': {
          '_id': '1',
          'fullName': 'Test User',
          'email': 'test@example.com',
          'role': 'listener'
        }
      };

      when(mockStorage.saveUserData('abc123', response['user'] as Map<String, dynamic>))
          .thenAnswer((_) async => null);

      final result = await authService.register(
        'Test User',
        'test@example.com',
        'password123',
        'listener'
      );
      
      expect(result['token'], equals('abc123'));
      expect(result['user']['_id'], equals('1'));
      expect(result['user']['role'], equals('listener'));
      
      verify(mockStorage.saveUserData('abc123', response['user'] as Map<String, dynamic>)).called(1);
    });

    test('register throws on error', () async {
      expect(
        () => authService.register(
          'Test User',
          'test@example.com',
          'password123',
          'listener'
        ),
        throwsException,
      );
    });

    test('getProfile returns user data when logged in', () async {
      final userData = {
        '_id': '1',
        'fullName': 'Test User',
        'email': 'test@example.com',
        'role': 'listener'
      };

      when(mockStorage.getToken()).thenAnswer((_) async => 'valid_token');
      when(mockStorage.getUserData()).thenAnswer((_) async => userData);

      final user = await authService.getProfile();
      expect(user.id, equals('1'));
      expect(user.role, equals('listener'));
    });

    test('getProfile throws when not logged in', () async {
      when(mockStorage.getToken()).thenAnswer((_) async => null);

      expect(
        () => authService.getProfile(),
        throwsException,
      );
    });
  });
} 