import 'package:flutter/material.dart';

/// Column configuration for the data table
class MbxDataColumn {
  final String label;
  final double? width;
  final bool sortable;
  final String? sortKey;
  final TextAlign textAlign;
  final Widget Function(dynamic data)? customWidget;

  const MbxDataColumn({
    required this.label,
    this.width,
    this.sortable = false,
    this.sortKey,
    this.textAlign = TextAlign.left,
    this.customWidget,
  });
}

/// Row data for the data table
class MbxDataRow {
  final String id;
  final Map<String, dynamic> data;
  final List<Widget> actions;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? highlightColor;

  const MbxDataRow({
    required this.id,
    required this.data,
    this.actions = const [],
    this.isSelected = false,
    this.onTap,
    this.highlightColor,
  });
}

/// Reusable DataTable widget with highlighting functionality
class MbxDataTableWidget extends StatefulWidget {
  final List<MbxDataColumn> columns;
  final List<MbxDataRow> rows;
  final bool isLoading;
  final Widget? emptyWidget;
  final String? emptyTitle;
  final String? emptySubtitle;
  final IconData? emptyIcon;
  final bool enableSorting;
  final String? sortColumn;
  final bool sortAscending;
  final Function(String column, bool ascending)? onSort;
  final Function(String rowId)? onRowSelected;
  final Set<String> selectedRows;
  final bool enableSelection;
  final bool enableHighlight;
  final Color? highlightColor;
  final double? minTableWidth;

  const MbxDataTableWidget({
    super.key,
    required this.columns,
    required this.rows,
    this.isLoading = false,
    this.emptyWidget,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon,
    this.enableSorting = true,
    this.sortColumn,
    this.sortAscending = true,
    this.onSort,
    this.onRowSelected,
    this.selectedRows = const {},
    this.enableSelection = false,
    this.enableHighlight = true,
    this.highlightColor,
    this.minTableWidth,
  });

  @override
  State<MbxDataTableWidget> createState() => _MbxDataTableWidgetState();
}

class _MbxDataTableWidgetState extends State<MbxDataTableWidget> {
  String? hoveredRowId;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Loading State
    if (widget.isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    // Empty State
    if (widget.rows.isEmpty) {
      return Expanded(
        child: widget.emptyWidget ?? _buildEmptyState(isDarkMode),
      );
    }

    // Data Table
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final minTableWidth = widget.minTableWidth ?? _calculateMinWidth();
          final needsScroll = minTableWidth > constraints.maxWidth;

          Widget dataTable = _buildDataTable(isDarkMode);

          if (needsScroll) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: dataTable,
              ),
            );
          } else {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Align(alignment: Alignment.topLeft, child: dataTable),
            );
          }
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.emptyIcon ?? Icons.inbox_outlined,
            size: 64,
            color: isDarkMode ? const Color(0xFF808080) : Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            widget.emptyTitle ?? 'No data found',
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode ? const Color(0xFF808080) : Colors.grey,
            ),
          ),
          if (widget.emptySubtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.emptySubtitle!,
              style: TextStyle(
                color: isDarkMode ? const Color(0xFF808080) : Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDataTable(bool isDarkMode) {
    return DataTable(
      columnSpacing: 16,
      dataRowMinHeight: 56,
      dataRowMaxHeight: 72,
      headingRowColor: WidgetStateProperty.all(
        isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[100],
      ),
      dataTextStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      headingTextStyle: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontWeight: FontWeight.bold,
      ),
      sortColumnIndex: widget.sortColumn != null
          ? widget.columns.indexWhere((col) => col.sortKey == widget.sortColumn)
          : null,
      sortAscending: widget.sortAscending,
      columns: [
        // Regular columns
        ...widget.columns.map((column) {
          return DataColumn(
            label: Align(
              alignment: _getAlignment(column.textAlign),
              child: Text(
                column.label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            onSort: column.sortable && widget.enableSorting
                ? (columnIndex, ascending) {
                    if (widget.onSort != null && column.sortKey != null) {
                      widget.onSort!(column.sortKey!, ascending);
                    }
                  }
                : null,
          );
        }),
        // Actions column if any row has actions
        if (widget.rows.any((row) => row.actions.isNotEmpty))
          const DataColumn(
            label: Text(
              'Actions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
      ],
      rows: widget.rows.map((row) => _buildDataRow(row, isDarkMode)).toList(),
    );
  }

  DataRow _buildDataRow(MbxDataRow row, bool isDarkMode) {
    final isHovered = hoveredRowId == row.id;
    final isSelected = widget.selectedRows.contains(row.id) || row.isSelected;

    Color? rowColor;
    if (row.highlightColor != null) {
      rowColor = row.highlightColor;
    } else if (isSelected) {
      rowColor = const Color(0xFF1976D2).withOpacity(0.1);
    } else if (isHovered && widget.enableHighlight) {
      rowColor =
          widget.highlightColor ??
          (isDarkMode
              ? Colors.white.withOpacity(0.05)
              : Colors.grey.withOpacity(0.1));
    }

    return DataRow(
      selected: isSelected,
      color: WidgetStateProperty.all(rowColor),
      onSelectChanged: widget.enableSelection
          ? (selected) {
              if (widget.onRowSelected != null) {
                widget.onRowSelected!(row.id);
              }
            }
          : null,
      cells: [
        // Data cells based on columns
        ...widget.columns.map((column) {
          final value = row.data[column.sortKey] ?? '';

          Widget content;
          if (column.customWidget != null) {
            content = column.customWidget!(row.data);
          } else {
            content = Text(
              value.toString(),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              overflow: TextOverflow.ellipsis,
            );
          }

          return DataCell(
            MouseRegion(
              onEnter: (_) => setState(() => hoveredRowId = row.id),
              onExit: (_) => setState(() => hoveredRowId = null),
              child: InkWell(
                onTap: row.onTap,
                child: SizedBox(
                  width: column.width,
                  child: Align(
                    alignment: _getAlignment(column.textAlign),
                    child: content,
                  ),
                ),
              ),
            ),
          );
        }),

        // Actions cell if actions column exists
        if (widget.rows.any((row) => row.actions.isNotEmpty))
          DataCell(
            MouseRegion(
              onEnter: (_) => setState(() => hoveredRowId = row.id),
              onExit: (_) => setState(() => hoveredRowId = null),
              child: SizedBox(
                width: 140,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: row.actions,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Alignment _getAlignment(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.left:
        return Alignment.centerLeft;
      case TextAlign.right:
        return Alignment.centerRight;
      case TextAlign.center:
        return Alignment.center;
      default:
        return Alignment.centerLeft;
    }
  }

  double _calculateMinWidth() {
    double width = 0;
    for (final column in widget.columns) {
      width += column.width ?? 150; // Default column width
    }
    // Add spacing
    width += (widget.columns.length - 1) * 16;
    // Add actions column width if any row has actions
    if (widget.rows.any((row) => row.actions.isNotEmpty)) {
      width += 140;
    }
    return width;
  }
}
