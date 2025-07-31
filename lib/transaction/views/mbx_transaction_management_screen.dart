import 'package:mbankingbackoffice/transaction/controllers/mbx_transaction_controller.dart';
import 'package:mbankingbackoffice/transaction/models/mbx_transaction_model.dart';
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
          onRefreshPressed: controller.refreshTransactions,
          child: _buildTransactionContent(controller),
        );
      },
    );
  }

  Widget _buildTransactionContent(MbxTransactionController controller) {
    return Column(
      children: [
        // Transaction Table
        Expanded(child: Obx(() => _buildTransactionTable(controller))),
      ],
    );
  }

  Widget _buildTransactionTable(MbxTransactionController controller) {
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
            child: Row(
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total: ${controller.totalTransactions.value}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading State
          if (controller.isLoading.value)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (controller.transactions.isEmpty)
            // Empty State
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No transactions found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Transactions will appear here once processed',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            // Transaction Table
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: DataTable(
                    columnSpacing: 16,
                    dataRowMinHeight: 56,
                    dataRowMaxHeight: 72,
                    headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
                    columns: const [
                      DataColumn(
                        label: Text(
                          'ID',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Type',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'User',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Amount',
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
                          'Date',
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
                    rows: controller.transactions
                        .map(
                          (transaction) =>
                              _buildTransactionRow(transaction, controller),
                        )
                        .toList(),
                  ),
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
    );
  }

  DataRow _buildTransactionRow(
    MbxTransactionModel transaction,
    MbxTransactionController controller,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            transaction.id.toString(),
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
        DataCell(
          Container(
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
          ),
        ),
        DataCell(
          Column(
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
                  color: Colors.grey[600],
                  fontFamily: 'monospace',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            transaction.formattedAmount,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF1976D2),
            ),
          ),
        ),
        DataCell(
          Container(
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
          ),
        ),
        DataCell(
          Text(
            transaction.formattedCreatedAt,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => controller.viewTransaction(transaction),
                icon: const Icon(Icons.visibility_outlined, size: 18),
                tooltip: 'View Details',
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ],
    );
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
