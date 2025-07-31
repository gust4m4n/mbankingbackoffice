class MbxAdminModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String status;
  final String? createdAt;
  final String? updatedAt;
  final String? lastLoginAt;

  MbxAdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
  });

  factory MbxAdminModel.fromJson(Map<String, dynamic> json) {
    return MbxAdminModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] is int
          ? (json['status'] == 1 ? 'active' : 'inactive')
          : json['status'] ?? 'inactive',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      lastLoginAt: json['last_login_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'last_login_at': lastLoginAt,
    };
  }

  bool get isActive => status.toLowerCase() == 'active';
  bool get isSuperAdmin => role.toLowerCase() == 'super';
  bool get isAdmin => role.toLowerCase() == 'admin';

  String get displayRole {
    switch (role.toLowerCase()) {
      case 'super':
        return 'Super Admin';
      case 'admin':
        return 'Admin';
      default:
        return role;
    }
  }

  String get displayStatus {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'inactive':
        return 'Inactive';
      case 'suspended':
        return 'Suspended';
      default:
        return status;
    }
  }
}

class MbxAdminListResponse {
  final List<MbxAdminModel> admins;
  final int total;
  final int page;
  final int perPage;
  final int totalPages;

  MbxAdminListResponse({
    required this.admins,
    required this.total,
    required this.page,
    required this.perPage,
    required this.totalPages,
  });

  factory MbxAdminListResponse.fromJson(Map<String, dynamic> json) {
    return MbxAdminListResponse(
      admins:
          (json['admins'] as List<dynamic>?)
              ?.map((item) => MbxAdminModel.fromJson(item))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      totalPages: json['total_pages'] ?? 1,
    );
  }
}

class MbxCreateAdminRequest {
  final String name;
  final String email;
  final String password;
  final String role;

  MbxCreateAdminRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'password': password, 'role': role};
  }
}

class MbxUpdateAdminRequest {
  final String name;
  final String email;
  final String role;
  final String status;

  MbxUpdateAdminRequest({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'role': role, 'status': status};
  }
}
