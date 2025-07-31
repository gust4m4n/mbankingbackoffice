class MbxPerformanceData {
  final double amount;
  final int count;
  final String period;

  const MbxPerformanceData({
    required this.amount,
    required this.count,
    required this.period,
  });

  factory MbxPerformanceData.fromJson(Map<String, dynamic> json) {
    return MbxPerformanceData(
      amount: (json['amount'] ?? 0).toDouble(),
      count: json['count'] ?? 0,
      period: json['period'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'count': count, 'period': period};
  }
}

class MbxPerformanceStats {
  final List<MbxPerformanceData> monthly;
  final List<MbxPerformanceData> weekly;
  final List<MbxPerformanceData> yearly;

  const MbxPerformanceStats({
    required this.monthly,
    required this.weekly,
    required this.yearly,
  });

  factory MbxPerformanceStats.fromJson(Map<String, dynamic> json) {
    return MbxPerformanceStats(
      monthly:
          (json['monthly'] as List<dynamic>?)
              ?.map((item) => MbxPerformanceData.fromJson(item))
              .toList() ??
          [],
      weekly:
          (json['weekly'] as List<dynamic>?)
              ?.map((item) => MbxPerformanceData.fromJson(item))
              .toList() ??
          [],
      yearly:
          (json['yearly'] as List<dynamic>?)
              ?.map((item) => MbxPerformanceData.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthly': monthly.map((item) => item.toJson()).toList(),
      'weekly': weekly.map((item) => item.toJson()).toList(),
      'yearly': yearly.map((item) => item.toJson()).toList(),
    };
  }
}

class MbxTransactionStats {
  final int today;
  final int thisMonth;
  final int thisYear;
  final double todayAmount;
  final double thisMonthAmount;
  final double thisYearAmount;

  const MbxTransactionStats({
    required this.today,
    required this.thisMonth,
    required this.thisYear,
    required this.todayAmount,
    required this.thisMonthAmount,
    required this.thisYearAmount,
  });

  factory MbxTransactionStats.fromJson(Map<String, dynamic> json) {
    return MbxTransactionStats(
      today: json['today'] ?? 0,
      thisMonth: json['this_month'] ?? 0,
      thisYear: json['this_year'] ?? 0,
      todayAmount: (json['today_amount'] ?? 0).toDouble(),
      thisMonthAmount: (json['this_month_amount'] ?? 0).toDouble(),
      thisYearAmount: (json['this_year_amount'] ?? 0).toDouble(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'today': today,
      'this_month': thisMonth,
      'this_year': thisYear,
      'today_amount': todayAmount,
      'this_month_amount': thisMonthAmount,
      'this_year_amount': thisYearAmount,
    };
  }
}

class MbxDashboardModel {
  final int totalUsers;
  final int totalAdmins;
  final MbxTransactionStats totalTransactions;
  final MbxTransactionStats topupTransactions;
  final MbxTransactionStats withdrawTransactions;
  final MbxTransactionStats transferTransactions;
  final MbxPerformanceStats? performance;

  const MbxDashboardModel({
    required this.totalUsers,
    required this.totalAdmins,
    required this.totalTransactions,
    required this.topupTransactions,
    required this.withdrawTransactions,
    required this.transferTransactions,
    this.performance,
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
      performance: json['performance'] != null
          ? MbxPerformanceStats.fromJson(json['performance'])
          : null,
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
      'performance': performance?.toJson(),
    };
  }
}
