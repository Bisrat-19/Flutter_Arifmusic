import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../core/config/constants.dart';
import 'user_remote_data_source.dart';
import 'package:http_parser/http_parser.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImpl({Dio? dio})
      : dio = dio ?? Dio(BaseOptions(baseUrl: baseUrl, headers: {'Content-Type': 'application/json'}));

  @override
  Future<Map<String, dynamic>> register(String fullName, String email, String password, String role) async {
    try {
      final response = await dio.post(
        '/api/auth/register',
        data: {
          'fullName': fullName,
          'email': email,
          'password': password,
          'role': role,
        },
      );

      if (response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception('Failed to register user: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error during register: ${e.response?.data ?? e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to login: ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error during login: ${e.response?.data ?? e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> getProfile(String token) async {
    try {
      final response = await dio.get(
        '/api/users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get profile: ${response.data['message'] ?? response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error during getProfile: ${e.response?.data['message'] ?? e.message}');
    }
  }

  @override
  Future<Map<String, dynamic>> updateProfileImage(String token, String userId, Uint8List imageBytes, String fileName) async {
    try {
      final formData = FormData();
      if (imageBytes != null && imageBytes.isNotEmpty) {
        String extension = fileName.split('.').last.toLowerCase();
        String mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';
        formData.files.add(MapEntry(
          'profileImage',
          MultipartFile.fromBytes(
            imageBytes,
            filename: fileName,
            contentType: MediaType('image', mimeType.split('/').last),
          ),
        ));
      } else {
        throw Exception('No image data provided');
      }

      final response = await dio.put(
        '/api/users/$userId/profile-image',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to update profile image: ${response.data['message'] ?? response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error during updateProfileImage: ${e.response?.data['message'] ?? e.message}');
    }
  }
}