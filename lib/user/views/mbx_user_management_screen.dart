import 'package:mbankingbackoffice/preferences/mbx_preferences_vm_users.dart';
import 'package:mbankingbackoffice/user/controllers/mbx_user_controller.dart';
import 'package:mbankingbackoffice/user/models/mbx_user_model.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxUserManagementScreen extends StatelessWidget {
  const MbxUserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MbxUserController>(
      init: MbxUserController(),
      builder: (controller) {
        return Obx(() {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: Row(
              children: [
                // Sidebar (reuse from admin screen)
                Container(
                  width: 280,
                  color: const Color(0xFF1A1D29),
                  child: Column(
                    children: [
                      // Logo/Header
                      Container(
                        height: 80,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1976D2),
                        ),
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

                      // Navigation Menu
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          children: [
                            _buildMenuItem(
                              icon: Icons.dashboard_outlined,
                              title: 'Dashboard',
                              onTap: () => Get.offNamed('/home'),
                            ),
                            _buildMenuItem(
                              icon: Icons.admin_panel_settings_outlined,
                              title: 'Admin Management',
                              onTap: () => Get.offNamed('/admin-management'),
                            ),
                            _buildMenuItem(
                              icon: Icons.people_outline,
                              title: 'User Management',
                              isActive: true,
                              onTap: () {},
                            ),
                            _buildMenuItem(
                              icon: Icons.receipt_long_outlined,
                              title: 'Transactions',
                              onTap: () =>
                                  Get.offNamed('/transaction-management'),
                            ),
                            _buildMenuItem(
                              icon: Icons.analytics_outlined,
                              title: 'Reports',
                              onTap: () => showFeatureNotAvailable('Reports'),
                            ),
                            _buildMenuItem(
                              icon: Icons.settings_outlined,
                              title: 'Settings',
                              onTap: () => showFeatureNotAvailable('Settings'),
                            ),
                            const SizedBox(height: 20),
                            const Divider(color: Colors.white24),
                            _buildMenuItem(
                              icon: Icons.logout_outlined,
                              title: 'Logout',
                              onTap: () => logout(),
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
                            bool isSmallScreen = constraints.maxWidth < 600;

                            return Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'User Management',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 18 : 24,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1A1D29),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (!isSmallScreen) ...[
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        showFeatureNotAvailable('Add User'),
                                    icon: const Icon(Icons.add, size: 20),
                                    label: const Text('Add User'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1976D2),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ] else ...[
                                  IconButton(
                                    onPressed: () =>
                                        showFeatureNotAvailable('Add User'),
                                    icon: const Icon(Icons.add),
                                    tooltip: 'Add User',
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                IconButton(
                                  onPressed: controller.refreshUsers,
                                  icon: const Icon(Icons.refresh),
                                  tooltip: 'Refresh',
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      // User List Content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
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
                              children: [
                                // Table Header
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      bool isSmallScreen =
                                          constraints.maxWidth < 400;

                                      if (isSmallScreen) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Users',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Total: ${controller.totalUsers.value} users',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Row(
                                          children: [
                                            const Expanded(
                                              child: Text(
                                                'Users',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              'Total: ${controller.totalUsers.value} users',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),

                                // Loading State
                                if (controller.isLoading.value)
                                  const Expanded(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                else if (controller.users.isEmpty)
                                  // Empty State
                                  const Expanded(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.people_outline,
                                            size: 64,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'No users found',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Users will appear here once they register',
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  // User Table
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        // Calculate minimum width needed for DataTable
                                        double minTableWidth =
                                            800; // Sum of all column widths + spacing
                                        bool needsScroll =
                                            minTableWidth >
                                            constraints.maxWidth;

                                        Widget dataTable = DataTable(
                                          columnSpacing: 16,
                                          dataRowMinHeight: 56,
                                          dataRowMaxHeight: 72,
                                          headingRowColor:
                                              WidgetStateProperty.all(
                                                Colors.grey[100],
                                              ),
                                          columns: const [
                                            DataColumn(
                                              label: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Name',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Account Number',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Phone',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Balance',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Status',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Actions',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                          rows: controller.users
                                              .map(
                                                (user) => _buildUserRow(
                                                  user,
                                                  controller,
                                                ),
                                              )
                                              .toList(),
                                        );

                                        if (needsScroll) {
                                          // Use horizontal scroll when space is limited
                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            child: SingleChildScrollView(
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              child: dataTable,
                                            ),
                                          );
                                        } else {
                                          // Left-align when there's enough space
                                          return SingleChildScrollView(
                                            physics:
                                                const ClampingScrollPhysics(),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: dataTable,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),

                                // Pagination
                                if (controller.totalPages.value > 1)
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Page ${controller.currentPage.value} of ${controller.totalPages.value}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed:
                                              controller.currentPage.value > 1
                                              ? controller.previousPage
                                              : null,
                                          icon: const Icon(Icons.chevron_left),
                                        ),
                                        IconButton(
                                          onPressed:
                                              controller.currentPage.value <
                                                  controller.totalPages.value
                                              ? controller.nextPage
                                              : null,
                                          icon: const Icon(Icons.chevron_right),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
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

  DataRow _buildUserRow(MbxUserModel user, MbxUserController controller) {
    return DataRow(
      cells: [
        DataCell(
          SizedBox(
            width: 180,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF1976D2),
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 160,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                user.maskedAccountNumber,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(user.phone, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                user.formattedBalance,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1976D2),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 100,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: user.isActive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user.displayStatus,
                  style: TextStyle(
                    color: user.isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 120,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => controller.viewUser(user),
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    tooltip: 'View',
                    splashRadius: 20,
                  ),
                  IconButton(
                    onPressed: () => controller.deleteUser(user),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    color: Colors.red,
                    tooltip: 'Delete',
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showFeatureNotAvailable(String featureName) {
    ToastX.showSuccess(msg: '$featureName akan segera tersedia');
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              Get.loading();

              // Clear stored token
              await MbxUserPreferencesVM.setToken('');

              // Navigate to login
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.back();
                Get.offAllNamed('/login');
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
