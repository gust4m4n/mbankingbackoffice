import 'package:flutter/material.dart';
import 'package:mbankingbackoffice/transaction/models/mbx_transaction_model.dart';

/// Action builders for transaction table
class MbxTransactionTableActionBuilders {
  /// Build standard actions for transaction table
  static List<Widget> buildStandardActions(
    MbxTransactionModel transaction, {
    VoidCallback? onView,
    VoidCallback? onDownload,
    VoidCallback? onRefund,
    VoidCallback? onReverse,
  }) {
    final actions = <Widget>[];

    // View action (always available)
    actions.add(
      IconButton(
        onPressed: onView,
        icon: const Icon(Icons.visibility_outlined, size: 18),
        tooltip: 'View Details',
        splashRadius: 20,
      ),
    );

    // Download receipt action (always available)
    actions.add(
      IconButton(
        onPressed: onDownload,
        icon: const Icon(Icons.download_outlined, size: 18),
        tooltip: 'Download Receipt',
        splashRadius: 20,
      ),
    );

    // Refund action (only for completed transactions)
    if (transaction.status.toLowerCase() == 'completed' && onRefund != null) {
      actions.add(
        IconButton(
          onPressed: onRefund,
          icon: const Icon(Icons.undo_outlined, size: 18, color: Colors.orange),
          tooltip: 'Refund Transaction',
          splashRadius: 20,
        ),
      );
    }

    // Reverse action (only for completed transactions and if not already reversed)
    if (transaction.status.toLowerCase() == 'completed' &&
        !transaction.isReversed &&
        onReverse != null) {
      actions.add(
        IconButton(
          onPressed: onReverse,
          icon: const Icon(
            Icons.restore_outlined,
            size: 18,
            color: Colors.purple,
          ),
          tooltip: 'Reverse Transaction',
          splashRadius: 20,
        ),
      );
    }

    return actions;
  }

  /// Build view-only actions for read-only scenarios
  static List<Widget> buildViewOnlyActions(
    MbxTransactionModel transaction, {
    VoidCallback? onView,
    VoidCallback? onDownload,
  }) {
    return [
      IconButton(
        onPressed: onView,
        icon: const Icon(Icons.visibility_outlined, size: 18),
        tooltip: 'View Details',
        splashRadius: 20,
      ),
      IconButton(
        onPressed: onDownload,
        icon: const Icon(Icons.download_outlined, size: 18),
        tooltip: 'Download Receipt',
        splashRadius: 20,
      ),
    ];
  }

  /// Build minimal actions for compact display
  static List<Widget> buildMinimalActions(
    MbxTransactionModel transaction, {
    VoidCallback? onView,
  }) {
    return [
      IconButton(
        onPressed: onView,
        icon: const Icon(Icons.visibility_outlined, size: 18),
        tooltip: 'View Details',
        splashRadius: 20,
      ),
    ];
  }

  /// Build custom actions based on transaction type and status
  static List<Widget> buildCustomActions(
    MbxTransactionModel transaction, {
    VoidCallback? onView,
    VoidCallback? onDownload,
    VoidCallback? onRetry,
    VoidCallback? onCancel,
    VoidCallback? onApprove,
    VoidCallback? onReject,
  }) {
    final actions = <Widget>[];

    // Always add view action
    actions.add(
      IconButton(
        onPressed: onView,
        icon: const Icon(Icons.visibility_outlined, size: 18),
        tooltip: 'View Details',
        splashRadius: 20,
      ),
    );

    // Status-specific actions
    switch (transaction.status.toLowerCase()) {
      case 'pending':
        if (onApprove != null) {
          actions.add(
            IconButton(
              onPressed: onApprove,
              icon: const Icon(
                Icons.check_circle_outline,
                size: 18,
                color: Colors.green,
              ),
              tooltip: 'Approve Transaction',
              splashRadius: 20,
            ),
          );
        }
        if (onReject != null) {
          actions.add(
            IconButton(
              onPressed: onReject,
              icon: const Icon(
                Icons.cancel_outlined,
                size: 18,
                color: Colors.red,
              ),
              tooltip: 'Reject Transaction',
              splashRadius: 20,
            ),
          );
        }
        break;

      case 'failed':
        if (onRetry != null) {
          actions.add(
            IconButton(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_outlined,
                size: 18,
                color: Colors.blue,
              ),
              tooltip: 'Retry Transaction',
              splashRadius: 20,
            ),
          );
        }
        break;

      case 'completed':
        if (onDownload != null) {
          actions.add(
            IconButton(
              onPressed: onDownload,
              icon: const Icon(Icons.download_outlined, size: 18),
              tooltip: 'Download Receipt',
              splashRadius: 20,
            ),
          );
        }
        break;

      default:
        // For other statuses, just show download if available
        if (onDownload != null) {
          actions.add(
            IconButton(
              onPressed: onDownload,
              icon: const Icon(Icons.download_outlined, size: 18),
              tooltip: 'Download Receipt',
              splashRadius: 20,
            ),
          );
        }
        break;
    }

    return actions;
  }
}
