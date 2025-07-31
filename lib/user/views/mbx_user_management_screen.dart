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
                  bool isSmallScreen = constraints.maxWidth < 400;

                  if (isSmallScreen) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          'Total: \${controller.totalUsers.value} users',
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
                          'Total: \${controller.totalUsers.value} users',
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
                    double minTableWidth = 800;
                    bool needsScroll = minTableWidth > constraints.maxWidth;

                    Widget dataTable = DataTable(
                      columnSpacing: 16,
                      dataRowMinHeight: 56,
                      dataRowMaxHeight: 72,
                      headingRowColor: WidgetStateProperty.all(
                        Colors.grey[100],
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
                            'Account',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Phone',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Balance',
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
                      rows: controller.users
                          .map((user) => _buildUserRow(user, controller))
                          .toList(),
                    );

                    if (needsScroll) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: dataTable,
                        ),
                      );
                    } else {
                      return SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
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
                      'Page \${controller.currentPage.value} of \${controller.totalPages.value}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: controller.currentPage.value > 1
                          ? controller.previousPage
                          : null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    IconButton(
                      onPressed: controller.currentPage.value <
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
      );
    });
  }

  DataRow _buildUserRow(MbxUserModel user, MbxUserController controller) {
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
        DataCell(
          Text(
            user.maskedAccountNumber,
            style: const TextStyle(fontFamily: 'monospace'),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(user.phone, overflow: TextOverflow.ellipsis),
        ),
        DataCell(
          Text(
            user.formattedBalance,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF1976D2),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Container(
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
        DataCell(
          Row(
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
      ],
    );
  }

  void _showFeatureNotAvailable(String featureName) {
    ToastX.showSuccess(msg: '\$featureName akan segera tersedia');
  }
}
