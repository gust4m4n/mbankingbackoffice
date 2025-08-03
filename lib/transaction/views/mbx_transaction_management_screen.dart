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
        // Transaction Table
        Expanded(child: _buildTransactionTable(controller, context)),
      ],
    );
  }

  Widget _buildTransactionTable(
    MbxTransactionController controller,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Transaction Table using reusable component
          MbxDataTableWidget(
            isLoading: controller.isLoading.value,
            columns: [
              const MbxDataColumn(
                label: 'ID',
                width: 120,
                sortable: true,
                sortKey: 'id',
              ),
              MbxDataColumn(
                label: 'Type',
                width: 140,
                sortable: true,
                sortKey: 'type',
                customWidget: (data) => _buildTypeCell(data),
              ),
              MbxDataColumn(
                label: 'User',
                width: 180,
                sortable: true,
                sortKey: 'userName',
                customWidget: (data) => _buildUserCell(data),
              ),
              MbxDataColumn(
                label: 'Amount',
                width: 130,
                sortable: true,
                sortKey: 'amount',
                textAlign: TextAlign.right,
                customWidget: (data) => _buildAmountCell(data),
              ),
              MbxDataColumn(
                label: 'Status',
                width: 120,
                sortable: true,
                sortKey: 'status',
                customWidget: (data) => _buildStatusCell(data),
              ),
              const MbxDataColumn(
                label: 'Date',
                width: 140,
                sortable: true,
                sortKey: 'date',
              ),
            ],
            rows: controller.transactions.map((transaction) {
              return MbxDataRow(
                id: transaction.id.toString(),
                data: {
                  'id': transaction.id,
                  'type': transaction.type,
                  'userName': transaction.userName,
                  'amount': transaction.amount,
                  'status': transaction.status,
                  'date': transaction.formattedCreatedAt,
                  'transaction': transaction,
                },
                actions: [
                  IconButton(
                    onPressed: () => _viewTransaction(transaction),
                    icon: const Icon(Icons.visibility_outlined, size: 18),
                    tooltip: 'View Details',
                    splashRadius: 20,
                  ),
                  IconButton(
                    onPressed: () => _downloadReceipt(transaction),
                    icon: const Icon(Icons.download_outlined, size: 18),
                    tooltip: 'Download Receipt',
                    splashRadius: 20,
                  ),
                ],
                onTap: () => _viewTransaction(transaction),
              );
            }).toList(),
            emptyIcon: Icons.receipt_long_outlined,
            emptyTitle: 'No transactions found',
            emptySubtitle: 'Transactions will appear here once processed',
            enableHighlight: true,
            enableRowOnlyHighlight: true,
            minTableWidth: 890,
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
    );
  }

  Widget _buildTypeCell(Map<String, dynamic> data) {
    final transaction = data['transaction'] as MbxTransactionModel;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getTypeColor(transaction.type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        transaction.displayType,
        style: TextStyle(
          color: _getTypeColor(transaction.type),
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildUserCell(Map<String, dynamic> data) {
    final transaction = data['transaction'] as MbxTransactionModel;

    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              transaction.userName,
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              transaction.maskedAccountNumber,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey[600],
                fontFamily: 'monospace',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAmountCell(Map<String, dynamic> data) {
    final transaction = data['transaction'] as MbxTransactionModel;

    return Text(
      transaction.formattedAmount,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        color: Color(0xFF1976D2),
      ),
    );
  }

  Widget _buildStatusCell(Map<String, dynamic> data) {
    final transaction = data['transaction'] as MbxTransactionModel;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(transaction.status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        transaction.displayStatus,
        style: TextStyle(
          color: _getStatusColor(transaction.status),
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
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

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'transfer':
        return Colors.blue;
      case 'topup':
        return Colors.green;
      case 'withdraw':
        return Colors.orange;
      case 'reversal':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
      case 'cancelled':
        return Colors.red;
      case 'reversed':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
