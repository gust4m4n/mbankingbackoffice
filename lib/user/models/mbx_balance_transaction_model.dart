class MbxBalanceTransactionModel {
  final String transactionId;
  final int userId;
  final String userName;
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String type;
  final String? reason;
  final String? description;
  final int adminId;
  final String adminName;
  final DateTime createdAt;

  MbxBalanceTransactionModel({
    required this.transactionId,
    required this.userId,
    required this.userName,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.type,
    this.reason,
    this.description,
    required this.adminId,
    required this.adminName,
    required this.createdAt,
  });

  factory MbxBalanceTransactionModel.fromJson(Map<String, dynamic> json) {
    return MbxBalanceTransactionModel(
      transactionId: json['transaction_id']?.toString() ?? '',
      userId: json['user_id'] ?? 0,
      userName: json['user_name']?.toString() ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      balanceBefore: (json['balance_before'] ?? 0).toDouble(),
      balanceAfter: (json['balance_after'] ?? 0).toDouble(),
      type: json['type']?.toString() ?? '',
      reason: json['reason']?.toString(),
      description: json['description']?.toString(),
      adminId: json['admin_id'] ?? 0,
      adminName: json['admin_name']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'user_id': userId,
      'user_name': userName,
      'amount': amount,
      'balance_before': balanceBefore,
      'balance_after': balanceAfter,
      'type': type,
      'reason': reason,
      'description': description,
      'admin_id': adminId,
      'admin_name': adminName,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get formattedAmount {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String get formattedBalanceBefore {
    return 'Rp ${balanceBefore.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String get formattedBalanceAfter {
    return 'Rp ${balanceAfter.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String get formattedDate {
    return '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  String get displayType {
    switch (type.toLowerCase()) {
      case 'topup':
        return 'Top Up';
      case 'adjustment':
        return 'Adjustment';
      case 'correction':
        return 'Correction';
      case 'manual_correction':
        return 'Manual Correction';
      case 'error_correction':
        return 'Error Correction';
      case 'set_balance':
        return 'Set Balance';
      default:
        return type;
    }
  }

  bool get isCredit {
    return amount >= 0;
  }

  /// Formatted created at date for display
  String get formattedCreatedAt {
    return '${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'MbxBalanceTransactionModel(transactionId: $transactionId, userId: $userId, userName: $userName, amount: $amount, type: $type)';
  }
}
