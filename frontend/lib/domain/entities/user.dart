class User {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String token;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
      'token': token,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
