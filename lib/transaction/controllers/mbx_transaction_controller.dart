import 'package:mbankingbackoffice/transaction/models/mbx_transaction_model.dart';
import 'package:mbankingbackoffice/transaction/services/mbx_transaction_api_service.dart';
import 'package:mbankingbackoffice/transaction/views/mbx_transaction_detail_dialog.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxTransactionController extends GetxController {
  // Loading states
  var isLoading = false.obs;
  var isSubmitting = false.obs;

  // Transaction list
  var transactions = <MbxTransactionModel>[].obs;
  var totalTransactions = 0.obs;
  var currentPage = 1.obs;
  var perPage = 10.obs;
  var totalPages = 1.obs;

  // Selected transaction for view/reversal
  MbxTransactionModel? selectedTransaction;

  // Filter controllers
  final userIdController = TextEditingController();
  final typeController = TextEditingController();
  final statusController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  // Reversal form
  final reversalReasonController = TextEditingController();
  var reversalReasonError = '';

  // Filter states
  var selectedType = '';
  var selectedStatus = '';

  // Available filter options
  final types = ['', 'topup', 'withdraw', 'transfer', 'reversal'];
  final statuses = [
    '',
    'pending',
    'completed',
    'failed',
    'cancelled',
    'reversed',
  ];

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  @override
  void onClose() {
    userIdController.dispose();
    typeController.dispose();
    statusController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    reversalReasonController.dispose();
    super.onClose();
  }

  /// Load transactions list with filters
  Future<void> loadTransactions({int page = 1}) async {
    try {
      isLoading.value = true;
      currentPage.value = page;
      update();

      final response = await MbxTransactionApiService.getTransactions(
        page: page,
        perPage: perPage.value,
        userId: userIdController.text.trim().isNotEmpty
            ? userIdController.text.trim()
            : null,
        type: selectedType.isNotEmpty ? selectedType : null,
        status: selectedStatus.isNotEmpty ? selectedStatus : null,
        startDate: startDateController.text.trim().isNotEmpty
            ? startDateController.text.trim()
            : null,
        endDate: endDateController.text.trim().isNotEmpty
            ? endDateController.text.trim()
            : null,
      );

      if (response.statusCode == 200) {
        final data = response.jason.mapValue;
        final transactionListResponse =
            MbxTransactionApiService.parseTransactionListResponse(data['data']);

        transactions.value = transactionListResponse.transactions;
        totalTransactions.value = transactionListResponse.total;
        totalPages.value = transactionListResponse.totalPages;

        print('Loaded ${transactions.length} transactions');
      } else {
        ToastX.showError(
          msg: 'Failed to load transactions: ${response.message}',
        );
      }
    } catch (e) {
      print('Error loading transactions: $e');
      ToastX.showError(msg: 'Error loading transactions: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  /// View transaction details
  void viewTransaction(MbxTransactionModel transaction) {
    selectedTransaction = transaction;
    MbxTransactionDetailDialog.show(
      Get.context!,
      transaction,
      onReverse: () => showReversalDialog(transaction),
    );
  }

  /// Show transaction reversal dialog
  void showReversalDialog(MbxTransactionModel transaction) {
    selectedTransaction = transaction;
    reversalReasonController.clear();
    reversalReasonError = '';
    Get.dialog(_buildReversalDialog(), barrierDismissible: false);
  }

  /// Reverse transaction
  Future<void> reverseTransaction() async {
    if (!_validateReversalForm()) return;

    try {
      isSubmitting.value = true;
      update();

      final request = MbxTransactionReversalRequest(
        transactionId: selectedTransaction!.id,
        reason: reversalReasonController.text.trim(),
      );

      final response = await MbxTransactionApiService.reverseTransaction(
        request,
      );

      if (response.statusCode == 200) {
        ToastX.showSuccess(msg: 'Transaction reversed successfully');
        Get.back(); // Close dialog
        loadTransactions(page: currentPage.value); // Refresh list
      } else {
        ToastX.showError(
          msg: 'Failed to reverse transaction: ${response.message}',
        );
      }
    } catch (e) {
      print('Error reversing transaction: $e');
      ToastX.showError(msg: 'Error reversing transaction: $e');
    } finally {
      isSubmitting.value = false;
      update();
    }
  }

  /// Apply filters
  void applyFilters() {
    currentPage.value = 1;
    loadTransactions();
  }

  /// Clear all filters
  void clearFilters() {
    userIdController.clear();
    typeController.clear();
    statusController.clear();
    startDateController.clear();
    endDateController.clear();
    selectedType = '';
    selectedStatus = '';
    currentPage.value = 1;
    loadTransactions();
  }

  /// Go to next page
  void nextPage() {
    if (currentPage.value < totalPages.value) {
      loadTransactions(page: currentPage.value + 1);
    }
  }

  /// Go to previous page
  void previousPage() {
    if (currentPage.value > 1) {
      loadTransactions(page: currentPage.value - 1);
    }
  }

  /// Go to first page
  void firstPage() {
    if (currentPage.value > 1) {
      loadTransactions(page: 1);
    }
  }

  /// Go to last page
  void lastPage() {
    if (currentPage.value < totalPages.value) {
      loadTransactions(page: totalPages.value);
    }
  }

  /// Go to specific page
  void goToPage(int page) {
    if (page >= 1 && page <= totalPages.value && page != currentPage.value) {
      loadTransactions(page: page);
    }
  }

  /// Refresh transaction list
  void refreshTransactions() {
    loadTransactions(page: currentPage.value);
  }

  // Private methods

  bool _validateReversalForm() {
    reversalReasonError = '';
    bool isValid = true;

    if (reversalReasonController.text.trim().isEmpty) {
      reversalReasonError = 'Reversal reason is required';
      isValid = false;
    } else if (reversalReasonController.text.trim().length < 10) {
      reversalReasonError = 'Reversal reason must be at least 10 characters';
      isValid = false;
    }

    update();
    return isValid;
  }

  // Dialog builders

  Widget _buildReversalDialog() {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Reverse Transaction',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'WARNING: This action cannot be undone',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Transaction ID: ${selectedTransaction?.id}'),
                  Text('Amount: ${selectedTransaction?.formattedAmount}'),
                  Text('User: ${selectedTransaction?.userName}'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Reversal reason field
            TextFieldX(
              hint: 'Reversal Reason (minimum 10 characters)',
              controller: reversalReasonController,
              keyboardType: TextInputType.multiline,
              readOnly: false,
              obscureText: false,
              onChanged: (value) {
                reversalReasonError = '';
                update();
              },
            ),
            if (reversalReasonError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  reversalReasonError,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isSubmitting.value ? null : reverseTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: isSubmitting.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Confirm Reversal'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
