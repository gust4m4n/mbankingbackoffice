class MbxTransactionStats {
  final int today;
  final int thisMonth;
  final int thisYear;

  const MbxTransactionStats({
    required this.today,
    required this.thisMonth,
    required this.thisYear,
  });

  factory MbxTransactionStats.fromJson(Map<String, dynamic> json) {
    return MbxTransactionStats(
      today: json['today'] ?? 0,
      thisMonth: json['this_month'] ?? 0,
      thisYear: json['this_year'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'today': today, 'this_month': thisMonth, 'this_year': thisYear};
  }
}

class MbxDashboardModel {
  final int totalUsers;
  final int totalAdmins;
  final MbxTransactionStats totalTransactions;
  final MbxTransactionStats topupTransactions;
  final MbxTransactionStats withdrawTransactions;
  final MbxTransactionStats transferTransactions;

  const MbxDashboardModel({
    required this.totalUsers,
    required this.totalAdmins,
    required this.totalTransactions,
    required this.topupTransactions,
    required this.withdrawTransactions,
    required this.transferTransactions,
  });

  factory MbxDashboardModel.fromJson(Map<String, dynamic> json) {
    return MbxDashboardModel(
      totalUsers: json['total_users'] ?? 0,
      totalAdmins: json['total_admins'] ?? 0,
      totalTransactions: MbxTransactionStats.fromJson(
        json['total_transactions'] ?? {},
      ),
      topupTransactions: MbxTransactionStats.fromJson(
        json['topup_transactions'] ?? {},
      ),
      withdrawTransactions: MbxTransactionStats.fromJson(
        json['withdraw_transactions'] ?? {},
      ),
      transferTransactions: MbxTransactionStats.fromJson(
        json['transfer_transactions'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_users': totalUsers,
      'total_admins': totalAdmins,
      'total_transactions': totalTransactions.toJson(),
      'topup_transactions': topupTransactions.toJson(),
      'withdraw_transactions': withdrawTransactions.toJson(),
      'transfer_transactions': transferTransactions.toJson(),
    };
  }
}
