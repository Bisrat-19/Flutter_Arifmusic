import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:frontend/presentation/providers/user_provider.dart';
import 'package:frontend/data/datasources/user/auth_service.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'user_provider_test.mocks.dart';

@GenerateMocks([AuthService, FlutterSecureStorage])
void main() {
  group('UserProvider Tests', () {
    late ProviderContainer container;
    late MockAuthService mockAuthService;
    late MockFlutterSecureStorage mockStorage;

    setUp(() {
      mockAuthService = MockAuthService();
      mockStorage = MockFlutterSecureStorage();
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with empty state', () {
      // Act
      final userState = container.read(userProvider);

      // Assert
      expect(userState.user, isNull);
      expect(userState.token, isNull);
      expect(userState.isLoading, false);
      expect(userState.error, isNull);
    });

    test('should login successfully', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'Password123!';
      final mockResponse = {
        'user': {
          '_id': '123',
          'fullName': 'Test User',
          'email': email,
          'role': 'listener',
        },
        'token': 'mock_token',
      };

      when(mockAuthService.login(email, password))
          .thenAnswer((_) async => mockResponse);

      // Act
      final notifier = container.read(userProvider.notifier);
      final result = await notifier.login(email, password);

      // Assert
      expect(result, true);
      final state = container.read(userProvider);
      expect(state.user?.email, email);
      expect(state.token, 'mock_token');
      expect(state.isLoading, false);
    });

    test('should handle login failure', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'wrongpassword';

      when(mockAuthService.login(email, password))
          .thenThrow(Exception('Invalid credentials'));

      // Act
      final notifier = container.read(userProvider.notifier);
      final result = await notifier.login(email, password);

      // Assert
      expect(result, false);
      final state = container.read(userProvider);
      expect(state.error, contains('Invalid credentials'));
      expect(state.isLoading, false);
    });

    test('should register successfully', () async {
      // Arrange
      const fullName = 'New User';
      const email = 'new@example.com';
      const password = 'Password123!';
      const role = 'listener';

      final mockResponse = {
        'user': {
          '_id': '456',
          'fullName': fullName,
          'email': email,
          'role': role,
        },
        'token': 'new_token',
      };

      when(mockAuthService.register(fullName, email, password, role))
          .thenAnswer((_) async => mockResponse);

      // Act
      final notifier = container.read(userProvider.notifier);
      final result = await notifier.register(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
      );

      // Assert
      expect(result, true);
      final state = container.read(userProvider);
      expect(state.user?.fullName, fullName);
      expect(state.token, 'new_token');
    });

    test('should logout and clear state', () async {
      // Arrange - First set some user data
      final notifier = container.read(userProvider.notifier);
      notifier.setUser(
        UserModel(
          id: '123',
          fullName: 'Test User',
          email: 'test@example.com',
          role: 'listener',
          token: 'test_token',
        ),
        'test_token',
        'listener',
      );

      // Act
      notifier.logout();

      // Assert
      final state = container.read(userProvider);
      expect(state.user, isNull);
      expect(state.token, isNull);
      expect(state.role, isNull);
    });
  });
}
