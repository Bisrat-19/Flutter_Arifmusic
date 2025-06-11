import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    test('should create UserModel from JSON', () {
      // Arrange
      final json = {
        '_id': '123',
        'fullName': 'John Doe',
        'email': 'john@example.com',
        'role': 'listener',
        'profileImage': 'image_url',
      };

      // Act
      final user = UserModel.fromJson(json);

      // Assert
      expect(user.id, '123');
      expect(user.fullName, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.role, 'listener');
      expect(user.profileImage, 'image_url');
    });

    test('should create UserModel with null profileImage', () {
      // Arrange
      final json = {
        '_id': '123',
        'fullName': 'John Doe',
        'email': 'john@example.com',
        'role': 'listener',
      };

      // Act
      final user = UserModel.fromJson(json);

      // Assert
      expect(user.profileImage, isNull);
    });

    test('should convert UserModel to JSON', () {
      // Arrange
      final user = UserModel(
        id: '123',
        fullName: 'John Doe',
        email: 'john@example.com',
        role: 'listener',
        token: 'token123',
        profileImage: 'image_url',
      );

      // Act
      final json = user.toJson();

      // Assert
      expect(json['_id'], '123');
      expect(json['fullName'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['role'], 'listener');
      expect(json['profileImage'], 'image_url');
    });

    test('should handle equality comparison', () {
      // Arrange
      final user1 = UserModel(
        id: '123',
        fullName: 'John Doe',
        email: 'john@example.com',
        role: 'listener',
        token: 'token123',
      );

      final user2 = UserModel(
        id: '123',
        fullName: 'John Doe',
        email: 'john@example.com',
        role: 'listener',
        token: 'token123',
      );

      final user3 = UserModel(
        id: '456',
        fullName: 'Jane Doe',
        email: 'jane@example.com',
        role: 'artist',
        token: 'token456',
      );

      // Act & Assert
      expect(user1.id, equals(user2.id));
      expect(user1.id, isNot(equals(user3.id)));
    });

    test('should create UserModel with required fields only', () {
      // Arrange & Act
      final user = UserModel(
        id: '123',
        fullName: 'John Doe',
        email: 'john@example.com',
        role: 'listener',
        token: 'token123',
      );

      // Assert
      expect(user.id, '123');
      expect(user.fullName, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.role, 'listener');
      expect(user.token, 'token123');
      expect(user.profileImage, isNull);
    });
  });
}
