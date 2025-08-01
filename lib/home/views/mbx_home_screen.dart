import 'package:fl_chart/fl_chart.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<MbxHomeController>(
      init: MbxHomeController(),
      builder: (controller) {
        return MbxManagementScaffold(
          title: 'Dashboard',
          currentRoute: '/home',
          showAddButton: false,
          onRefreshPressed: () => controller.refreshDashboard(),
          child: _buildDashboardContent(controller, context, isDark),
        );
      },
    );
  }

  Widget _buildDashboardContent(
    MbxHomeController controller,
    BuildContext context,
    bool isDark,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section - Hidden
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.all(24),
              //   decoration: BoxDecoration(
              //     gradient: const LinearGradient(
              //       colors: [
              //         Color(0xFF1565C0),
              //         Color(0xFF0D47A1),
              //       ], // Same as login screen
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ),
              //     borderRadius: BorderRadius.circular(16),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         'Welcome to MBanking BackOffice',
              //         style: TextStyle(
              //           fontSize: isMobile ? 20 : 28,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white, // Always white like login screen
              //         ),
              //       ),
              //       const SizedBox(height: 8),
              //       Text(
              //         'Manage your banking operations efficiently',
              //         style: TextStyle(
              //           fontSize: isMobile ? 14 : 16,
              //           color: Colors.white.withOpacity(
              //             0.9,
              //           ), // Always white like login screen
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // const SizedBox(height: 32),

              // Today's Activity (Moved to very top)
              Obx(() {
                return controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.dashboardData.value != null
                    ? _buildTodayActivity(controller.dashboardData.value!)
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
                        context,
                      )
                    : Container();
              }),

              const SizedBox(height: 32),

              // Transaction Breakdown (Modified)
              Obx(() {
                return controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.dashboardData.value != null
                    ? _buildMonthlyPerformance(controller.dashboardData.value!)
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

              const SizedBox(height: 32),

              // Performance Charts
              Obx(() {
                return controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : controller.dashboardData.value != null &&
                          controller.dashboardData.value!.performance != null
                    ? _buildPerformanceCharts(controller.dashboardData.value!)
                    : Container();
              }),

              const SizedBox(height: 32),

              // Quick Stats Overview
              _buildSectionTitle(
                'Quick Stats Overview',
                icon: Icons.dashboard,
                color: const Color(0xFF607D8B),
              ),
              const SizedBox(height: 20),

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
                            context,
                          ),
                          const SizedBox(height: 16),
                          _buildStatCard(
                            'Total Transactions',
                            _formatNumber(
                              dashboard?.totalTransactions.allTime ?? 0,
                            ),
                            Icons.receipt_long,
                            Colors.green,
                            context,
                          ),
                          const SizedBox(height: 16),
                          _buildStatCard(
                            'Total Transaction Value',
                            'Rp ${_formatNumber((dashboard?.totalTransactions.allTimeAmount ?? 0).toInt())}',
                            Icons.attach_money,
                            Colors.purple,
                            context,
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
                              context,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Total Transactions',
                              _formatNumber(
                                dashboard?.totalTransactions.allTime ?? 0,
                              ),
                              Icons.receipt_long,
                              Colors.green,
                              context,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildStatCard(
                              'Total Transaction Value',
                              'Rp ${_formatNumber((dashboard?.totalTransactions.allTimeAmount ?? 0).toInt())}',
                              Icons.attach_money,
                              Colors.purple,
                              context,
                            ),
                          ),
                        ],
                      );
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
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[900] // Lebih gelap untuk dark mode
            : Colors.white, // Background putih untuk konsistensi
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionStatsByPeriod(
    MbxDashboardModel dashboard,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Transaction Statistics by Period',
          icon: Icons.bar_chart,
          color: const Color(0xFFFF9800),
        ),
        const SizedBox(height: 20),
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
                context,
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
                context,
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
                context,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper untuk membangun card period stats yang seragam
  Widget _buildPeriodStatsCard(
    String period,
    int total,
    int topup,
    int withdraw,
    int transfer,
    Color color,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[900] // Background lebih gelap untuk dark mode
            : Colors.white, // Background putih untuk konsistensi
        borderRadius: BorderRadius.circular(12),
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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

  // Helper untuk membangun section title yang seragam di seluruh dashboard
  Widget _buildSectionTitle(String title, {IconData? icon, Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (color ?? const Color(0xFF2196F3)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color ?? const Color(0xFF2196F3),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayActivity(MbxDashboardModel dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Today\'s Activity',
          icon: Icons.today,
          color: const Color(0xFF4CAF50),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 800;

            if (isMobile) {
              return Column(
                children: [
                  _buildEnhancedBreakdownCard(
                    'Topup Today',
                    dashboard.topupTransactions.today,
                    dashboard.topupTransactions.todayAmount,
                    Icons.add_circle,
                    const Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 16),
                  _buildEnhancedBreakdownCard(
                    'Withdraw Today',
                    dashboard.withdrawTransactions.today,
                    dashboard.withdrawTransactions.todayAmount,
                    Icons.remove_circle,
                    const Color(0xFFF44336),
                  ),
                  const SizedBox(height: 16),
                  _buildEnhancedBreakdownCard(
                    'Transfer Today',
                    dashboard.transferTransactions.today,
                    dashboard.transferTransactions.todayAmount,
                    Icons.swap_horiz,
                    const Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 16),
                  _buildEnhancedBreakdownCard(
                    'Total Today',
                    dashboard.totalTransactions.today,
                    dashboard.totalTransactions.todayAmount,
                    Icons.receipt_long,
                    const Color(0xFF9C27B0),
                  ),
                ],
              );
            }

            return Row(
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
                const SizedBox(width: 16),
                Expanded(
                  child: _buildEnhancedBreakdownCard(
                    'Total Today',
                    dashboard.totalTransactions.today,
                    dashboard.totalTransactions.todayAmount,
                    Icons.receipt_long,
                    const Color(0xFF9C27B0),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildMonthlyPerformance(MbxDashboardModel dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'This Month\'s Performance',
          icon: Icons.calendar_month,
          color: const Color(0xFF2196F3),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 800;

            if (isMobile) {
              return Column(
                children: [
                  _buildEnhancedBreakdownCard(
                    'Topup This Month',
                    dashboard.topupTransactions.thisMonth,
                    dashboard.topupTransactions.thisMonthAmount,
                    Icons.add_circle_outline,
                    const Color(0xFF66BB6A),
                  ),
                  const SizedBox(height: 16),
                  _buildEnhancedBreakdownCard(
                    'Withdraw This Month',
                    dashboard.withdrawTransactions.thisMonth,
                    dashboard.withdrawTransactions.thisMonthAmount,
                    Icons.remove_circle_outline,
                    const Color(0xFFEF5350),
                  ),
                  const SizedBox(height: 16),
                  _buildEnhancedBreakdownCard(
                    'Transfer This Month',
                    dashboard.transferTransactions.thisMonth,
                    dashboard.transferTransactions.thisMonthAmount,
                    Icons.swap_horiz_outlined,
                    const Color(0xFF42A5F5),
                  ),
                ],
              );
            }

            return Row(
              children: [
                Expanded(
                  child: _buildEnhancedBreakdownCard(
                    'Topup This Month',
                    dashboard.topupTransactions.thisMonth,
                    dashboard.topupTransactions.thisMonthAmount,
                    Icons.add_circle_outline,
                    const Color(0xFF66BB6A),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildEnhancedBreakdownCard(
                    'Withdraw This Month',
                    dashboard.withdrawTransactions.thisMonth,
                    dashboard.withdrawTransactions.thisMonthAmount,
                    Icons.remove_circle_outline,
                    const Color(0xFFEF5350),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildEnhancedBreakdownCard(
                    'Transfer This Month',
                    dashboard.transferTransactions.thisMonth,
                    dashboard.transferTransactions.thisMonthAmount,
                    Icons.swap_horiz_outlined,
                    const Color(0xFF42A5F5),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTransactionAmounts(MbxDashboardModel dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Transaction Values (Amount)',
          icon: Icons.attach_money,
          color: const Color(0xFF9C27B0),
        ),
        const SizedBox(height: 20),
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
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.grey[900] // Background lebih gelap untuk dark mode
                : Colors.white, // Background putih untuk light mode
            borderRadius: BorderRadius.circular(12),
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
      },
    );
  }

  Widget _buildAmountCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.grey[900] // Background lebih gelap untuk dark mode
                : Colors.white, // Background putih untuk light mode
            borderRadius: BorderRadius.circular(12),
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
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPerformanceCharts(MbxDashboardModel dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          'Performance Analytics',
          icon: Icons.trending_up,
          color: const Color(0xFF2196F3),
        ),
        const SizedBox(height: 20),

        // Charts Grid
        LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 1200;

            if (isMobile) {
              return Column(
                children: [
                  _buildMonthlyChart(dashboard.performance!, context),
                  const SizedBox(height: 20),
                  _buildWeeklyChart(dashboard.performance!, context),
                  const SizedBox(height: 20),
                  _buildYearlyChart(dashboard.performance!, context),
                ],
              );
            } else {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildMonthlyChart(
                          dashboard.performance!,
                          context,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildWeeklyChart(
                          dashboard.performance!,
                          context,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildYearlyChart(dashboard.performance!, context),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildChartTitle(String title, BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.analytics,
            color: Color(0xFF2196F3),
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildMonthlyChart(
    MbxPerformanceStats performance,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChartTitle('Monthly Performance (Amount)', context),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < performance.monthly.length) {
                          final period = performance.monthly[index].period;
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              period.length > 3
                                  ? period.substring(0, 3)
                                  : period,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: isDark
                                    ? Colors.white70
                                    : Colors.grey[700],
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: null,
                      reservedSize: 40,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          _formatChartValue(value),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                minX: 0,
                maxX: (performance.monthly.length - 1).toDouble(),
                minY: 0,
                maxY: performance.monthly.isNotEmpty
                    ? performance.monthly
                              .map((e) => e.amount)
                              .reduce((a, b) => a > b ? a : b) *
                          1.2
                    : 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: performance.monthly.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.amount);
                    }).toList(),
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2196F3).withOpacity(0.3),
                          const Color(0xFF21CBF3).withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(
    MbxPerformanceStats performance,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChartTitle('Weekly Performance (Transactions)', context),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < performance.weekly.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              performance.weekly[index].period,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: isDark
                                    ? Colors.white70
                                    : Colors.grey[700],
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: null,
                      reservedSize: 40,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: isDark ? Colors.white70 : Colors.grey[700],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                minX: 0,
                maxX: (performance.weekly.length - 1).toDouble(),
                minY: 0,
                maxY: performance.weekly.isNotEmpty
                    ? performance.weekly
                              .map((e) => e.count.toDouble())
                              .reduce((a, b) => a > b ? a : b) *
                          1.2
                    : 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: performance.weekly.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value.count.toDouble(),
                      );
                    }).toList(),
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4CAF50).withOpacity(0.3),
                          const Color(0xFF8BC34A).withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearlyChart(
    MbxPerformanceStats performance,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Filter out years with zero data
    final validYearlyData = performance.yearly
        .where((data) => data.count > 0)
        .toList();

    if (validYearlyData.isEmpty) {
      return Container(
        height: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'No yearly data available',
            style: TextStyle(color: isDark ? Colors.white : Colors.grey[800]),
          ),
        ),
      );
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChartTitle('Yearly Performance (Amount)', context),
          const SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < validYearlyData.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              validYearlyData[index].period,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: isDark
                                    ? Colors.white70
                                    : Colors.grey[700],
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: null,
                      reservedSize: 40,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          _formatChartValue(value),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                minX: 0,
                maxX: (validYearlyData.length - 1).toDouble(),
                minY: 0,
                maxY: validYearlyData.isNotEmpty
                    ? validYearlyData
                              .map((e) => e.amount)
                              .reduce((a, b) => a > b ? a : b) *
                          1.2
                    : 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: validYearlyData.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.amount);
                    }).toList(),
                    isCurved: true,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF9C27B0).withOpacity(0.3),
                          const Color(0xFFE91E63).withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatChartValue(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }
}
