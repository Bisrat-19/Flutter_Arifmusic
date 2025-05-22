import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository userRepository;

  UserModel? _user;
  String? _token;

  UserProvider({required this.userRepository});

  UserModel? get user => _user;
  String? get token => _token;

  Future<void> initializeUser() async {
    _token = await userRepository.getToken();
    if (_token != null) {
      final userData = await userRepository.getUserData();
      if (userData != null) {
        _user = UserModel.fromJson(userData);
        notifyListeners();
      }
    }
  }

  void setUser(String token, Map<String, dynamic> userData) {
    _token = token;
    _user = UserModel.fromJson(userData);
    userRepository.saveUserData(token, userData);
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _token = null;
    userRepository.clearUserData();
    notifyListeners();
  }

  void logout() {
    clearUser();
  }
}
