class User {
  final String email;
  final String? token;
  final String? message;
  final bool isAdmin;
  final int? userId;
  final String? name;
  final String? role;

  User({
    required this.email,
    this.token,
    this.message,
    this.isAdmin = false,
    this.userId,
    this.name,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      token: json['token'],
      message: json['message'],
      isAdmin: json['isAdmin'] ?? false,
      userId: json['userId'],
      name: json['name'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
      'message': message,
      'isAdmin': isAdmin,
      'userId': userId,
      'name': name,
      'role': role,
    };
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
