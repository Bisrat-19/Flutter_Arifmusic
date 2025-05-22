import '../services/auth_service.dart';
class AuthRepo {
  Future<User?> login(String email, String password) {
    return AuthService.login(email, password);
  }

  Future<User?> register(String fullName, String email, String password, String role) {
    return AuthService.register(fullName, email, password, role);
  }

  Future<void> logout() async {
    await AuthService.logout();
  }

  Future<String?> getToken() async {
    return await AuthService.getToken();
  }
}
