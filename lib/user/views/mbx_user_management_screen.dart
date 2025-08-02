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
        return MbxManagementScaffold(
          title: 'User Management',
          currentRoute: '/user-management',
          showAddButton: true,
          onAddPressed: () => _showFeatureNotAvailable('Add User'),
          onRefreshPressed: controller.refreshUsers,
          child: _buildUserContent(controller),
        );
      },
    );
  }

  Widget _buildUserContent(MbxUserController controller) {
    return Obx(() {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // User Table using reusable component
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
                  label: 'Account',
                  width: 150,
                  sortable: true,
                  sortKey: 'accountNumber',
                ),
                const MbxDataColumn(
                  label: 'Phone',
                  width: 140,
                  sortable: true,
                  sortKey: 'phone',
                ),
                MbxDataColumn(
                  label: 'Balance',
                  width: 120,
                  sortable: true,
                  sortKey: 'balance',
                  textAlign: TextAlign.right,
                  customWidget: (data) => _buildBalanceCell(data),
                ),
                MbxDataColumn(
                  label: 'Status',
                  width: 100,
                  sortable: true,
                  sortKey: 'status',
                  customWidget: (data) => _buildStatusCell(data),
                ),
              ],
              rows: controller.users.map((user) {
                return MbxDataRow(
                  id: user.id.toString(),
                  data: {
                    'name': user.name,
                    'accountNumber': user.accountNumber,
                    'phone': user.phone,
                    'balance': user.balance,
                    'status': user.status,
                    'isActive': user.isActive,
                    'user': user,
                  },
                  actions: [
                    IconButton(
                      onPressed: () => _viewUser(user),
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      tooltip: 'View',
                      splashRadius: 20,
                    ),
                    IconButton(
                      onPressed: () => _editUser(user),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      tooltip: 'Edit',
                      splashRadius: 20,
                    ),
                    IconButton(
                      onPressed: () => _deactivateUser(user),
                      icon: Icon(
                        user.isActive
                            ? Icons.block
                            : Icons.check_circle_outline,
                        size: 18,
                      ),
                      color: user.isActive ? Colors.red : Colors.green,
                      tooltip: user.isActive ? 'Deactivate' : 'Activate',
                      splashRadius: 20,
                    ),
                  ],
                  onTap: () => _viewUser(user),
                );
              }).toList(),
              emptyIcon: Icons.people_outline,
              emptyTitle: 'No users found',
              emptySubtitle: 'Users will appear here once they register',
              enableHighlight: true,
              minTableWidth: 770,
            ),

            // Pagination
            Obx(
              () => MbxPaginationWidget(
                currentPage: controller.currentPage.value,
                totalPages: controller.totalPages.value,
                totalItems: controller.totalUsers.value,
                itemsPerPage: controller.perPage.value,
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
    });
  }

  Widget _buildNameCell(Map<String, dynamic> data) {
    final user = data['user'] as MbxUserModel;
    return Row(
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
    );
  }

  Widget _buildBalanceCell(Map<String, dynamic> data) {
    final user = data['user'] as MbxUserModel;
    return Text(
      user.formattedBalance,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF1976D2),
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStatusCell(Map<String, dynamic> data) {
    final isActive = data['isActive'] as bool;
    final user = data['user'] as MbxUserModel;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        user.displayStatus,
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  void _viewUser(MbxUserModel user) {
    _showFeatureNotAvailable('View User Details');
  }

  void _editUser(MbxUserModel user) {
    _showFeatureNotAvailable('Edit User');
  }

  void _deactivateUser(MbxUserModel user) {
    _showFeatureNotAvailable(
      '${user.isActive ? 'Deactivate' : 'Activate'} User',
    );
  }

  void _showFeatureNotAvailable(String featureName) {
    MbxDialogController.showFeatureNotAvailable(featureName);
  }
}
