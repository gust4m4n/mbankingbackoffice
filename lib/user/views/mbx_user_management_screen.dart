import 'package:mbankingbackoffice/user/controllers/mbx_user_controller.dart';
import 'package:mbankingbackoffice/user/models/mbx_user_model.dart';
import 'package:mbankingbackoffice/user/views/mbx_adjustment_dialog.dart';
import 'package:mbankingbackoffice/user/views/mbx_balance_history_dialog.dart';
import 'package:mbankingbackoffice/user/views/mbx_topup_dialog.dart';
import 'package:mbankingbackoffice/user/views/mbx_user_detail_dialog.dart';
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
          customHeaderWidget: Obx(
            () => MbxManagementHeader(
              title: 'User Management',
              showSearch: true,
              searchController: controller.searchController,
              onSearch: controller.searchUsers,
              onClearSearch: controller.clearSearchAndFilters,
              searchHint: 'Search...',
              isFilterActive: controller.isFilterActive.value,
            ),
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
                Expanded(
                  child: Obx(
                    () => MbxUserTableWidget(
                      users: controller.users,
                      isLoading: controller.isLoading.value,
                      enableSorting: false,
                      actionBuilder: (user) =>
                          MbxUserTableActionBuilders.buildStandardActions(
                            user,
                            onTopup: () => _topupUser(user),
                            onAdjust: () => _adjustUser(user),
                            onHistory: () => _viewBalanceHistory(user),
                            onView: () => _viewUser(user),
                          ),
                      onRowTap: (user) =>
                          () => _viewUser(user),
                    ),
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
