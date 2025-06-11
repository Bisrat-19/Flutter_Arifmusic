import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/models/user_model.dart';
import '../datasources/user/user_remote_data_source.dart';
import '../datasources/user/local_storage_service.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final LocalStorageService localStorageService;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localStorageService,
  });

  @override
  Future<User> register(String fullName, String email, String password, String role) async {
    final data = await remoteDataSource.register(fullName, email, password, role);
    await localStorageService.saveUserData(data['token'], data['user']);
    return UserModel.fromJson(data['user']);
  }

  @override
  Future<User> login(String email, String password) async {
    final data = await remoteDataSource.login(email, password);
    await localStorageService.saveUserData(data['token'], data['user']);
    return UserModel.fromJson(data['user']);
  }

  @override
  Future<User> getProfile() async {
    final token = await localStorageService.getToken();
    if (token == null) throw Exception('No token found');
    final data = await remoteDataSource.getProfile(token);
    return UserModel.fromJson(data);
  }

  @override
  Future<void> logout() async {
    await localStorageService.clearUserData();
  }

  // ✅ Added methods
  @override
  Future<String?> getToken() async {
    return await localStorageService.getToken();
  }

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    return await localStorageService.getUserData();
  }

  @override
  Future<void> saveUserData(String token, Map<String, dynamic> userData) async {
    await localStorageService.saveUserData(token, userData);
  }

  @override
  Future<void> clearUserData() async {
    await localStorageService.clearUserData();
  }
}
