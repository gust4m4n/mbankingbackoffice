import 'package:mbankingbackoffice/admin/controllers/mbx_simple_admin_controller.dart';
import 'package:mbankingbackoffice/admin/models/mbx_admin_model.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxAdminManagementScreen extends StatelessWidget {
  const MbxAdminManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.put(MbxAdminController());
      return MbxManagementScaffold(
        title: 'Admin Management',
        currentRoute: '/admin-management',
        showAddButton: true,
        onAddPressed: controller.showCreateAdminDialog,
        onRefreshPressed: controller.refreshAdmins,
        child: _buildAdminContent(controller),
      );
    });
  }

  Widget _buildAdminContent(MbxAdminController controller) {
    final isDarkMode = Theme.of(Get.context!).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Loading State
          if (controller.isLoading.value)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (controller.admins.isEmpty)
            // Empty State
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.admin_panel_settings_outlined,
                      size: 64,
                      color: isDarkMode ? const Color(0xFF808080) : Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No administrators found',
                      style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode
                            ? const Color(0xFF808080)
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Administrators will appear here once added',
                      style: TextStyle(
                        color: isDarkMode
                            ? const Color(0xFF808080)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            // Admin Table
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: DataTable(
                    columnSpacing: 16,
                    dataRowMinHeight: 56,
                    dataRowMaxHeight: 72,
                    headingRowColor: WidgetStateProperty.all(
                      isDarkMode ? const Color(0xff2a2a2a) : Colors.grey[100],
                    ),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Role',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Status',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Actions',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    rows: controller.admins
                        .map((admin) => _buildAdminRow(admin, controller))
                        .toList(),
                  ),
                ),
              ),
            ), // Pagination
          Obx(
            () => MbxPaginationWidget(
              currentPage: controller.currentPage.value,
              totalPages: controller.totalPages.value,
              totalItems: controller.totalAdmins.value,
              itemsPerPage: controller.perPage,
              onPrevious: controller.previousPage,
              onNext: controller.nextPage,
              onFirst: controller.firstPage,
              onLast: controller.lastPage,
              onPageChanged: controller.goToPage,
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildAdminRow(MbxAdminModel admin, MbxAdminController controller) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
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
              Expanded(
                child: Text(
                  admin.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(admin.email, overflow: TextOverflow.ellipsis)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getRoleColor(admin.role).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              admin.displayRole,
              style: TextStyle(
                color: _getRoleColor(admin.role),
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
              borderRadius: BorderRadius.circular(8),
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

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'super_admin':
        return Colors.purple;
      case 'admin':
        return Colors.blue;
      case 'moderator':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
