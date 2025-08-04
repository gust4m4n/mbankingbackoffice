import 'package:flutter/material.dart';

/// Reusable management header component with title and optional search
class MbxManagementHeader extends StatelessWidget {
  final String title;
  final bool showSearch;
  final TextEditingController? searchController;
  final VoidCallback? onSearch;
  final VoidCallback? onClearSearch;
  final String searchHint;
  final bool isFilterActive;
  final Widget? customActions;
  final Widget? customFilters;

  const MbxManagementHeader({
    super.key,
    required this.title,
    this.showSearch = false,
    this.searchController,
    this.onSearch,
    this.onClearSearch,
    this.searchHint = 'Search...',
    this.isFilterActive = false,
    this.customActions,
    this.customFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main header row with title and search/actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title - Allow it to shrink if needed
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Actions section (search + custom actions)
              if (showSearch || customActions != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search widget
                    if (showSearch) ...[
                      MbxSearchWidget(
                        controller: searchController,
                        onSearch: onSearch,
                        onClear: onClearSearch,
                        hint: searchHint,
                        isFilterActive: isFilterActive,
                      ),
                      if (customActions != null) const SizedBox(width: 8),
                    ],

                    // Custom actions
                    if (customActions != null) customActions!,
                  ],
                ),
            ],
          ),

          // Custom filters row (if provided)
          if (customFilters != null) ...[
            const SizedBox(height: 12),
            customFilters!,
          ],
        ],
      ),
    );
  }
}

/// Reusable search widget component
class MbxSearchWidget extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSearch;
  final VoidCallback? onClear;
  final String hint;
  final bool isFilterActive;
  final double minWidth;
  final double maxWidth;

  const MbxSearchWidget({
    super.key,
    this.controller,
    this.onSearch,
    this.onClear,
    this.hint = 'Search...',
    this.isFilterActive = false,
    this.minWidth = 125,
    this.maxWidth = 188,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          prefixIcon: const Icon(Icons.search, size: 20),
          // Clear button inside text field
          suffixIcon: onClear != null && isFilterActive
              ? IconButton(
                  onPressed: onClear,
                  icon: Icon(
                    Icons.clear,
                    size: 18,
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[500],
                  ),
                  tooltip: 'Clear search',
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1976D2)),
          ),
          filled: true,
          fillColor: isDarkMode ? const Color(0xff2a2a2a) : Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          isDense: true,
        ),
        style: const TextStyle(fontSize: 14),
        onChanged: (value) {
          if (value.isEmpty && onClear != null) {
            onClear!();
          }
        },
        onFieldSubmitted: (value) {
          if (onSearch != null) {
            onSearch!();
          }
        },
      ),
    );
  }
}
