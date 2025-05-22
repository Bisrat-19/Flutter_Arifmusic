import '../entities/user.dart';
abstract class UserRepository {
  Future<User> register(String fullName, String email, String password, String role);
  Future<User> login(String email, String password);
  Future<User> getProfile();
  Future<void> logout();

  // Add these missing methods
  Future<String?> getToken();
  Future<Map<String, dynamic>?> getUserData();
  Future<void> saveUserData(String token, Map<String, dynamic> userData);
  Future<void> clearUserData();
}
