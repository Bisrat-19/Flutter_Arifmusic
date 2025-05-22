abstract class UserRemoteDataSource {
  Future<Map<String, dynamic>> register(String fullName, String email, String password, String role);
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> getProfile(String token);
}
