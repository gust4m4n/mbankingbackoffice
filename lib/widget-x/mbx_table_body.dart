import 'package:flutter/material.dart';

import 'mbx_data_table_widget.dart';

/// Reusable table body component for data rows
class MbxTableBody extends StatefulWidget {
  final List<MbxDataColumn> columns;
  final List<MbxDataRow> rows;
  final bool enableHighlight;
  final Color? highlightColor;
  final Set<String> selectedRows;
  final bool hasActionsColumn;
  final double actionsColumnWidth;

  const MbxTableBody({
    super.key,
    required this.columns,
    required this.rows,
    this.enableHighlight = true,
    this.highlightColor,
    this.selectedRows = const {},
    this.hasActionsColumn = false,
    this.actionsColumnWidth = 100,
  });

  @override
  State<MbxTableBody> createState() => _MbxTableBodyState();
}

class _MbxTableBodyState extends State<MbxTableBody> {
  String? hoveredRowId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.rows.map((row) => _buildDataRow(row)).toList(),
    );
  }

  Widget _buildDataRow(MbxDataRow row) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
    }

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
      child: GestureDetector(
        onTap: row.onTap,
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
                if (widget.hasActionsColumn)
                  Container(
                    width: widget.actionsColumnWidth,
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
        ), // Container
      ), // GestureDetector
    ); // MouseRegion
  } // _buildDataRow

  int _getColumnFlex(int index) {
    // You can customize flex values based on column requirements
    // For now, using equal flex for all columns
    return 1;
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
}
