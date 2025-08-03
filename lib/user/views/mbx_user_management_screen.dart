import 'package:mbankingbackoffice/user/controllers/mbx_user_controller.dart';
import 'package:mbankingbackoffice/user/models/mbx_user_model.dart';
import 'package:mbankingbackoffice/user/views/mbx_adjustment_dialog.dart';
import 'package:mbankingbackoffice/user/views/mbx_balance_history_dialog.dart';
import 'package:mbankingbackoffice/user/views/mbx_topup_dialog.dart';
import 'package:mbankingbackoffice/user/views/mbx_user_detail_dialog.dart';
import 'package:mbankingbackoffice/user/views/widgets/mbx_user_header_search_widget.dart';
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
          showAddButton: false,
          customHeaderWidget: MbxUserHeaderSearchWidget(
            controller: controller,
            title: 'User Management',
          ),
          child: _buildUserContent(controller, context),
        );
      },
    );
  }

  Widget _buildUserContent(MbxUserController controller, BuildContext context) {
    return Column(
      children: [
        // User Table Container
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // User Table using reusable component
                Obx(
                  () => MbxDataTableWidget(
                    isLoading: controller.isLoading.value,
                    columns: [
                      MbxDataColumn(
                        key: 'name',
                        label: 'Name',
                        sortable: true,
                        sortKey: 'name',
                        customWidget: (data) => _buildNameCell(data),
                      ),
                      const MbxDataColumn(
                        key: 'phone',
                        label: 'Phone',
                        sortable: true,
                        sortKey: 'phone',
                      ),
                      MbxDataColumn(
                        key: 'balance',
                        label: 'Balance',
                        sortable: true,
                        sortKey: 'balance',
                        textAlign: TextAlign.right,
                        customWidget: (data) => _buildBalanceCell(data),
                      ),
                      MbxDataColumn(
                        key: 'status',
                        label: 'Status',
                        sortable: true,
                        sortKey: 'status',
                        customWidget: (data) => _buildStatusCell(data),
                      ),
                    ],
                    rows: controller.users.map((user) {
                      return MbxDataRow(
                        key: user.id.toString(),
                        id: user.id.toString(),
                        cells: {
                          'name': MbxDataCell(value: user.name),
                          'phone': MbxDataCell(value: user.phone),
                          'balance': MbxDataCell(value: user.balance),
                          'status': MbxDataCell(value: user.status),
                        },
                        data: {
                          'name': user.name,
                          'phone': user.phone,
                          'balance': user.balance,
                          'status': user.status,
                          'isActive': user.isActive,
                          'user': user,
                        },
                        actions: [
                          // Ultra compact action buttons
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: IconButton(
                              onPressed: () => _topupUser(user),
                              icon: const Icon(
                                Icons.add_circle_outline,
                                size: 11,
                                color: Color(0xFF1976D2),
                              ),
                              tooltip: 'Top Up',
                              padding: EdgeInsets.zero,
                              splashRadius: 10,
                            ),
                          ),

                          SizedBox(
                            width: 24,
                            height: 24,
                            child: IconButton(
                              onPressed: () => _adjustUser(user),
                              icon: const Icon(
                                Icons.tune_rounded,
                                size: 11,
                                color: Color(0xFFFF9800),
                              ),
                              tooltip: 'Adjust',
                              padding: EdgeInsets.zero,
                              splashRadius: 10,
                            ),
                          ),

                          SizedBox(
                            width: 24,
                            height: 24,
                            child: IconButton(
                              onPressed: () => _viewBalanceHistory(user),
                              icon: const Icon(
                                Icons.history_rounded,
                                size: 11,
                                color: Color(0xFF673AB7),
                              ),
                              tooltip: 'History',
                              padding: EdgeInsets.zero,
                              splashRadius: 10,
                            ),
                          ),

                          SizedBox(
                            width: 24,
                            height: 24,
                            child: IconButton(
                              onPressed: () => _viewUser(user),
                              icon: const Icon(
                                Icons.visibility_outlined,
                                size: 11,
                              ),
                              tooltip: 'View',
                              padding: EdgeInsets.zero,
                              splashRadius: 10,
                            ),
                          ),
                        ],
                        onTap: () => _viewUser(user),
                      );
                    }).toList(),
                    emptyIcon: Icons.people_outline,
                    emptyTitle: 'No users found',
                    emptySubtitle: 'Users will appear here once they register',
                    enableHighlight: true,
                    enableRowOnlyHighlight: true,
                  ),
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
          ),
        ),
      ],
    );
  }

  Widget _buildNameCell(Map<String, dynamic> data) {
    final user = data['user'] as MbxUserModel;
    return Container(
      height: 35, // Increased from 32 to 35 (matching DataTable height)
      alignment: Alignment.centerLeft,
      child: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildBalanceCell(Map<String, dynamic> data) {
    final user = data['user'] as MbxUserModel;
    return Container(
      height: 35, // Increased from 32 to 35 (matching DataTable height)
      alignment: Alignment.centerRight,
      child: Text(
        user.formattedBalance,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xFF1976D2),
          fontSize: 13,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStatusCell(Map<String, dynamic> data) {
    final isActive = data['isActive'] as bool;
    final user = data['user'] as MbxUserModel;

    return Container(
      height: 32, // Fixed compact height
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          user.displayStatus,
          style: TextStyle(
            color: isActive ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  void _viewUser(MbxUserModel user) {
    MbxUserDetailDialog.show(Get.context!, user);
  }

  Future<void> _topupUser(MbxUserModel user) async {
    final result = await MbxTopupDialog.show(Get.context!, user);
    if (result == true) {
      // Refresh user list to show updated balance
      final controller = Get.find<MbxUserController>();
      controller.refreshUsers();
    }
  }

  Future<void> _adjustUser(MbxUserModel user) async {
    final result = await MbxAdjustmentDialog.show(Get.context!, user);
    if (result == true) {
      // Refresh user list to show updated balance
      final controller = Get.find<MbxUserController>();
      controller.refreshUsers();
    }
  }

  void _viewBalanceHistory(MbxUserModel user) {
    MbxBalanceHistoryDialog.show(Get.context!, user);
  }
}
