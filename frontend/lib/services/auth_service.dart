import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String baseUrl = "http://localhost:3000";
final storage = FlutterSecureStorage();

class User {
  final String fullName;
  final String email;
  final String role;
  final String token;

  User({
    required this.fullName,
    required this.email,
    required this.role,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'role': role,
      'token': token,
    };
  }
}

class AuthService {
  static Future<User?> register(String fullName, String email, String password, String role) async {
    final url = Uri.parse('$baseUrl/api/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await storage.write(key: 'token', value: data['token']);
          return User.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<User?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await storage.write(key: 'token', value: data['token']);
          return User.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> logout() async {
    await storage.delete(key: 'token');
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }
}
