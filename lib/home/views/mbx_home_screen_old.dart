import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

import 'mbx_home_controller.dart';

class MbxHomeScreen extends StatelessWidget {
  const MbxHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MbxHomeController>(
      init: MbxHomeController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: Row(
            children: [
              // Sidebar
              Container(
                width: 280,
                color: const Color(0xFF1A1D29),
                child: Column(
                  children: [
                    // Logo/Header
                    Container(
                      height: 80,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(color: Color(0xFF1976D2)),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.admin_panel_settings,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'MBanking\nBackOffice',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // User Profile Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFF1976D2),
                            child: Text(
                              controller.adminName.isNotEmpty
                                  ? controller.adminName[0].toUpperCase()
                                  : 'A',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.adminName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const Text(
                                  'Super Administrator',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Navigation Menu
                    Expanded(
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        children: [
                          _buildMenuItem(
                            icon: Icons.dashboard_outlined,
                            title: 'Dashboard',
                            isActive: true,
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.admin_panel_settings_outlined,
                            title: 'Admin Management',
                            onTap: () => Get.toNamed('/admin-management'),
                          ),
                          _buildMenuItem(
                            icon: Icons.people_outline,
                            title: 'User Management',
                            onTap: () => Get.toNamed('/user-management'),
                          ),
                          _buildMenuItem(
                            icon: Icons.bug_report_outlined,
                            title: 'Test Admin API',
                            onTap: () => Get.toNamed('/test-admin'),
                          ),
                          _buildMenuItem(
                            icon: Icons.receipt_long_outlined,
                            title: 'Transactions',
                            onTap: () => Get.toNamed('/transaction-management'),
                          ),
                          _buildMenuItem(
                            icon: Icons.analytics_outlined,
                            title: 'Reports',
                            onTap: () =>
                                controller.showFeatureNotAvailable('Reports'),
                          ),
                          _buildMenuItem(
                            icon: Icons.account_balance_outlined,
                            title: 'Accounts',
                            onTap: () =>
                                controller.showFeatureNotAvailable('Accounts'),
                          ),
                          _buildMenuItem(
                            icon: Icons.settings_outlined,
                            title: 'Settings',
                            onTap: () =>
                                controller.showFeatureNotAvailable('Settings'),
                          ),
                          _buildMenuItem(
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            onTap: () => controller.showFeatureNotAvailable(
                              'Notifications',
                            ),
                          ),
                          _buildMenuItem(
                            icon: Icons.list_alt_outlined,
                            title: 'System Logs',
                            onTap: () => controller.showFeatureNotAvailable(
                              'System Logs',
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(color: Colors.white24),
                          _buildMenuItem(
                            icon: Icons.logout_outlined,
                            title: 'Logout',
                            onTap: () => controller.logout(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content Area
              Expanded(
                child: Column(
                  children: [
                    // Top Bar
                    Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          bool isSmallScreen = constraints.maxWidth < 700;
                          bool isVerySmallScreen = constraints.maxWidth < 500;

                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Dashboard',
                                  style: TextStyle(
                                    fontSize: isVerySmallScreen ? 18 : 24,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1A1D29),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!isSmallScreen) ...[
                                // Search Bar for larger screens
                                Container(
                                  width: constraints.maxWidth < 900 ? 200 : 300,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Search...',
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: Colors.grey,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                              ] else if (!isVerySmallScreen) ...[
                                // Search icon only for medium screens
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.search),
                                  tooltip: 'Search',
                                ),
                                const SizedBox(width: 8),
                              ],
                              // Notification Icon
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    // Main Dashboard Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Stats Cards Row
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    'Total Users',
                                    '1,245',
                                    Icons.people,
                                    const Color(0xFF4CAF50),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStatCard(
                                    'Transactions',
                                    '8,532',
                                    Icons.receipt,
                                    const Color(0xFF2196F3),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStatCard(
                                    'Revenue',
                                    'Rp 125M',
                                    Icons.monetization_on,
                                    const Color(0xFFFF9800),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStatCard(
                                    'Active Sessions',
                                    '342',
                                    Icons.online_prediction,
                                    const Color(0xFF9C27B0),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Welcome Card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1976D2),
                                    Color(0xFF1565C0),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF1976D2,
                                    ).withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Welcome back!',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Selamat datang di dashboard admin, ${controller.adminName}',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () => controller
                                              .showFeatureNotAvailable(
                                                'Quick Actions',
                                              ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: const Color(
                                              0xFF1976D2,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            'View Reports',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.dashboard,
                                    size: 80,
                                    color: Colors.white24,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Recent Activity Section
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _buildRecentActivityCard(),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildQuickActionsCard(controller),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? const Color(0xFF1976D2) : Colors.white70,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF1976D2) : Colors.white70,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: isActive ? Colors.white.withOpacity(0.1) : null,
        onTap: onTap,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.trending_up, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1D29),
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard() {
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
          const Row(
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1D29),
                ),
              ),
              Spacer(),
              Icon(Icons.more_horiz, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(
            4,
            (index) => _buildActivityItem(
              'User ${index + 1}',
              'Completed transaction #${1000 + index}',
              '${index + 1}m ago',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String user, String action, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF1976D2).withOpacity(0.1),
            child: Text(
              user[0],
              style: const TextStyle(
                color: Color(0xFF1976D2),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  action,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          Text(time, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(MbxHomeController controller) {
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
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1D29),
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickActionButton(
            'Add User',
            Icons.person_add,
            const Color(0xFF4CAF50),
            () => controller.showFeatureNotAvailable('Add User'),
          ),
          const SizedBox(height: 12),
          _buildQuickActionButton(
            'Generate Report',
            Icons.description,
            const Color(0xFF2196F3),
            () => controller.showFeatureNotAvailable('Generate Report'),
          ),
          const SizedBox(height: 12),
          _buildQuickActionButton(
            'System Settings',
            Icons.settings,
            const Color(0xFFFF9800),
            () => controller.showFeatureNotAvailable('System Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
