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
          customHeaderWidget: const MbxManagementHeader(
            title: 'Admin Management',
            showSearch: false,
          ),
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
                    () => MbxAdminTableWidget(
                      admins: controller.admins,
                      isLoading: controller.isLoading.value,
                      actionBuilder: (admin) =>
                          MbxAdminTableActionBuilders.buildStandardActions(
                            admin,
                            onView: () => controller.viewAdmin(admin),
                            onEdit: () => controller.showEditAdminDialog(admin),
                            onDelete: () => controller.deleteAdmin(admin),
                          ),
                      onRowTap: (admin) =>
                          () => controller.viewAdmin(admin),
                    ),
                  ),
                ),

                // Pagination
                Obx(
                  () => controller.totalPages.value > 1
                      ? MbxPaginationWidget(
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
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
