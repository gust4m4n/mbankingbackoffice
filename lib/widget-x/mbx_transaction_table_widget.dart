import 'package:flutter/material.dart';
import 'package:mbankingbackoffice/transaction/models/mbx_transaction_model.dart';

import 'mbx_data_table_widget.dart';

/// Reusable transaction table widget with predefined columns and cell builders
class MbxTransactionTableWidget extends StatelessWidget {
  final List<MbxTransactionModel> transactions;
  final bool isLoading;
  final List<Widget> Function(MbxTransactionModel transaction)? actionBuilder;
  final VoidCallback Function(MbxTransactionModel transaction)? onRowTap;
  final List<MbxTransactionColumnType> visibleColumns;
  final String? emptyTitle;
  final String? emptySubtitle;
  final IconData? emptyIcon;
  final bool enableSorting;
  final String? sortColumn;
  final bool sortAscending;
  final Function(String column, bool ascending)? onSort;
  final bool enableHighlight;

  const MbxTransactionTableWidget({
    super.key,
    required this.transactions,
    this.isLoading = false,
    this.actionBuilder,
    this.onRowTap,
    this.visibleColumns = const [
      MbxTransactionColumnType.id,
      MbxTransactionColumnType.type,
      MbxTransactionColumnType.userName,
      MbxTransactionColumnType.amount,
      MbxTransactionColumnType.status,
      MbxTransactionColumnType.date,
    ],
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon,
    this.enableSorting = true,
    this.sortColumn,
    this.sortAscending = true,
    this.onSort,
    this.enableHighlight = true,
  });

  @override
  Widget build(BuildContext context) {
    return MbxDataTableWidget(
      isLoading: isLoading,
      columns: _buildColumns(),
      rows: _buildRows(),
      emptyTitle: emptyTitle ?? 'No transactions found',
      emptySubtitle:
          emptySubtitle ?? 'Transactions will appear here once processed',
      emptyIcon: emptyIcon ?? Icons.receipt_long_outlined,
      enableSorting: enableSorting,
      sortColumn: sortColumn,
      sortAscending: sortAscending,
      onSort: onSort,
      enableHighlight: enableHighlight,
      enableRowOnlyHighlight: true,
      minTableWidth: 890,
    );
  }

  List<MbxDataColumn> _buildColumns() {
    return visibleColumns.map((columnType) {
      switch (columnType) {
        case MbxTransactionColumnType.id:
          return const MbxDataColumn(
            key: 'id',
            label: 'ID',
            width: 120,
            sortable: true,
            sortKey: 'id',
          );
        case MbxTransactionColumnType.type:
          return MbxDataColumn(
            key: 'type',
            label: 'Type',
            width: 140,
            sortable: true,
            sortKey: 'type',
            customWidget: (data) =>
                MbxTransactionTableCellBuilders.buildTypeCell(data),
          );
        case MbxTransactionColumnType.userName:
          return MbxDataColumn(
            key: 'userName',
            label: 'User',
            width: 180,
            sortable: true,
            sortKey: 'userName',
            customWidget: (data) =>
                MbxTransactionTableCellBuilders.buildUserCell(data),
          );
        case MbxTransactionColumnType.amount:
          return MbxDataColumn(
            key: 'amount',
            label: 'Amount',
            width: 130,
            sortable: true,
            sortKey: 'amount',
            textAlign: TextAlign.right,
            customWidget: (data) =>
                MbxTransactionTableCellBuilders.buildAmountCell(data),
          );
        case MbxTransactionColumnType.status:
          return MbxDataColumn(
            key: 'status',
            label: 'Status',
            width: 120,
            sortable: true,
            sortKey: 'status',
            customWidget: (data) =>
                MbxTransactionTableCellBuilders.buildStatusCell(data),
          );
        case MbxTransactionColumnType.date:
          return const MbxDataColumn(
            key: 'date',
            label: 'Date',
            width: 140,
            sortable: true,
            sortKey: 'date',
          );
        case MbxTransactionColumnType.description:
          return const MbxDataColumn(
            key: 'description',
            label: 'Description',
            width: 200,
            sortable: false,
          );
        case MbxTransactionColumnType.balanceBefore:
          return MbxDataColumn(
            key: 'balanceBefore',
            label: 'Balance Before',
            width: 140,
            sortable: true,
            sortKey: 'balance_before',
            textAlign: TextAlign.right,
            customWidget: (data) =>
                MbxTransactionTableCellBuilders.buildBalanceCell(
                  data,
                  'balanceBefore',
                ),
          );
        case MbxTransactionColumnType.balanceAfter:
          return MbxDataColumn(
            key: 'balanceAfter',
            label: 'Balance After',
            width: 140,
            sortable: true,
            sortKey: 'balance_after',
            textAlign: TextAlign.right,
            customWidget: (data) =>
                MbxTransactionTableCellBuilders.buildBalanceCell(
                  data,
                  'balanceAfter',
                ),
          );
      }
    }).toList();
  }

