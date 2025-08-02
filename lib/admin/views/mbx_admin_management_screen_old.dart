import 'package:mbankingbackoffice/admin/controllers/mbx_admin_controller.dart';
import 'package:mbankingbackoffice/admin/models/mbx_admin_model.dart';
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
          onRefreshPressed: controller.refreshAdmins,
          child: _buildAdminContent(controller),
        );
      },
    );
  }

  Widget _buildAdminContent(MbxAdminController controller) {
    print(
      '[DEBUG ADMIN] Building admin content, admins count: ${controller.admins.length}',
    );
    return Column(
      children: [
        // Admin Table
        Expanded(child: _buildAdminTable(controller)),
      ],
    );
  }

  Widget _buildAdminTable(MbxAdminController controller) {
    print(
      '[DEBUG ADMIN] Building admin table with ${controller.admins.length} admins',
    );
    print('[DEBUG ADMIN] IsLoading: ${controller.isLoading.value}');
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Admin Table using reusable component
          MbxDataTableWidget(
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
                onTap: () => controller.viewAdmin(admin),
              );
            }).toList(),
            emptyIcon: Icons.admin_panel_settings_outlined,
            emptyTitle: 'No administrators found',
            emptySubtitle: 'Create your first admin to get started',
            enableHighlight: true,
            minTableWidth: 740,
          ),

          // Pagination
          if (controller.totalPages.value > 1)
            MbxPaginationWidget(
              currentPage: controller.currentPage.value,
              totalPages: controller.totalPages.value,
              totalItems: controller.admins.length,
              itemsPerPage: 10,
              onPrevious: controller.currentPage.value > 1
                  ? controller.previousPage
                  : null,
              onNext: controller.currentPage.value < controller.totalPages.value
                  ? controller.nextPage
                  : null,
              onFirst: controller.currentPage.value > 1
                  ? () {
                      // Implement first page logic
                      // controller.firstPage();
                    }
                  : null,
              onLast: controller.currentPage.value < controller.totalPages.value
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
        ],
      ),
    );
  }

  Widget _buildNameCell(Map<String, dynamic> data) {
    final admin = data['admin'] as MbxAdminModel;
    return Row(
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
    );
  }

  Widget _buildRoleCell(Map<String, dynamic> data) {
    final isSuperAdmin = data['isSuperAdmin'] as bool;
    final role = data['role'] as String;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSuperAdmin
            ? Colors.purple.withOpacity(0.1)
            : Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: isSuperAdmin ? Colors.purple : Colors.blue,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildStatusCell(Map<String, dynamic> data) {
    final isActive = data['isActive'] as bool;
    final status = data['status'] as String;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
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
}
