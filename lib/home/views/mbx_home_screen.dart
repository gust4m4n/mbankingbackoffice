import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

import '../models/mbx_dashboard_model.dart';
import 'mbx_home_controller.dart';

class MbxHomeScreen extends StatelessWidget {
  const MbxHomeScreen({super.key});

  // Helper method to format numbers with thousand separator
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MbxHomeController>(
      init: MbxHomeController(),
      builder: (controller) {
        return MbxManagementScaffold(
          title: 'Dashboard',
          currentRoute: '/home',
          showAddButton: false,
          onRefreshPressed: () => controller.refreshDashboard(),
          child: _buildDashboardContent(controller),
        );
      },
    );
  }

  Widget _buildDashboardContent(MbxHomeController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to MBanking BackOffice',
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your banking operations efficiently',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Quick Stats Cards
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final dashboard = controller.dashboardData.value;

                return isMobile
                    ? Column(
                        children: [
                          _buildStatCard(
                            'Total Users',
                            _formatNumber(dashboard?.totalUsers ?? 0),
                            Icons.people,
                            Colors.blue,
                          ),
                          const SizedBox(height: 16),
                          _buildStatCard(
                            'Total Admins',
                            _formatNumber(dashboard?.totalAdmins ?? 0),
                            Icons.admin_panel_settings,
                            Colors.indigo,
                          ),
                          const SizedBox(height: 16),
                          _buildStatCard(
                            'Total Transactions',
                            _formatNumber(
                              dashboard?.totalTransactions.thisMonth ?? 0,
                            ),
                            Icons.receipt_long,
                            Colors.green,
                          ),
                          const SizedBox(height: 16),
                          _buildStatCard(
                            'Withdraw Transactions',
                            _formatNumber(
                              dashboard?.withdrawTransactions.thisMonth ?? 0,
                            ),
                            Icons.money_off,
                            Colors.red,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Users',
                              _formatNumber(dashboard?.totalUsers ?? 0),
                              Icons.people,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Total Admins',
                              _formatNumber(dashboard?.totalAdmins ?? 0),
                              Icons.admin_panel_settings,
                              Colors.indigo,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Total Transactions',
                              _formatNumber(
                                dashboard?.totalTransactions.thisMonth ?? 0,
                              ),
                              Icons.receipt_long,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Withdraw Transactions',
                              _formatNumber(
                                dashboard?.withdrawTransactions.thisMonth ?? 0,
                              ),
                              Icons.money_off,
                              Colors.red,
                            ),
                          ),
                        ],
                      );
              }),

              const SizedBox(height: 32),

              // System Overview
              Obx(() {
                return controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.dashboardData.value != null
                    ? _buildSystemOverview(controller.dashboardData.value!)
                    : Container();
              }),

              const SizedBox(height: 32),

              // Transaction Stats by Period
              Obx(() {
                return controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.dashboardData.value != null
                    ? _buildTransactionStatsByPeriod(
                        controller.dashboardData.value!,
                      )
                    : Container();
              }),

              const SizedBox(height: 32),

              // Transaction Breakdown
              Obx(() {
                return controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.dashboardData.value != null
                    ? _buildTransactionBreakdown(
                        controller.dashboardData.value!,
                      )
                    : Container();
              }),

              const SizedBox(height: 32),

              // Transaction Amounts
              Obx(() {
                return controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.dashboardData.value != null
                    ? _buildTransactionAmounts(controller.dashboardData.value!)
                    : Container();
              }),

              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionStatsByPeriod(MbxDashboardModel dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaction Statistics by Period',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildPeriodStatsCard(
                'Today',
                dashboard.totalTransactions.today,
                dashboard.topupTransactions.today,
                dashboard.withdrawTransactions.today,
                dashboard.transferTransactions.today,
                const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPeriodStatsCard(
                'This Month',
                dashboard.totalTransactions.thisMonth,
                dashboard.topupTransactions.thisMonth,
                dashboard.withdrawTransactions.thisMonth,
                dashboard.transferTransactions.thisMonth,
                const Color(0xFF2196F3),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPeriodStatsCard(
                'This Year',
                dashboard.totalTransactions.thisYear,
                dashboard.topupTransactions.thisYear,
                dashboard.withdrawTransactions.thisYear,
                dashboard.transferTransactions.thisYear,
                const Color(0xFF9C27B0),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPeriodStatsCard(
    String period,
    int total,
    int topup,
    int withdraw,
    int transfer,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.timeline, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    period,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatRow('Total', _formatNumber(total), color),
          const SizedBox(height: 8),
          _buildStatRow('Topup', _formatNumber(topup), Colors.green),
          const SizedBox(height: 8),
          _buildStatRow('Withdraw', _formatNumber(withdraw), Colors.red),
          const SizedBox(height: 8),
          _buildStatRow('Transfer', _formatNumber(transfer), Colors.blue),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 1,
          child: Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          flex: 1,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionBreakdown(MbxDashboardModel dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaction Breakdown by Period',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Today\'s Activity',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildEnhancedBreakdownCard(
                'Topup Today',
                dashboard.topupTransactions.today,
                dashboard.topupTransactions.todayAmount,
                Icons.add_circle,
                const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildEnhancedBreakdownCard(
                'Withdraw Today',
                dashboard.withdrawTransactions.today,
                dashboard.withdrawTransactions.todayAmount,
                Icons.remove_circle,
                const Color(0xFFF44336),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildEnhancedBreakdownCard(
                'Transfer Today',
                dashboard.transferTransactions.today,
                dashboard.transferTransactions.todayAmount,
                Icons.swap_horiz,
                const Color(0xFF2196F3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'This Month\'s Performance',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildEnhancedBreakdownCard(
                'Topup This Month',
                dashboard.topupTransactions.thisMonth,
                dashboard.topupTransactions.thisMonthAmount,
                Icons.add_circle,
                const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildEnhancedBreakdownCard(
                'Withdraw This Month',
                dashboard.withdrawTransactions.thisMonth,
                dashboard.withdrawTransactions.thisMonthAmount,
                Icons.remove_circle,
                const Color(0xFFF44336),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildEnhancedBreakdownCard(
                'Transfer This Month',
                dashboard.transferTransactions.thisMonth,
                dashboard.transferTransactions.thisMonthAmount,
                Icons.swap_horiz,
                const Color(0xFF2196F3),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionAmounts(MbxDashboardModel dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaction Values (Amount)',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Today\'s Transaction Values',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildAmountCard(
                'Total Transactions',
                'Rp ${_formatNumber(dashboard.totalTransactions.todayAmount.toInt())}',
                Icons.receipt_long,
                const Color(0xFF9C27B0),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAmountCard(
                'Topup Amount',
                'Rp ${_formatNumber(dashboard.topupTransactions.todayAmount.toInt())}',
                Icons.add_circle,
                const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAmountCard(
                'Transfer Amount',
                'Rp ${_formatNumber(dashboard.transferTransactions.todayAmount.toInt())}',
                Icons.swap_horiz,
                const Color(0xFF2196F3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'This Month\'s Transaction Values',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildAmountCard(
                'Total Transactions',
                'Rp ${_formatNumber(dashboard.totalTransactions.thisMonthAmount.toInt())}',
                Icons.receipt_long,
                const Color(0xFF9C27B0),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAmountCard(
                'Topup Amount',
                'Rp ${_formatNumber(dashboard.topupTransactions.thisMonthAmount.toInt())}',
                Icons.add_circle,
                const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildAmountCard(
                'Transfer Amount',
                'Rp ${_formatNumber(dashboard.transferTransactions.thisMonthAmount.toInt())}',
                Icons.swap_horiz,
                const Color(0xFF2196F3),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSystemOverview(MbxDashboardModel dashboard) {
    double userToAdminRatio = dashboard.totalUsers / dashboard.totalAdmins;
    double todayToMonthRatio =
        dashboard.totalTransactions.today /
        dashboard.totalTransactions.thisMonth *
        100;
    double monthToYearRatio =
        dashboard.totalTransactions.thisMonth /
        dashboard.totalTransactions.thisYear *
        100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'System Overview & Analytics',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInsightCard(
                'User to Admin Ratio',
                '${userToAdminRatio.toStringAsFixed(1)}:1',
                'Users per admin',
                Icons.balance,
                Colors.deepPurple,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInsightCard(
                'Today Activity',
                '${todayToMonthRatio.toStringAsFixed(1)}%',
                'of monthly transactions',
                Icons.today,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInsightCard(
                'Monthly Progress',
                '${monthToYearRatio.toStringAsFixed(1)}%',
                'of yearly target',
                Icons.trending_up,
                Colors.teal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInsightCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedBreakdownCard(
    String title,
    int count,
    double amount,
    IconData icon,
    Color color,
  ) {
    print(
      '🔍 _buildEnhancedBreakdownCard: $title - Count: $count, Amount: $amount',
    );
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Primary focus: Transaction Amount (large, prominent)
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Rp ${_formatNumber(amount.toInt())}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                // Secondary info: Transaction Count (smaller, muted)
                Text(
                  '${_formatNumber(count)} transactions',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: color.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.08), color.withOpacity(0.03)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
