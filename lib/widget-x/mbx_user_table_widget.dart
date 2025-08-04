import 'package:flutter/material.dart';
import 'package:mbankingbackoffice/user/models/mbx_user_model.dart';

import 'mbx_data_table_widget.dart';

/// Reusable user table widget with predefined columns and cell builders
class MbxUserTableWidget extends StatelessWidget {
  final List<MbxUserModel> users;
  final bool isLoading;
  final List<Widget> Function(MbxUserModel user)? actionBuilder;
  final VoidCallback Function(MbxUserModel user)? onRowTap;
  final List<MbxUserColumnType> visibleColumns;
  final String? emptyTitle;
  final String? emptySubtitle;
  final IconData? emptyIcon;
  final bool enableSorting;
  final String? sortColumn;
  final bool sortAscending;
  final Function(String column, bool ascending)? onSort;
  final bool enableHighlight;

  const MbxUserTableWidget({
    super.key,
    required this.users,
    this.isLoading = false,
    this.actionBuilder,
    this.onRowTap,
    this.visibleColumns = const [
      MbxUserColumnType.name,
      MbxUserColumnType.phone,
      MbxUserColumnType.balance,
      MbxUserColumnType.status,
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
      emptyTitle: emptyTitle ?? 'No users found',
      emptySubtitle:
          emptySubtitle ?? 'Users will appear here once they register',
      emptyIcon: emptyIcon ?? Icons.people_outline,
      enableSorting: enableSorting,
      sortColumn: sortColumn,
      sortAscending: sortAscending,
      onSort: onSort,
      enableHighlight: enableHighlight,
      enableRowOnlyHighlight: true,
    );
  }

  List<MbxDataColumn> _buildColumns() {
    return visibleColumns.map((columnType) {
      switch (columnType) {
        case MbxUserColumnType.name:
          return MbxDataColumn(
            key: 'name',
            label: 'Name',
            sortable: true,
            sortKey: 'name',
            customWidget: (data) =>
                MbxUserTableCellBuilders.buildNameCell(data),
          );
        case MbxUserColumnType.phone:
          return const MbxDataColumn(
            key: 'phone',
            label: 'Phone',
            sortable: true,
            sortKey: 'phone',
          );
        case MbxUserColumnType.accountNumber:
          return MbxDataColumn(
            key: 'accountNumber',
            label: 'Account Number',
            sortable: true,
            sortKey: 'account_number',
            customWidget: (data) =>
                MbxUserTableCellBuilders.buildAccountNumberCell(data),
          );
        case MbxUserColumnType.balance:
          return MbxDataColumn(
            key: 'balance',
            label: 'Balance',
            sortable: true,
            sortKey: 'balance',
            textAlign: TextAlign.right,
            customWidget: (data) =>
                MbxUserTableCellBuilders.buildBalanceCell(data),
          );
        case MbxUserColumnType.status:
          return MbxDataColumn(
            key: 'status',
            label: 'Status',
            sortable: true,
            sortKey: 'status',
            customWidget: (data) =>
                MbxUserTableCellBuilders.buildStatusCell(data),
          );
        case MbxUserColumnType.createdAt:
          return MbxDataColumn(
            key: 'createdAt',
            label: 'Created At',
            sortable: true,
            sortKey: 'created_at',
            customWidget: (data) =>
                MbxUserTableCellBuilders.buildDateCell(data, 'createdAt'),
          );
        case MbxUserColumnType.updatedAt:
          return MbxDataColumn(
            key: 'updatedAt',
            label: 'Updated At',
            sortable: true,
            sortKey: 'updated_at',
            customWidget: (data) =>
                MbxUserTableCellBuilders.buildDateCell(data, 'updatedAt'),
          );
      }
    }).toList();
  }

  List<MbxDataRow> _buildRows() {
    return users.map((user) {
      final actions = actionBuilder?.call(user) ?? [];

      return MbxDataRow(
        key: user.id.toString(),
        id: user.id.toString(),
        cells: _buildCells(user),
        data: _buildDataMap(user),
        actions: actions,
        onTap: onRowTap != null ? () => onRowTap!(user) : null,
      );
    }).toList();
  }

  Map<String, MbxDataCell> _buildCells(MbxUserModel user) {
    final cells = <String, MbxDataCell>{};

    for (final columnType in visibleColumns) {
      switch (columnType) {
        case MbxUserColumnType.name:
          cells['name'] = MbxDataCell(value: user.name);
          break;
        case MbxUserColumnType.phone:
          cells['phone'] = MbxDataCell(value: user.phone);
          break;
        case MbxUserColumnType.accountNumber:
          cells['accountNumber'] = MbxDataCell(value: user.accountNumber);
          break;
        case MbxUserColumnType.balance:
          cells['balance'] = MbxDataCell(value: user.balance);
          break;
        case MbxUserColumnType.status:
          cells['status'] = MbxDataCell(value: user.status);
          break;
        case MbxUserColumnType.createdAt:
          cells['createdAt'] = MbxDataCell(value: user.createdAt ?? '');
          break;
        case MbxUserColumnType.updatedAt:
          cells['updatedAt'] = MbxDataCell(value: user.updatedAt ?? '');
          break;
      }
    }

    return cells;
  }

  Map<String, dynamic> _buildDataMap(MbxUserModel user) {
    return {
      'name': user.name,
      'phone': user.phone,
      'accountNumber': user.accountNumber,
      'balance': user.balance,
      'status': user.status,
      'isActive': user.isActive,
      'createdAt': user.createdAt ?? '',
      'updatedAt': user.updatedAt ?? '',
      'user': user,
    };
  }
}

/// Available column types for user table
enum MbxUserColumnType {
  name,
  phone,
  accountNumber,
  balance,
  status,
  createdAt,
  updatedAt,
}

/// Reusable cell builders for user table
class MbxUserTableCellBuilders {
  /// Build name cell with styled text
  static Widget buildNameCell(Map<String, dynamic> data) {
    final user = data['user'] as MbxUserModel;
    return Container(
      height: 35,
      alignment: Alignment.centerLeft,
      child: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Build balance cell with currency formatting and styling
  static Widget buildBalanceCell(Map<String, dynamic> data) {
    final user = data['user'] as MbxUserModel;
    return Container(
      height: 35,
      alignment: Alignment.centerRight,
      child: Text(
        user.formattedBalance,
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
    final isActive = data['isActive'] as bool;
    final user = data['user'] as MbxUserModel;

    return Container(
      height: 32,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          user.displayStatus,
          style: TextStyle(
            color: isActive ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  /// Build account number cell with masking
  static Widget buildAccountNumberCell(Map<String, dynamic> data) {
    final user = data['user'] as MbxUserModel;
    return Container(
      height: 35,
      alignment: Alignment.centerLeft,
      child: Text(
        user.maskedAccountNumber,
        style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Build date cell with formatted date display
  static Widget buildDateCell(Map<String, dynamic> data, String field) {
    final dateString = data[field] as String? ?? '';
    String formattedDate = 'Never';

    if (dateString.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(dateString);
        formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      } catch (e) {
        formattedDate = dateString;
      }
    }

    return Container(
      height: 35,
      alignment: Alignment.centerLeft,
      child: Text(
        formattedDate,
        style: const TextStyle(fontSize: 13),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
