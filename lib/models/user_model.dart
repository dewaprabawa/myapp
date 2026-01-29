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

class UserListResponse {
  final bool success;
  final String message;
  final List<User>? data;
  final Meta? meta;

  UserListResponse({
    required this.success,
    required this.message,
    this.data,
    this.meta,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    return UserListResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? (json['data'] as List).map((i) => User.fromJson(i)).toList()
          : null,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }
}

class Meta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  Meta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
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
  final int? partnerId;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final bool isActive;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final List<String> roles;
  final Partner? partner;

  User({
    required this.id,
    this.partnerId,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    required this.isActive,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    required this.roles,
    this.partner,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      partnerId: json['partner_id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
      isActive: json['is_active'] ?? false,
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
  final String? province;
  final String? postalCode;
  final String? phone;
  final String? email;
  final String? npwp;
  final int? creditLimit;
  final int? paymentTermDays;
  final bool isActive;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;

  Partner({
    required this.id,
    required this.code,
    required this.name,
    this.address,
    this.city,
    this.province,
    this.postalCode,
    this.phone,
    this.email,
    this.npwp,
    this.creditLimit,
    this.paymentTermDays,
    required this.isActive,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      address: json['address'],
      city: json['city'],
      province: json['province'],
      postalCode: json['postal_code'],
      phone: json['phone'],
      email: json['email'],
      npwp: json['npwp'],
      creditLimit: json['credit_limit'],
      paymentTermDays: json['payment_term_days'],
      isActive: json['is_active'] ?? false,
      notes: json['notes'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
