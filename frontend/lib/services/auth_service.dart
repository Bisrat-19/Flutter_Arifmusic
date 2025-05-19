import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String baseUrl = "http://localhost:3000"; 
final storage = FlutterSecureStorage();

class AuthService {
  static Future<bool> register(String fullName, String email, String password, String role) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'email': email,
        'password': password,
        'role': role
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await storage.write(key: "token", value: data["token"]);
      return true;
    }
    return false;
  }

  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: "token", value: data["token"]);
      return true;
    }
    return false;
  }
}
