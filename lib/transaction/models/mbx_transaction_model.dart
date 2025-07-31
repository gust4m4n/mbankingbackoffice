class MbxTransactionModel {
  final String id;
  final String userId;
  final String userName;
  final String userAccountNumber;
  final String type;
  final double amount;
  final String status;
  final String? description;
  final String? targetAccountNumber;
  final String? targetUserName;
  final double? balanceBefore;
  final double? balanceAfter;
  final String createdAt;
  final String? updatedAt;
  final bool isReversed;
  final String? reversalReason;
  final String? reversedAt;

  MbxTransactionModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAccountNumber,
    required this.type,
    required this.amount,
    required this.status,
    this.description,
    this.targetAccountNumber,
    this.targetUserName,
    this.balanceBefore,
    this.balanceAfter,
    required this.createdAt,
    this.updatedAt,
    this.isReversed = false,
    this.reversalReason,
    this.reversedAt,
  });

  factory MbxTransactionModel.fromJson(Map<String, dynamic> json) {
    return MbxTransactionModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      userAccountNumber: json['user_account_number']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      status: json['status']?.toString() ?? '',
      description: json['description']?.toString(),
      targetAccountNumber: json['target_account_number']?.toString(),
      targetUserName: json['target_user_name']?.toString(),
      balanceBefore: json['balance_before']?.toDouble(),
      balanceAfter: json['balance_after']?.toDouble(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString(),
      isReversed: json['is_reversed'] ?? false,
      reversalReason: json['reversal_reason']?.toString(),
      reversedAt: json['reversed_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_account_number': userAccountNumber,
      'type': type,
      'amount': amount,
      'status': status,
      'description': description,
      'target_account_number': targetAccountNumber,
      'target_user_name': targetUserName,
      'balance_before': balanceBefore,
      'balance_after': balanceAfter,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_reversed': isReversed,
      'reversal_reason': reversalReason,
      'reversed_at': reversedAt,
    };
  }

  // Helper methods for display
  String get displayType {
    switch (type.toLowerCase()) {
      case 'topup':
        return 'Top Up';
      case 'withdraw':
        return 'Withdraw';
      case 'transfer':
        return 'Transfer';
      case 'reversal':
        return 'Reversal';
      default:
        return type;
    }
  }

  String get displayStatus {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Completed';
      case 'failed':
        return 'Failed';
      case 'cancelled':
        return 'Cancelled';
      case 'reversed':
        return 'Reversed';
      default:
        return status;
    }
  }

  String get formattedAmount {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String get maskedAccountNumber {
    if (userAccountNumber.length <= 4) return userAccountNumber;
    final visible = userAccountNumber.substring(userAccountNumber.length - 4);
    final masked = '*' * (userAccountNumber.length - 4);
    return '$masked$visible';
  }

  String get maskedTargetAccountNumber {
    if (targetAccountNumber == null || targetAccountNumber!.length <= 4) {
      return targetAccountNumber ?? '';
    }
    final visible = targetAccountNumber!.substring(
      targetAccountNumber!.length - 4,
    );
    final masked = '*' * (targetAccountNumber!.length - 4);
    return '$masked$visible';
  }

  String get formattedCreatedAt {
    try {
      final date = DateTime.parse(createdAt);
      return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return createdAt;
    }
  }

  // Helper method for balance change display
  String get balanceChangeDisplay {
    if (balanceBefore == null || balanceAfter == null) return '';
    final change = balanceAfter! - balanceBefore!;
    final changeStr = change >= 0
        ? '+${change.toStringAsFixed(0)}'
        : change.toStringAsFixed(0);
    return 'Rp ${changeStr.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }
}

class MbxTransactionListResponse {
  final List<MbxTransactionModel> transactions;
  final int total;
  final int totalPages;
  final int currentPage;
  final int perPage;

  MbxTransactionListResponse({
    required this.transactions,
    required this.total,
    required this.totalPages,
    required this.currentPage,
    required this.perPage,
  });

  factory MbxTransactionListResponse.fromJson(Map<String, dynamic> json) {
    final transactionsData = json['transactions'] as List<dynamic>? ?? [];
    final pagination = json['pagination'] as Map<String, dynamic>? ?? {};

    return MbxTransactionListResponse(
      transactions: transactionsData
          .map(
            (item) =>
                MbxTransactionModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      total: pagination['total'] ?? 0,
      totalPages: pagination['total_pages'] ?? 0,
      currentPage: pagination['current_page'] ?? 1,
      perPage: pagination['per_page'] ?? 10,
    );
  }
}

class MbxTransactionReversalRequest {
  final String transactionId;
  final String reason;

  MbxTransactionReversalRequest({
    required this.transactionId,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {'transaction_id': transactionId, 'reason': reason};
  }
}
