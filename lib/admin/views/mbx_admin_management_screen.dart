import 'package:mbankingbackoffice/admin/controllers/mbx_admin_controller.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxAdminManagementScreen extends StatelessWidget {
  const MbxAdminManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('[DEBUG ADMIN] Building MbxAdminManagementScreen');
    return GetBuilder<MbxAdminController>(
      init: MbxAdminController(),
      builder: (controller) {
        print(
          '[DEBUG ADMIN] GetBuilder called with controller: ${controller.runtimeType}',
        );
        return MbxManagementScaffold(
          title: 'Admin Management',
          currentRoute: '/admin-management',
          showAddButton: true,
          onAddPressed: controller.showCreateAdminDialog,
          child: _buildAdminContent(controller, context),
        );
      },
    );
  }

  Widget _buildAdminContent(
    MbxAdminController controller,
    BuildContext context,
  ) {
    return Column(
      children: [
        // Admin Table Container
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Admin Table using reusable component
                Expanded(
                  child: Obx(
                    () => MbxDataTableWidget(
                      isLoading: controller.isLoading.value,
                      columns: [
                        MbxDataColumn(
                          label: 'Name',
                          width: 180,
                          sortable: true,
                          sortKey: 'name',
                          customWidget: (data) => _buildNameCell(data),
                        ),
                        const MbxDataColumn(
                          label: 'Email',
                          width: 200,
                          sortable: true,
                          sortKey: 'email',
                        ),
                        MbxDataColumn(
                          label: 'Role',
                          width: 120,
                          sortable: true,
                          sortKey: 'role',
                          customWidget: (data) => _buildRoleCell(data),
                        ),
                        MbxDataColumn(
                          label: 'Status',
                          width: 100,
                          sortable: true,
                          sortKey: 'status',
                          customWidget: (data) => _buildStatusCell(data),
                        ),
                      ],
                      rows: controller.admins.map((admin) {
                        return MbxDataRow(
                          id: admin.id.toString(),
                          data: {
                            'name': admin.name,
                            'email': admin.email,
                            'role': admin.displayRole,
                            'status': admin.displayStatus,
                            'isSuperAdmin': admin.isSuperAdmin,
                            'isActive': admin.isActive,
                            'admin': admin,
                          },
                          actions: [
                            IconButton(
                              onPressed: () => controller.viewAdmin(admin),
                              icon: const Icon(
                                Icons.visibility_outlined,
                                size: 18,
                              ),
                              tooltip: 'View',
                              splashRadius: 20,
                            ),
                            IconButton(
                              onPressed: () =>
                                  controller.showEditAdminDialog(admin),
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
                          onTap: () => controller.viewAdmin(admin),
                        );
                      }).toList(),
                      emptyIcon: Icons.admin_panel_settings_outlined,
                      emptyTitle: 'No administrators found',
                      emptySubtitle: 'Create your first admin to get started',
                      enableHighlight: false,
                      minTableWidth: 740,
                    ),
                  ),
                ),

                // Pagination
                Obx(
                  () => MbxPaginationWidget(
                    currentPage: controller.currentPage.value,
                    totalPages: controller.totalPages.value,
                    totalItems: controller.admins.length,
                    itemsPerPage: controller.perPage.value,
                    onPrevious: controller.currentPage.value > 1
                        ? controller.previousPage
                        : null,
                    onNext:
                        controller.currentPage.value <
                            controller.totalPages.value
                        ? controller.nextPage
                        : null,
                    onFirst: controller.currentPage.value > 1
                        ? () {
                            // Implement first page logic
                            // controller.firstPage();
                          }
                        : null,
                    onLast:
                        controller.currentPage.value <
                            controller.totalPages.value
                        ? () {
                            // Implement last page logic
                            // controller.lastPage();
                          }
                        : null,
                    onPageChanged: (page) {
                      // Implement page jump logic
                      // controller.goToPage(page);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameCell(Map<String, dynamic> data) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFF1976D2),
          child: Text(
            data['name']?.toString().isNotEmpty == true
                ? data['name'].toString()[0].toUpperCase()
                : 'A',
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
            data['name']?.toString() ?? '',
            style: const TextStyle(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCell(Map<String, dynamic> data) {
    final role = data['role']?.toString() ?? '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getRoleColor(role).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: _getRoleColor(role),
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildStatusCell(Map<String, dynamic> data) {
    final isActive = data['isActive'] as bool? ?? false;
    final status = data['status']?.toString() ?? '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'super_admin':
      case 'super admin':
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
