import 'package:flutter/material.dart';

import 'mbx_sticky_table.dart';

/// Column configuration for the data table
class MbxDataColumn {
  final String label;
  final int flex;
  final bool sortable;
  final String key;
  final String? sortKey;
  final double? width;
  final TextAlign textAlign;
  final Widget Function(dynamic data)? customWidget;

  const MbxDataColumn({
    required this.label,
    this.flex = 1,
    this.sortable = false,
    required this.key,
    this.sortKey,
    this.width,
    this.textAlign = TextAlign.left,
    this.customWidget,
  });
}

/// Cell data for the data table
class MbxDataCell {
  final dynamic value;
  final Widget? widget;

  const MbxDataCell({this.value, this.widget});
}

/// Row data for the data table
class MbxDataRow {
  final String key;
  final String id;
  final Map<String, MbxDataCell> cells;
  final Map<String, dynamic> data;
  final List<Widget> actions;
  final bool isSelected;
  final Color? highlightColor;
  final VoidCallback? onTap;

  const MbxDataRow({
    required this.key,
    required this.id,
    required this.cells,
    required this.data,
    this.actions = const [],
    this.isSelected = false,
    this.highlightColor,
    this.onTap,
  });
}

/// Reusable data table widget with sticky headers
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
  final Set<String> selectedRows;
  final bool enableHighlight;
  final bool enableRowOnlyHighlight;
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
  State<MbxDataTableWidget> createState() => _MbxDataTableWidgetState();
}

class _MbxDataTableWidgetState extends State<MbxDataTableWidget> {
  @override
  Widget build(BuildContext context) {
    return MbxStickyTable(
      columns: widget.columns,
      rows: widget.rows,
      isLoading: widget.isLoading,
      emptyWidget: widget.emptyWidget,
      emptyTitle: widget.emptyTitle,
      emptySubtitle: widget.emptySubtitle,
      emptyIcon: widget.emptyIcon,
      enableSorting: widget.enableSorting,
      sortColumn: widget.sortColumn,
      sortAscending: widget.sortAscending,
      onSort: widget.onSort,
      selectedRows: widget.selectedRows,
      enableHighlight: widget.enableHighlight,
      enableRowOnlyHighlight: widget.enableRowOnlyHighlight,
      highlightColor: widget.highlightColor,
      minTableWidth: widget.minTableWidth,
    );
  }
}
