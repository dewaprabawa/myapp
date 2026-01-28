class LoginResponse {
  final bool success;
  final String message;
  final LoginData? data;

  LoginResponse({required this.success, required this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }
}

class UserResponse {
  final bool success;
  final String message;
  final User? data;

  UserResponse({required this.success, required this.message, this.data});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? User.fromJson(json['data']) : null,
    );
  }
}

class CommonResponse {
  final bool success;
  final String message;

  CommonResponse({required this.success, required this.message});

  factory CommonResponse.fromJson(Map<String, dynamic> json) {
    return CommonResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class LoginData {
  final User user;
  final String token;

  LoginData({required this.user, required this.token});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: User.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final List<String> roles;
  final Partner? partner;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    required this.roles,
    this.partner,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
      roles: List<String>.from(json['roles'] ?? []),
      partner: json['partner'] != null
          ? Partner.fromJson(json['partner'])
          : null,
    );
  }
}

class Partner {
  final int id;
  final String code;
  final String name;
  final String? address;
  final String? city;

  Partner({
    required this.id,
    required this.code,
    required this.name,
    this.address,
    this.city,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      address: json['address'],
      city: json['city'],
    );
  }
}
