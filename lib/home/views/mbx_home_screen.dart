import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

import '../models/mbx_dashboard_model.dart';
import 'mbx_home_controller.dart';

class MbxHomeScreen extends StatelessWidget {
  const MbxHomeScreen({super.key});

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
                            '${dashboard?.totalUsers ?? 0}',
                            Icons.people,
                            Colors.blue,
                          ),
                          const SizedBox(height: 16),
                          _buildStatCard(
                            'Total Transactions',
                            '${dashboard?.totalTransactions.thisMonth ?? 0}',
                            Icons.receipt_long,
                            Colors.green,
                          ),
                          const SizedBox(height: 16),
                          _buildStatCard(
                            'Topup Transactions',
                            '${dashboard?.topupTransactions.thisMonth ?? 0}',
                            Icons.account_balance_wallet,
                            Colors.orange,
                          ),
                          const SizedBox(height: 16),
                          _buildStatCard(
                            'Transfer Transactions',
                            '${dashboard?.transferTransactions.thisMonth ?? 0}',
                            Icons.swap_horiz,
                            Colors.purple,
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Users',
                              '${dashboard?.totalUsers ?? 0}',
                              Icons.people,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Total Transactions',
                              '${dashboard?.totalTransactions.thisMonth ?? 0}',
                              Icons.receipt_long,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Topup Transactions',
                              '${dashboard?.topupTransactions.thisMonth ?? 0}',
                              Icons.account_balance_wallet,
                              Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Transfer Transactions',
                              '${dashboard?.transferTransactions.thisMonth ?? 0}',
                              Icons.swap_horiz,
                              Colors.purple,
                            ),
                          ),
                        ],
                      );
              }),

              const SizedBox(height: 32),

              // Transaction Stats by Period
              controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.dashboardData.value != null
                  ? _buildTransactionStatsByPeriod(
                      controller.dashboardData.value!,
                    )
                  : Container(),

              const SizedBox(height: 32),

              // Transaction Breakdown
              controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.dashboardData.value != null
                  ? _buildTransactionBreakdown(controller.dashboardData.value!)
                  : Container(),

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
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
              Text(
                period,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatRow('Total', total.toString(), color),
          const SizedBox(height: 8),
          _buildStatRow('Topup', topup.toString(), Colors.green),
          const SizedBox(height: 8),
          _buildStatRow('Withdraw', withdraw.toString(), Colors.red),
          const SizedBox(height: 8),
          _buildStatRow('Transfer', transfer.toString(), Colors.blue),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
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
          'Transaction Breakdown (This Month)',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildBreakdownCard(
                'Topup Transactions',
                dashboard.topupTransactions.thisMonth.toString(),
                Icons.add_circle,
                const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildBreakdownCard(
                'Withdraw Transactions',
                dashboard.withdrawTransactions.thisMonth.toString(),
                Icons.remove_circle,
                const Color(0xFFF44336),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildBreakdownCard(
                'Transfer Transactions',
                dashboard.transferTransactions.thisMonth.toString(),
                Icons.swap_horiz,
                const Color(0xFF2196F3),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBreakdownCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
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
              Icon(icon, color: color, size: 24),
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
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
