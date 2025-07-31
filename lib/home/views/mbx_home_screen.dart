import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

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
          onRefreshPressed: () => controller.loadAdminInfo(),
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
              isMobile
                  ? Column(
                      children: [
                        _buildStatCard(
                          'Total Users',
                          '1,234',
                          Icons.people,
                          Colors.blue,
                        ),
                        const SizedBox(height: 16),
                        _buildStatCard(
                          'Total Transactions',
                          '5,678',
                          Icons.receipt_long,
                          Colors.green,
                        ),
                        const SizedBox(height: 16),
                        _buildStatCard(
                          'Total Amount',
                          'Rp 12.5M',
                          Icons.account_balance_wallet,
                          Colors.orange,
                        ),
                        const SizedBox(height: 16),
                        _buildStatCard(
                          'Active Admins',
                          '12',
                          Icons.admin_panel_settings,
                          Colors.purple,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Users',
                            '1,234',
                            Icons.people,
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Total Transactions',
                            '5,678',
                            Icons.receipt_long,
                            Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Total Amount',
                            'Rp 12.5M',
                            Icons.account_balance_wallet,
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            'Active Admins',
                            '12',
                            Icons.admin_panel_settings,
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),

              const SizedBox(height: 32),

              // Quick Actions
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),

              isMobile
                  ? Column(
                      children: [
                        _buildQuickActionCard(
                          'Manage Users',
                          'View and manage user accounts',
                          Icons.people,
                          () => Get.toNamed('/user-management'),
                        ),
                        const SizedBox(height: 16),
                        _buildQuickActionCard(
                          'View Transactions',
                          'Monitor all transactions',
                          Icons.receipt_long,
                          () => Get.toNamed('/transaction-management'),
                        ),
                        const SizedBox(height: 16),
                        _buildQuickActionCard(
                          'Admin Settings',
                          'Configure administrators',
                          Icons.admin_panel_settings,
                          () => Get.toNamed('/admin-management'),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionCard(
                            'Manage Users',
                            'View and manage user accounts',
                            Icons.people,
                            () => Get.toNamed('/user-management'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildQuickActionCard(
                            'View Transactions',
                            'Monitor all transactions',
                            Icons.receipt_long,
                            () => Get.toNamed('/transaction-management'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildQuickActionCard(
                            'Admin Settings',
                            'Configure administrators',
                            Icons.admin_panel_settings,
                            () => Get.toNamed('/admin-management'),
                          ),
                        ),
                      ],
                    ),

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

  Widget _buildQuickActionCard(
    String title,
    String description,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF1976D2)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
