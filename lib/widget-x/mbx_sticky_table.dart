import 'package:flutter/material.dart';

import 'mbx_data_table_widget.dart';
import 'mbx_table_body.dart';
import 'mbx_table_header.dart';

/// Complete reusable table component with sticky headers
class MbxStickyTable extends StatefulWidget {
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
  final Set<String> selectedRows;
  final bool enableHighlight;
  final bool enableRowOnlyHighlight;
  final Color? highlightColor;
  final double? minTableWidth;

  const MbxStickyTable({
    super.key,
    required this.columns,
    required this.rows,
    this.isLoading = false,
    this.emptyWidget,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon,
    this.enableSorting = false,
    this.sortColumn,
    this.sortAscending = true,
    this.onSort,
    this.selectedRows = const {},
    this.enableHighlight = false,
    this.enableRowOnlyHighlight = false,
    this.highlightColor,
    this.minTableWidth,
  });

  @override
  State<MbxStickyTable> createState() => _MbxStickyTableState();
}

class _MbxStickyTableState extends State<MbxStickyTable> {
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

    // Data Table with Sticky Header
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final minWidth = widget.minTableWidth ?? _calculateMinWidth();
          final needsScroll = minWidth > constraints.maxWidth;
          final hasActions = widget.rows.any((row) => row.actions.isNotEmpty);
          final actionsColumnTitle = 'ACTIONS';
          final actionsColumnWidth = 100.0;

          Widget dataTable = Column(
            children: [
              // Header
              MbxTableHeader(
                columns: widget.columns,
                enableSorting: widget.enableSorting,
                sortColumn: widget.sortColumn,
                sortAscending: widget.sortAscending,
                onSort: widget.onSort,
                hasActionsColumn: hasActions,
                actionsColumnTitle: actionsColumnTitle,
                actionsColumnWidth: actionsColumnWidth,
              ),
              // Body with scrolling
              Expanded(
                child: SingleChildScrollView(
                  child: MbxTableBody(
                    columns: widget.columns,
                    rows: widget.rows,
                    enableHighlight: widget.enableHighlight,
                    highlightColor: widget.highlightColor,
                    selectedRows: widget.selectedRows,
                    hasActionsColumn: hasActions,
                    actionsColumnWidth: actionsColumnWidth,
                  ),
                ),
              ),
            ],
          );

          if (needsScroll) {
            return SizedBox(width: minWidth, child: dataTable);
          } else {
            return dataTable;
          }
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          widget.emptyIcon ?? Icons.inbox_outlined,
          size: 96,
          color: Colors.grey.shade400,
        ),
        const SizedBox(height: 16),
        Text(
          widget.emptyTitle ?? 'No data found',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (widget.emptySubtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.emptySubtitle!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
          ),
        ],
      ],
    );
  }

  double _calculateMinWidth() {
    double width = 0;
    for (final column in widget.columns) {
      width += column.width ?? 150; // Default column width
    }
    // Add padding between columns
    width += (widget.columns.length - 1) * 16;
    // Add actions column width if exists
    if (widget.rows.any((row) => row.actions.isNotEmpty)) {
      width += 100.0; // actionsColumnWidth
    }
    return width;
  }
}
