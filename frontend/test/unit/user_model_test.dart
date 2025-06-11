import 'package:flutter_test/flutter_test.dart';
import '../../lib/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromJson returns valid UserModel', () {
      final json = {
        '_id': '123',
        'fullName': 'Test User',
        'email': 'test@example.com',
        'role': 'listener',
        'profileImagePath': 'path/to/image.png',
      };
      final user = UserModel.fromJson(json);
      expect(user.id, '123');
      expect(user.fullName, 'Test User');
      expect(user.email, 'test@example.com');
      expect(user.role, 'listener');
      expect(user.profileImagePath, 'path/to/image.png');
    });

    test('fromJson throws FormatException for missing id', () {
      final json = {
        'fullName': 'Test User',
        'email': 'test@example.com',
        'role': 'listener',
      };
      expect(() => UserModel.fromJson(json), throwsFormatException);
    });

    test('fromJson throws FormatException for invalid role', () {
      final json = {
        '_id': '123',
        'fullName': 'Test User',
        'email': 'test@example.com',
        'role': 'invalid',
      };
      expect(() => UserModel.fromJson(json), throwsFormatException);
    });

    test('toJson returns correct map', () {
      final user = UserModel(
        id: '123',
        fullName: 'Test User',
        email: 'test@example.com',
        role: 'listener',
        profileImagePath: 'path/to/image.png',
      );
      final json = user.toJson();
      expect(json['_id'], '123');
      expect(json['fullName'], 'Test User');
      expect(json['email'], 'test@example.com');
      expect(json['role'], 'listener');
      expect(json['profileImagePath'], 'path/to/image.png');
    });
  });
} 