class MbxUserModel {
  final int id;
  final String name;
  final String accountNumber;
  final String phone;
  final String motherName;
  final String pinAtm;
  final double balance;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  MbxUserModel({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.phone,
    required this.motherName,
    required this.pinAtm,
    required this.balance,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory MbxUserModel.fromJson(Map<String, dynamic> json) {
    return MbxUserModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      accountNumber: json['account_number']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      motherName: json['mother_name']?.toString() ?? '',
      pinAtm: json['pin_atm']?.toString() ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
      status: json['status']?.toString() ?? 'active',
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'account_number': accountNumber,
      'phone': phone,
      'mother_name': motherName,
      'pin_atm': pinAtm,
      'balance': balance,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Helper methods
  bool get isActive => status.toLowerCase() == 'active';

  String get displayStatus {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Active';
      case 'inactive':
        return 'Inactive';
      case 'suspended':
        return 'Suspended';
      case 'blocked':
        return 'Blocked';
      default:
        return status;
    }
  }

  String get formattedBalance {
    return 'Rp ${balance.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String get maskedAccountNumber {
    if (accountNumber.length <= 4) return accountNumber;
    return '**** **** **** ${accountNumber.substring(accountNumber.length - 4)}';
  }

  String get maskedPinAtm {
    return '*' * pinAtm.length;
  }

  @override
  String toString() {
    return 'MbxUserModel(id: $id, name: $name, accountNumber: $accountNumber, balance: $balance, status: $status)';
  }
}

// Request models for API calls
class MbxCreateUserRequest {
  final String name;
  final String accountNumber;
  final String phone;
  final String motherName;
  final String pinAtm;
  final double initialBalance;

  MbxCreateUserRequest({
    required this.name,
    required this.accountNumber,
    required this.phone,
    required this.motherName,
    required this.pinAtm,
    this.initialBalance = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'account_number': accountNumber,
      'phone': phone,
      'mother_name': motherName,
      'pin_atm': pinAtm,
      'balance': initialBalance,
    };
  }
}

class MbxUpdateUserRequest {
  final String name;
  final String phone;
  final String motherName;
  final String status;

  MbxUpdateUserRequest({
    required this.name,
    required this.phone,
    required this.motherName,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'mother_name': motherName,
      'status': status,
    };
  }
}

// Response model for user list
class MbxUserListResponse {
  final List<MbxUserModel> users;
  final int total;
  final int page;
  final int perPage;
  final int totalPages;

  MbxUserListResponse({
    required this.users,
    required this.total,
    required this.page,
    required this.perPage,
    required this.totalPages,
  });

  factory MbxUserListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> userList = json['users'] ?? json['data'] ?? [];
    final users = userList.map((user) => MbxUserModel.fromJson(user)).toList();
    final total = json['total'] ?? users.length;
    final perPage = json['per_page'] ?? users.length;
    final totalPages = json['total_pages'] ?? (total / perPage).ceil();

    return MbxUserListResponse(
      users: users,
      total: total,
      page: json['page'] ?? 1,
      perPage: perPage,
      totalPages: totalPages,
    );
  }
}
