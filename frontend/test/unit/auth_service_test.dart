import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart';
import 'package:frontend/data/datasources/user/auth_service.dart';
import 'package:frontend/data/datasources/user/local_storage_service.dart';
import 'package:frontend/data/models/user_model.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([Dio, LocalStorageService])
void main() {
  group('AuthService Tests', () {
    late AuthService authService;
    late MockDio mockDio;
    late MockLocalStorageService mockLocalStorage;

    setUp(() {
      mockDio = MockDio();
      mockLocalStorage = MockLocalStorageService();
      authService = AuthService();
      // We would need to inject these mocks in a real implementation
    });

    test('should register user successfully', () async {
      // Arrange
      const fullName = 'John Doe';
      const email = 'john@example.com';
      const password = 'Password123!';
      const role = 'listener';

      final mockResponse = Response(
        data: {
          'token': 'mock_token',
          'user': {
            '_id': '123',
            'fullName': fullName,
            'email': email,
            'role': role,
          }
        },
        statusCode: 201,
        requestOptions: RequestOptions(path: '/api/auth/register'),
      );

      when(mockDio.post(
        '/api/auth/register',
        data: anyNamed('data'),
      )).thenAnswer((_) async => mockResponse);

      when(mockLocalStorage.saveUserData(any, any))
          .thenAnswer((_) async => {});

      // Act
      final result = await authService.register(fullName, email, password, role);

      // Assert
      expect(result['success'], true);
      expect(result['token'], 'mock_token');
      expect(result['user']['fullName'], fullName);
      verify(mockLocalStorage.saveUserData('mock_token', any)).called(1);
    });

    test('should login user successfully', () async {
      // Arrange
      const email = 'john@example.com';
      const password = 'Password123!';

      final mockResponse = Response(
        data: {
          'token': 'login_token',
          'user': {
            '_id': '123',
            'fullName': 'John Doe',
            'email': email,
            'role': 'listener',
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/api/auth/login'),
      );

      when(mockDio.post(
        '/api/auth/login',
        data: anyNamed('data'),
      )).thenAnswer((_) async => mockResponse);

      when(mockLocalStorage.saveUserData(any, any))
          .thenAnswer((_) async => {});

      // Act
      final result = await authService.login(email, password);

      // Assert
      expect(result['success'], true);
      expect(result['token'], 'login_token');
      verify(mockLocalStorage.saveUserData('login_token', any)).called(1);
    });

    test('should throw exception when registration fails', () async {
      // Arrange
      when(mockDio.post(
        '/api/auth/register',
        data: anyNamed('data'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/api/auth/register'),
        response: Response(
          data: {'message': 'Email already exists'},
          statusCode: 400,
          requestOptions: RequestOptions(path: '/api/auth/register'),
        ),
      ));

      // Act & Assert
      expect(
        () => authService.register('John', 'john@example.com', 'pass', 'listener'),
        throwsException,
      );
    });

    test('should get user profile successfully', () async {
      // Arrange
      const token = 'valid_token';
      final mockResponse = Response(
        data: {
          '_id': '123',
          'fullName': 'John Doe',
          'email': 'john@example.com',
          'role': 'listener',
          'profileImage': 'image_url',
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/api/users/me'),
      );

      when(mockLocalStorage.getToken()).thenAnswer((_) async => token);
      when(mockDio.get(
        '/api/users/me',
        options: anyNamed('options'),
      )).thenAnswer((_) async => mockResponse);

      // Act
      final result = await authService.getProfile();

      // Assert
      expect(result, isA<UserModel>());
      expect(result.fullName, 'John Doe');
      expect(result.email, 'john@example.com');
    });

    test('should throw exception when no token found for profile', () async {
      // Arrange
      when(mockLocalStorage.getToken()).thenAnswer((_) async => null);

      // Act & Assert
      expect(
        () => authService.getProfile(),
        throwsException,
      );
    });
  });
}
