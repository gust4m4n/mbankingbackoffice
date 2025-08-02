import 'package:mbankingbackoffice/transaction/models/mbx_transaction_model.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxTransactionDetailDialog extends StatelessWidget {
  final MbxTransactionModel transaction;
  final VoidCallback? onReverse;

  const MbxTransactionDetailDialog({
    super.key,
    required this.transaction,
    this.onReverse,
  });

  static void show(
    BuildContext context,
    MbxTransactionModel transaction, {
    VoidCallback? onReverse,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => MbxTransactionDetailDialog(
        transaction: transaction,
        onReverse: onReverse,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width > 800 ? 750.0 : screenSize.width * 0.9;
    final dialogHeight = screenSize.height * 0.85;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.5 : 0.15),
              blurRadius: 25,
              offset: const Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with close button
            _buildHeader(isDarkMode),

            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Transaction Profile Header
                    _buildTransactionHeader(isDarkMode),

                    const SizedBox(height: 20),

                    // Information Cards in a more compact layout
                    _buildInfoSection(isDarkMode),

                    // Reversal Information (if reversed)
                    if (transaction.isReversed) ...[
                      const SizedBox(height: 20),
                      _buildReversalSection(isDarkMode),
                    ],

                    const SizedBox(height: 20),

                    // Action Buttons
                    _buildActionButtons(isDarkMode),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1a1a1a) : const Color(0xFFF8F9FA),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Transaction Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(Get.context!).pop(),
            icon: Icon(
              Icons.close_rounded,
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
            style: IconButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.white10 : Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHeader(bool isDarkMode) {
    Color getTransactionColor() {
      switch (transaction.type.toLowerCase()) {
        case 'topup':
        case 'deposit':
          return const Color(0xFF4CAF50); // Green
        case 'withdraw':
        case 'withdrawal':
          return const Color(0xFFF44336); // Red
        case 'transfer':
          return const Color(0xFF2196F3); // Blue
        default:
          return const Color(0xFF9C27B0); // Purple
      }
    }

    Color getStatusColor() {
      switch (transaction.status.toLowerCase()) {
        case 'completed':
        case 'success':
          return const Color(0xFF4CAF50);
        case 'pending':
          return const Color(0xFFFF9800);
        case 'failed':
        case 'cancelled':
          return const Color(0xFFF44336);
        default:
          return const Color(0xFF757575);
      }
    }

    IconData getTransactionIcon() {
      switch (transaction.type.toLowerCase()) {
        case 'topup':
        case 'deposit':
          return Icons.add_circle;
        case 'withdraw':
        case 'withdrawal':
          return Icons.remove_circle;
        case 'transfer':
          return Icons.swap_horiz;
        default:
          return Icons.receipt;
      }
    }

    final transactionColor = getTransactionColor();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [transactionColor, transactionColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: transactionColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Transaction Icon
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  getTransactionIcon(),
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              // Transaction Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.displayType,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${transaction.id}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor().withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white70, width: 1),
                      ),
                      child: Text(
                        transaction.displayStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Amount',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.formattedAmount,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (transaction.balanceChangeDisplay.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Balance Change: ',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    transaction.balanceChangeDisplay,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transaction Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 16),

        // Grid layout for info cards
        LayoutBuilder(
          builder: (context, constraints) {
            // Use 2 columns on wider screens, 1 column on narrow screens
            bool useTwoColumns = constraints.maxWidth > 500;

            List<Widget> infoCards = [
              _buildInfoCard(
                'User Name',
                transaction.userName,
                Icons.person,
                isDarkMode,
              ),
              _buildInfoCard(
                'Account Number',
                transaction.maskedAccountNumber,
                Icons.account_circle,
                isDarkMode,
              ),
            ];

            // Add target user info if it's a transfer
            if (transaction.targetUserName != null) {
              infoCards.addAll([
                _buildInfoCard(
                  'Target User',
                  transaction.targetUserName!,
                  Icons.person_outline,
                  isDarkMode,
                ),
                _buildInfoCard(
                  'Target Account',
                  transaction.maskedTargetAccountNumber,
                  Icons.account_circle_outlined,
                  isDarkMode,
                ),
              ]);
            }

            // Add description if available
            if (transaction.description != null &&
                transaction.description!.isNotEmpty) {
              infoCards.add(
                _buildInfoCard(
                  'Description',
                  transaction.description!,
                  Icons.description,
                  isDarkMode,
                ),
              );
            }

            // Add created date
            infoCards.add(
              _buildInfoCard(
                'Created At',
                transaction.formattedCreatedAt,
                Icons.access_time,
                isDarkMode,
              ),
            );

            if (useTwoColumns) {
              List<Widget> rows = [];
              for (int i = 0; i < infoCards.length; i += 2) {
                if (i + 1 < infoCards.length) {
                  rows.add(
                    Row(
                      children: [
                        Expanded(child: infoCards[i]),
                        const SizedBox(width: 12),
                        Expanded(child: infoCards[i + 1]),
                      ],
                    ),
                  );
                } else {
                  rows.add(infoCards[i]);
                }
                if (i + 2 < infoCards.length) {
                  rows.add(const SizedBox(height: 12));
                }
              }
              return Column(children: rows);
            } else {
              return Column(
                children:
                    infoCards
                        .expand((card) => [card, const SizedBox(height: 12)])
                        .toList()
                      ..removeLast(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff2a2a2a) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.white10 : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: const Color(0xFF1976D2)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReversalSection(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A1A1A) : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.red.shade800 : Colors.red.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.cancel, color: Colors.red, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'TRANSACTION REVERSED',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (transaction.reversalReason != null) ...[
            _buildReversalInfoRow(
              'Reason',
              transaction.reversalReason!,
              Icons.info_outline,
              isDarkMode,
            ),
            const SizedBox(height: 12),
          ],

          if (transaction.reversedAt != null)
            _buildReversalInfoRow(
              'Reversed At',
              transaction.reversedAt!,
              Icons.schedule,
              isDarkMode,
            ),
        ],
      ),
    );
  }

  Widget _buildReversalInfoRow(
    String label,
    String value,
    IconData icon,
    bool isDarkMode,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: isDarkMode ? Colors.red.shade400 : Colors.red.shade600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.red.shade300 : Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return Row(
      children: [
        const Spacer(),

        // Reverse Transaction Button (only show if not already reversed and completed)
        if (!transaction.isReversed &&
            transaction.status == 'completed' &&
            onReverse != null) ...[
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(Get.context!).pop();
              onReverse?.call();
            },
            icon: const Icon(Icons.undo, size: 18),
            label: const Text('Reverse Transaction'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],

        // Close Button
        ElevatedButton.icon(
          onPressed: () => Navigator.of(Get.context!).pop(),
          icon: const Icon(Icons.close, size: 18),
          label: const Text('Close'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
