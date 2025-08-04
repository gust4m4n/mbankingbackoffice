import 'package:flutter/material.dart';
import 'package:mbankingbackoffice/admin/models/mbx_admin_model.dart';

import 'mbx_data_table_widget.dart';

/// Reusable admin table widget with predefined columns and cell builders
class MbxAdminTableWidget extends StatelessWidget {
  final List<MbxAdminModel> admins;
  final bool isLoading;
  final List<Widget> Function(MbxAdminModel admin)? actionBuilder;
  final VoidCallback Function(MbxAdminModel admin)? onRowTap;
  final List<MbxAdminColumnType> visibleColumns;
  final String? emptyTitle;
  final String? emptySubtitle;
  final IconData? emptyIcon;
  final bool enableSorting;
  final String? sortColumn;
  final bool sortAscending;
  final Function(String column, bool ascending)? onSort;
  final bool enableHighlight;

  const MbxAdminTableWidget({
    super.key,
    required this.admins,
    this.isLoading = false,
    this.actionBuilder,
    this.onRowTap,
    this.visibleColumns = const [
      MbxAdminColumnType.name,
      MbxAdminColumnType.email,
      MbxAdminColumnType.role,
      MbxAdminColumnType.status,
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
      emptyTitle: emptyTitle ?? 'No administrators found',
      emptySubtitle: emptySubtitle ?? 'Create your first admin to get started',
      emptyIcon: emptyIcon ?? Icons.admin_panel_settings_outlined,
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
        case MbxAdminColumnType.name:
          return MbxDataColumn(
            key: 'name',
            label: 'Name',
            width: 180,
            sortable: true,
            sortKey: 'name',
            customWidget: (data) =>
                MbxAdminTableCellBuilders.buildNameCell(data),
          );
        case MbxAdminColumnType.email:
          return const MbxDataColumn(
            key: 'email',
            label: 'Email',
            width: 200,
            sortable: true,
            sortKey: 'email',
          );
        case MbxAdminColumnType.role:
          return MbxDataColumn(
            key: 'role',
            label: 'Role',
            width: 120,
            sortable: true,
            sortKey: 'role',
            customWidget: (data) =>
                MbxAdminTableCellBuilders.buildRoleCell(data),
          );
        case MbxAdminColumnType.status:
          return MbxDataColumn(
            key: 'status',
            label: 'Status',
            width: 100,
            sortable: true,
            sortKey: 'status',
            customWidget: (data) =>
                MbxAdminTableCellBuilders.buildStatusCell(data),
          );
        case MbxAdminColumnType.createdAt:
          return MbxDataColumn(
            key: 'createdAt',
            label: 'Created At',
            width: 140,
            sortable: true,
            sortKey: 'created_at',
            customWidget: (data) =>
                MbxAdminTableCellBuilders.buildDateCell(data, 'createdAt'),
          );
        case MbxAdminColumnType.lastLogin:
          return MbxDataColumn(
            key: 'lastLogin',
            label: 'Last Login',
            width: 140,
            sortable: true,
            sortKey: 'last_login_at',
            customWidget: (data) =>
                MbxAdminTableCellBuilders.buildDateCell(data, 'lastLogin'),
          );
      }
    }).toList();
  }

  List<MbxDataRow> _buildRows() {
    return admins.map((admin) {
      final actions = actionBuilder?.call(admin) ?? [];

      return MbxDataRow(
        key: admin.id.toString(),
        id: admin.id.toString(),
        cells: _buildCells(admin),
        data: _buildDataMap(admin),
        actions: actions,
        onTap: onRowTap != null ? () => onRowTap!(admin) : null,
      );
    }).toList();
  }

  Map<String, MbxDataCell> _buildCells(MbxAdminModel admin) {
    final cells = <String, MbxDataCell>{};

    for (final columnType in visibleColumns) {
      switch (columnType) {
        case MbxAdminColumnType.name:
          cells['name'] = MbxDataCell(value: admin.name);
          break;
        case MbxAdminColumnType.email:
          cells['email'] = MbxDataCell(value: admin.email);
          break;
        case MbxAdminColumnType.role:
          cells['role'] = MbxDataCell(value: admin.displayRole);
          break;
        case MbxAdminColumnType.status:
          cells['status'] = MbxDataCell(value: admin.displayStatus);
          break;
        case MbxAdminColumnType.createdAt:
          cells['createdAt'] = MbxDataCell(value: admin.createdAt ?? '');
          break;
        case MbxAdminColumnType.lastLogin:
          cells['lastLogin'] = MbxDataCell(value: admin.lastLoginAt ?? '');
          break;
      }
    }

    return cells;
  }

  Map<String, dynamic> _buildDataMap(MbxAdminModel admin) {
    return {
      'name': admin.name,
      'email': admin.email,
      'role': admin.displayRole,
      'status': admin.displayStatus,
      'isSuperAdmin': admin.isSuperAdmin,
      'isActive': admin.isActive,
      'createdAt': admin.createdAt ?? '',
      'lastLogin': admin.lastLoginAt ?? '',
      'admin': admin,
    };
  }
}

/// Available column types for admin table
enum MbxAdminColumnType { name, email, role, status, createdAt, lastLogin }

/// Reusable cell builders for admin table
class MbxAdminTableCellBuilders {
  /// Build name cell with avatar and name
  static Widget buildNameCell(Map<String, dynamic> data) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFF1976D2),
          child: Text(
            data['name']?.toString().isNotEmpty == true
                ? data['name'].toString()[0].toUpperCase()
                : 'A',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            data['name']?.toString() ?? '',
            style: const TextStyle(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Build role cell with colored chip
  static Widget buildRoleCell(Map<String, dynamic> data) {
    final role = data['role']?.toString() ?? '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getRoleColor(role).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: _getRoleColor(role),
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  /// Build status cell with colored chip
  static Widget buildStatusCell(Map<String, dynamic> data) {
    final isActive = data['isActive'] as bool? ?? false;
    final status = data['status']?.toString() ?? '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
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

  /// Get role color based on role type
  static Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'super_admin':
      case 'super admin':
        return Colors.purple;
      case 'admin':
        return Colors.blue;
      case 'moderator':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