  List<MbxDataRow> _buildRows() {
    return transactions.map((transaction) {
      final actions = actionBuilder?.call(transaction) ?? [];

      return MbxDataRow(
        key: transaction.id.toString(),
        id: transaction.id.toString(),
        cells: _buildCells(transaction),
        data: _buildDataMap(transaction),
        actions: actions,
        onTap: onRowTap != null ? () => onRowTap!(transaction) : null,
      );
    }).toList();
  }

  Map<String, MbxDataCell> _buildCells(MbxTransactionModel transaction) {
    final cells = <String, MbxDataCell>{};

    for (final columnType in visibleColumns) {
      switch (columnType) {
        case MbxTransactionColumnType.id:
          cells['id'] = MbxDataCell(value: transaction.id);
          break;
        case MbxTransactionColumnType.type:
          cells['type'] = MbxDataCell(value: transaction.type);
          break;
        case MbxTransactionColumnType.userName:
          cells['userName'] = MbxDataCell(value: transaction.userName);
          break;
        case MbxTransactionColumnType.amount:
          cells['amount'] = MbxDataCell(value: transaction.amount);
          break;
        case MbxTransactionColumnType.status:
          cells['status'] = MbxDataCell(value: transaction.status);
          break;
        case MbxTransactionColumnType.date:
          cells['date'] = MbxDataCell(value: transaction.formattedCreatedAt);
          break;
        case MbxTransactionColumnType.description:
          cells['description'] = MbxDataCell(
            value: transaction.description ?? '',
          );
          break;
        case MbxTransactionColumnType.balanceBefore:
          cells['balanceBefore'] = MbxDataCell(
            value: transaction.balanceBefore ?? 0.0,
          );
          break;
        case MbxTransactionColumnType.balanceAfter:
          cells['balanceAfter'] = MbxDataCell(
            value: transaction.balanceAfter ?? 0.0,
          );
          break;
      }
    }

    return cells;
  }

  Map<String, dynamic> _buildDataMap(MbxTransactionModel transaction) {
    return {
      'id': transaction.id,
      'type': transaction.type,
      'userName': transaction.userName,
      'amount': transaction.amount,
      'status': transaction.status,
      'date': transaction.formattedCreatedAt,
      'description': transaction.description ?? '',
      'balanceBefore': transaction.balanceBefore ?? 0.0,
      'balanceAfter': transaction.balanceAfter ?? 0.0,
      'transaction': transaction,
    };
  }
}

/// Available column types for transaction table
enum MbxTransactionColumnType {
  id,
  type,
  userName,
  amount,
  status,
  date,
  description,
  balanceBefore,
  balanceAfter,
}

/// Reusable cell builders for transaction table
class MbxTransactionTableCellBuilders {
  /// Build type cell with colored chip
  static Widget buildTypeCell(Map<String, dynamic> data) {
    final transaction = data['transaction'] as MbxTransactionModel;

    return Container(
      height: 35,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getTypeColor(transaction.type).withValues(alpha: 0.1),
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
    );
  }

  /// Build user cell with name and masked account number
  static Widget buildUserCell(Map<String, dynamic> data) {
    final transaction = data['transaction'] as MbxTransactionModel;

    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Builder(
        builder: (context) {
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                transaction.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                transaction.maskedAccountNumber,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode
                      ? const Color(0xFFB0B0B0)
                      : Colors.grey[600],
                  fontFamily: 'monospace',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }

  /// Build amount cell with currency formatting and styling
  static Widget buildAmountCell(Map<String, dynamic> data) {
    final transaction = data['transaction'] as MbxTransactionModel;
    return Container(
      height: 35,
      alignment: Alignment.centerRight,
      child: Text(
        transaction.formattedAmount,
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

  /// Build status cell with colored chip
  static Widget buildStatusCell(Map<String, dynamic> data) {
    final transaction = data['transaction'] as MbxTransactionModel;

    return Container(
      height: 35,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getStatusColor(transaction.status).withValues(alpha: 0.1),
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
    );
  }

  /// Build balance cell with currency formatting
  static Widget buildBalanceCell(Map<String, dynamic> data, String field) {
    final value = data[field] as double? ?? 0.0;

    return Container(
      height: 35,
      alignment: Alignment.centerRight,
      child: Text(
        'Rp ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
        textAlign: TextAlign.right,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  static Color _getTypeColor(String type) {
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

  static Color _getStatusColor(String status) {
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
