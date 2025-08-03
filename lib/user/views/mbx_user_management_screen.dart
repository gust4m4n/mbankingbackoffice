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
          child: GetBuilder<MbxUserController>(
            builder: (controller) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // User Table using reusable component
                    Expanded(
                      child: MbxDataTableWidget(
                        isLoading: controller.isLoading.value,
                        columns: [
                          MbxDataColumn(
                            label: 'Name',
                            sortable: true,
                            sortKey: 'name',
                            customWidget: (data) => _buildNameCell(data),
                          ),
                          const MbxDataColumn(
                            label: 'Phone',
                            sortable: true,
                            sortKey: 'phone',
                          ),
                          MbxDataColumn(
                            label: 'Balance',
                            sortable: true,
                            sortKey: 'balance',
                            textAlign: TextAlign.right,
                            customWidget: (data) => _buildBalanceCell(data),
                          ),
                          MbxDataColumn(
                            label: 'Status',
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
                              'phone': user.phone,
                              'balance': user.balance,
                              'status': user.status,
                              'isActive': user.isActive,
                              'user': user,
                            },
                            actions: [
                              // Compact action buttons with smaller size
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: IconButton(
                                  onPressed: () => _topupUser(user),
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    size: 14,
                                    color: Color(0xFF1976D2),
                                  ),
                                  tooltip: 'Top Up',
                                  padding: EdgeInsets.zero,
                                  splashRadius: 14,
                                ),
                              ),

                              SizedBox(
                                width: 32,
                                height: 32,
                                child: IconButton(
                                  onPressed: () => _adjustUser(user),
                                  icon: const Icon(
                                    Icons.tune_rounded,
                                    size: 14,
                                    color: Color(0xFFFF9800),
                                  ),
                                  tooltip: 'Adjust',
                                  padding: EdgeInsets.zero,
                                  splashRadius: 14,
                                ),
                              ),

                              SizedBox(
                                width: 32,
                                height: 32,
                                child: IconButton(
                                  onPressed: () => _viewBalanceHistory(user),
                                  icon: const Icon(
                                    Icons.history_rounded,
                                    size: 14,
                                    color: Color(0xFF673AB7),
                                  ),
                                  tooltip: 'History',
                                  padding: EdgeInsets.zero,
                                  splashRadius: 14,
                                ),
                              ),

                              SizedBox(
                                width: 32,
                                height: 32,
                                child: IconButton(
                                  onPressed: () => _viewUser(user),
                                  icon: const Icon(
                                    Icons.visibility_outlined,
                                    size: 14,
                                  ),
                                  tooltip: 'View',
                                  padding: EdgeInsets.zero,
                                  splashRadius: 14,
                                ),
                              ),
                            ],
                            onTap: () => _viewUser(user),
                          );
                        }).toList(),
                        emptyIcon: Icons.people_outline,
                        emptyTitle: 'No users found',
                        emptySubtitle:
                            'Users will appear here once they register',
                        enableHighlight: true,
                        enableRowOnlyHighlight: true,
                      ),
                    ),

                    // Pagination
                    MbxPaginationWidget(
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
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
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
