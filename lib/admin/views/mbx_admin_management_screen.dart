import 'package:mbankingbackoffice/admin/controllers/mbx_simple_admin_controller.dart';
import 'package:mbankingbackoffice/admin/models/mbx_admin_model.dart';
import 'package:mbankingbackoffice/preferences/mbx_preferences_vm_users.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxAdminManagementScreen extends StatelessWidget {
  const MbxAdminManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.put(MbxAdminController());
      return Scaffold(
          backgroundColor: Colors.grey[50],
          body: Row(
            children: [
              // Sidebar (reuse from home screen)
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
                            isActive: true,
                            onTap: () {},
                          ),
                          _buildMenuItem(
                            icon: Icons.people_outline,
                            title: 'User Management',
                            onTap: () =>
                                _showFeatureNotAvailable('User Management'),
                          ),
                          _buildMenuItem(
                            icon: Icons.receipt_long_outlined,
                            title: 'Transactions',
                            onTap: () =>
                                _showFeatureNotAvailable('Transactions'),
                          ),
                          _buildMenuItem(
                            icon: Icons.analytics_outlined,
                            title: 'Reports',
                            onTap: () => _showFeatureNotAvailable('Reports'),
                          ),
                          _buildMenuItem(
                            icon: Icons.settings_outlined,
                            title: 'Settings',
                            onTap: () => _showFeatureNotAvailable('Settings'),
                          ),
                          const SizedBox(height: 20),
                          const Divider(color: Colors.white24),
                          _buildMenuItem(
                            icon: Icons.logout_outlined,
                            title: 'Logout',
                            onTap: () => _logout(),
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
                      child: Row(
                        children: [
                          const Text(
                            'Admin Management',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1D29),
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: controller.showCreateAdminDialog,
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Add Admin'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1976D2),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: controller.refreshAdmins,
                            icon: const Icon(Icons.refresh),
                            tooltip: 'Refresh',
                          ),
                        ],
                      ),
                    ),

                    // Admin List Content
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
                                child: Row(
                                  children: [
                                    const Text(
                                      'Administrators',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Total: ${controller.totalAdmins.value} admins',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Loading State
                              if (controller.isLoading.value)
                                const Expanded(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else if (controller.admins.isEmpty)
                                // Empty State
                                const Expanded(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.admin_panel_settings_outlined,
                                          size: 64,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'No administrators found',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Create your first admin to get started',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              else
                                // Admin Table
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: DataTable(
                                      columnSpacing: 24,
                                      headingRowColor: WidgetStateProperty.all(
                                        Colors.grey[100],
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Text(
                                            'Name',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Email',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Role',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Status',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Actions',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: controller.admins
                                          .map(
                                            (admin) => _buildAdminRow(
                                              admin,
                                              controller,
                                            ),
                                          )
                                          .toList(),
                                    ),
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
                                        onPressed: controller.currentPage.value > 1
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

  DataRow _buildAdminRow(MbxAdminModel admin, MbxAdminController controller) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF1976D2),
                child: Text(
                  admin.name.isNotEmpty ? admin.name[0].toUpperCase() : 'A',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                admin.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        DataCell(Text(admin.email)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: admin.isSuperAdmin
                  ? Colors.purple.withOpacity(0.1)
                  : Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              admin.displayRole,
              style: TextStyle(
                color: admin.isSuperAdmin ? Colors.purple : Colors.blue,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: admin.isActive
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              admin.displayStatus,
              style: TextStyle(
                color: admin.isActive ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => controller.viewAdmin(admin),
                icon: const Icon(Icons.visibility_outlined, size: 18),
                tooltip: 'View',
                splashRadius: 20,
              ),
              IconButton(
                onPressed: () => controller.showEditAdminDialog(admin),
                icon: const Icon(Icons.edit_outlined, size: 18),
                tooltip: 'Edit',
                splashRadius: 20,
              ),
              IconButton(
                onPressed: () => controller.deleteAdmin(admin),
                icon: const Icon(Icons.delete_outline, size: 18),
                color: Colors.red,
                tooltip: 'Delete',
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFeatureNotAvailable(String featureName) {
    ToastX.showSuccess(msg: '$featureName akan segera tersedia');
  }

  void _logout() {
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
      );
    });
  }
}
