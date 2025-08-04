import 'package:mbankingbackoffice/transaction/controllers/mbx_transaction_controller.dart';
import 'package:mbankingbackoffice/transaction/models/mbx_transaction_model.dart';
import 'package:mbankingbackoffice/transaction/views/mbx_transaction_detail_dialog.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxTransactionManagementScreen extends StatelessWidget {
  const MbxTransactionManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MbxTransactionController>(
      init: MbxTransactionController(),
      builder: (controller) {
        return MbxManagementScaffold(
          title: 'Transaction Management',
          currentRoute: '/transaction-management',
          showAddButton: false,
          customHeaderWidget: const MbxManagementHeader(
            title: 'Transaction Management',
            showSearch: false,
          ),
          child: _buildTransactionContent(controller, context),
        );
      },
    );
  }

  Widget _buildTransactionContent(
    MbxTransactionController controller,
    BuildContext context,
  ) {
    return Column(
      children: [
        // Transaction Table Container
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
                // Transaction Table using reusable component
                Expanded(
                  child: Obx(
                    () => MbxTransactionTableWidget(
                      transactions: controller.transactions,
                      isLoading: controller.isLoading.value,
                      enableSorting: false,
                      actionBuilder: (transaction) =>
                          MbxTransactionTableActionBuilders.buildStandardActions(
                            transaction,
                            onView: () => _viewTransaction(transaction),
                            onDownload: () => _downloadReceipt(transaction),
                          ),
                      onRowTap: (transaction) =>
                          () => _viewTransaction(transaction),
                    ),
                  ),
                ),

                // Pagination
                Obx(
                  () => MbxPaginationWidget(
                    currentPage: controller.currentPage.value,
                    totalPages: controller.totalPages.value,
                    totalItems: controller.totalTransactions.value,
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

  void _viewTransaction(MbxTransactionModel transaction) {
    MbxTransactionDetailDialog.show(Get.context!, transaction);
  }

  void _downloadReceipt(MbxTransactionModel transaction) {
    _showFeatureNotAvailable('Download Receipt');
  }

  void _showFeatureNotAvailable(String featureName) {
    MbxDialogController.showFeatureNotAvailable(featureName);
  }
}
