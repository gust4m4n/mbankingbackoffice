import 'package:flutter/material.dart';

import 'mbx_data_table_widget.dart';

/// Reusable table header component with sticky functionality
class MbxTableHeader extends StatelessWidget {
  final List<MbxDataColumn> columns;
  final bool enableSorting;
  final String? sortColumn;
  final bool sortAscending;
  final Function(String column, bool ascending)? onSort;
  final bool hasActionsColumn;
  final String actionsColumnTitle;
  final double actionsColumnWidth;

  const MbxTableHeader({
    super.key,
    required this.columns,
    this.enableSorting = true,
    this.sortColumn,
    this.sortAscending = true,
    this.onSort,
    this.hasActionsColumn = false,
    this.actionsColumnTitle = 'ACTIONS',
    this.actionsColumnWidth = 100,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[100],
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? const Color(0xFF3A3A3A) : Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Regular column headers
            ...columns.asMap().entries.map((entry) {
              final index = entry.key;
              final column = entry.value;

              return Expanded(
                flex: _getColumnFlex(index),
                child: _buildHeaderCell(column, isDarkMode),
              );
            }),

            // Actions column header if needed
            if (hasActionsColumn)
              Container(
                width: actionsColumnWidth,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  actionsColumnTitle,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(MbxDataColumn column, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: _getMainAxisAlignment(column.textAlign),
        children: [
          Flexible(
            child: Text(
              column.label.toUpperCase(),
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (column.sortable && enableSorting) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () {
                if (onSort != null && column.sortKey != null) {
                  final isCurrentColumn = sortColumn == column.sortKey;
                  final newAscending = isCurrentColumn ? !sortAscending : true;
                  onSort!(column.sortKey!, newAscending);
                }
              },
              child: Icon(
                sortColumn == column.sortKey
                    ? (sortAscending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward)
                    : Icons.unfold_more,
                size: 16,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ],
      ),
    );
  }

  int _getColumnFlex(int index) {
    // You can customize flex values based on column requirements
    // For now, using equal flex for all columns
    return 1;
  }

  MainAxisAlignment _getMainAxisAlignment(TextAlign? textAlign) {
    switch (textAlign) {
      case TextAlign.left:
        return MainAxisAlignment.start;
      case TextAlign.right:
        return MainAxisAlignment.end;
      case TextAlign.center:
        return MainAxisAlignment.center;
      default:
        return MainAxisAlignment.start;
    }
  }
}
