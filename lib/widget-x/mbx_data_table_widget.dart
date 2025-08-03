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
    this.enableSorting = true,
    this.sortColumn,
    this.sortAscending = true,
    this.onSort,
    this.onRowSelected,
    this.selectedRows = const {},
    this.enableSelection = false,
    this.enableHighlight = true,
    this.enableRowOnlyHighlight = false,
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

    // Data Table with Sticky Header
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final minTableWidth = widget.minTableWidth ?? _calculateMinWidth();
          final needsScroll = minTableWidth > constraints.maxWidth;

          Widget dataTable = _buildStickyHeaderTable(isDarkMode);

          if (needsScroll) {
            return SizedBox(width: minTableWidth, child: dataTable);
          } else {
            return dataTable;
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

  Widget _buildStickyHeaderTable(bool isDarkMode) {
    print(
      '[DEBUG BUILD] Building Sticky Header DataTable with ${widget.rows.length} rows, enableHighlight: ${widget.enableHighlight}',
    );

    return Column(
      children: [
        // Fixed Header
        Container(
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
          child: _buildHeaderRow(isDarkMode),
        ),

        // Scrollable Data Rows
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            child: _buildDataRowsOnly(isDarkMode),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRow(bool isDarkMode) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Regular column headers
          ...widget.columns.asMap().entries.map((entry) {
            final index = entry.key;
            final column = entry.value;

            return Expanded(
              flex: _getColumnFlex(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
                    if (column.sortable && widget.enableSorting) ...[
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          if (widget.onSort != null && column.sortKey != null) {
                            final isCurrentColumn =
                                widget.sortColumn == column.sortKey;
                            final newAscending = isCurrentColumn
                                ? !widget.sortAscending
                                : true;
                            widget.onSort!(column.sortKey!, newAscending);
                          }
                        },
                        child: Icon(
                          widget.sortColumn == column.sortKey
                              ? (widget.sortAscending
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
              ),
            );
          }),

          // Actions column header if any row has actions
          if (widget.rows.any((row) => row.actions.isNotEmpty))
            Container(
              width: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'ACTIONS',
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
    );
  }

  Widget _buildDataRowsOnly(bool isDarkMode) {
    return Column(
      children: widget.rows
          .map((row) => _buildCustomDataRow(row, isDarkMode))
          .toList(),
    );
  }

  Widget _buildCustomDataRow(MbxDataRow row, bool isDarkMode) {
    print(
      '[DEBUG ROW] Building row ${row.id} - hovered: ${hoveredRowId == row.id}, enableHighlight: ${widget.enableHighlight}',
    );

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
              ? Colors.white.withOpacity(0.15)
              : Colors.grey.withOpacity(0.25));
      print(
        '[DEBUG HIGHLIGHT] Row ${row.id} highlighted with color: $rowColor (isDarkMode: $isDarkMode, isHovered: $isHovered, enableHighlight: ${widget.enableHighlight})',
      );
    }

    print('[DEBUG COLOR] Row ${row.id} final color: $rowColor');

    return MouseRegion(
      onEnter: widget.enableHighlight
          ? (_) {
              setState(() {
                hoveredRowId = row.id;
              });
            }
          : null,
      onExit: widget.enableHighlight
          ? (_) {
              setState(() {
                hoveredRowId = null;
              });
            }
          : null,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 35, maxHeight: 44),
        color: rowColor,
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Data cells based on columns
              ...widget.columns.asMap().entries.map((entry) {
                final index = entry.key;
                final column = entry.value;
                final value = row.data[column.sortKey] ?? '';

                Widget content;
                if (column.customWidget != null) {
                  content = column.customWidget!(row.data);
                } else {
                  content = Text(
                    value.toString(),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: column.textAlign,
                  );
                }

                return Expanded(
                  flex: _getColumnFlex(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Align(
                      alignment: _getAlignment(column.textAlign),
                      child: content,
                    ),
                  ),
                );
              }),

              // Actions cell
              if (widget.rows.any((row) => row.actions.isNotEmpty))
                Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: row.actions.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: row.actions.map((action) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: action,
                            );
                          }).toList(),
                        )
                      : const SizedBox.shrink(),
                ),
            ],
          ),
        ),
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

  Alignment _getAlignment(TextAlign? textAlign) {
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
