import 'package:flutter/material.dart';

class MbxPaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onFirst;
  final VoidCallback? onLast;
  final Function(int)? onPageChanged;

  const MbxPaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    this.onPrevious,
    this.onNext,
    this.onFirst,
    this.onLast,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Desktop-only layout for macOS and web desktop with overflow protection
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 1000; // Compact layout for smaller windows

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff2a2a2a) : Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: isCompact
          ? _buildCompactLayout(context, isDarkMode)
          : _buildFullLayout(context, isDarkMode),
    );
  }

  Widget _buildFullLayout(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        // Left Side: Page Navigation Buttons
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Previous Button
                _buildPageButton(
                  context,
                  icon: Icons.chevron_left,
                  onPressed: currentPage > 1 ? onPrevious : null,
                  tooltip: 'Previous Page',
                ),

                // First Page Button
                if (totalPages > 5) ...[
                  const SizedBox(width: 8),
                  _buildPageButton(
                    context,
                    icon: Icons.first_page,
                    onPressed: currentPage > 1 ? onFirst : null,
                    tooltip: 'First Page',
                  ),
                ],

                const SizedBox(width: 16),

                // Page Numbers
                ..._buildPageNumbers(context),

                const SizedBox(width: 16),

                // Next Button
                _buildPageButton(
                  context,
                  icon: Icons.chevron_right,
                  onPressed: currentPage < totalPages ? onNext : null,
                  tooltip: 'Next Page',
                ),

                // Last Page Button
                if (totalPages > 5) ...[
                  const SizedBox(width: 8),
                  _buildPageButton(
                    context,
                    icon: Icons.last_page,
                    onPressed: currentPage < totalPages ? onLast : null,
                    tooltip: 'Last Page',
                  ),
                ],

                // Jump Page TextField - positioned next to page buttons
                if (totalPages > 3) ...[
                  const SizedBox(width: 16),
                  Text(
                    'Go to:',
                    style: TextStyle(
                      color: isDarkMode
                          ? const Color(0xFFB0B0B0)
                          : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100,
                    height: 36,
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? const Color(0xFFF0F0F0) : null,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? const Color(0xff4a4a4a)
                                : Colors.grey[400]!,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? const Color(0xff4a4a4a)
                                : Colors.grey[400]!,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: Color(0xFF1976D2),
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: isDarkMode
                            ? const Color(0xff161616)
                            : Colors.white,
                        hintText: currentPage.toString(),
                        hintStyle: TextStyle(
                          color: isDarkMode
                              ? const Color(0xFF808080)
                              : Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                      onSubmitted: (value) {
                        final pageNumber = int.tryParse(value);
                        if (pageNumber != null &&
                            pageNumber >= 1 &&
                            pageNumber <= totalPages &&
                            pageNumber != currentPage) {
                          onPageChanged?.call(pageNumber);
                        }
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Right Side: Total Items Info
        Container(
          margin: const EdgeInsets.only(left: 16),
          child: Text(
            'Total: $totalItems items',
            style: TextStyle(
              color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLayout(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        // Left Side: Simplified Navigation
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Previous Button
            _buildPageButton(
              context,
              icon: Icons.chevron_left,
              onPressed: currentPage > 1 ? onPrevious : null,
              tooltip: 'Previous Page',
            ),

            const SizedBox(width: 8),

            // Current Page / Total Pages
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xff161616) : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isDarkMode
                      ? const Color(0xff4a4a4a)
                      : Colors.grey[300]!,
                ),
              ),
              child: Text(
                '$currentPage / $totalPages',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? const Color(0xFFF0F0F0)
                      : Colors.grey[700],
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Next Button
            _buildPageButton(
              context,
              icon: Icons.chevron_right,
              onPressed: currentPage < totalPages ? onNext : null,
              tooltip: 'Next Page',
            ),

            // Go to TextField (compact version)
            if (totalPages > 3) ...[
              const SizedBox(width: 12),
              Text(
                'Go:',
                style: TextStyle(
                  color: isDarkMode
                      ? const Color(0xFFB0B0B0)
                      : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 60,
                height: 32,
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? const Color(0xFFF0F0F0) : null,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: isDarkMode
                            ? const Color(0xff4a4a4a)
                            : Colors.grey[400]!,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: isDarkMode
                            ? const Color(0xff4a4a4a)
                            : Colors.grey[400]!,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(
                        color: Color(0xFF1976D2),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? const Color(0xff161616)
                        : Colors.white,
                    hintText: currentPage.toString(),
                    hintStyle: TextStyle(
                      color: isDarkMode
                          ? const Color(0xFF808080)
                          : Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                  onSubmitted: (value) {
                    final pageNumber = int.tryParse(value);
                    if (pageNumber != null &&
                        pageNumber >= 1 &&
                        pageNumber <= totalPages &&
                        pageNumber != currentPage) {
                      onPageChanged?.call(pageNumber);
                    }
                  },
                ),
              ),
            ],
          ],
        ),

        // Center: Stretchable Space
        const Spacer(),

        // Right Side: Total Items Info (shortened)
        Text(
          'Total: $totalItems',
          style: TextStyle(
            color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPageButton(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onPressed,
    String? tooltip,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: onPressed != null
            ? (isDarkMode ? const Color(0xff3a3a3a) : Colors.white)
            : (isDarkMode ? const Color(0xff2a2a2a) : Colors.grey[200]),
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onPressed,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: onPressed != null
                    ? (isDarkMode ? const Color(0xff4a4a4a) : Colors.grey[300]!)
                    : (isDarkMode
                          ? const Color(0xff2a2a2a)
                          : Colors.grey[200]!),
              ),
            ),
            child: Icon(
              icon,
              size: 18,
              color: onPressed != null
                  ? (isDarkMode ? const Color(0xFFE0E0E0) : Colors.grey[700])
                  : (isDarkMode ? const Color(0xFF606060) : Colors.grey[400]),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageNumbers(BuildContext context) {
    List<Widget> pages = [];
    int start = 1;
    int end = totalPages;

    // Calculate visible page range - limit to maximum 5 pages
    if (totalPages > 5) {
      if (currentPage <= 3) {
        end = 5;
      } else if (currentPage >= totalPages - 2) {
        start = totalPages - 4;
      } else {
        start = currentPage - 2;
        end = currentPage + 2;
      }
    }

    // Add first page and ellipsis if needed
    if (start > 1) {
      pages.add(_buildNumberButton(context, 1));
      if (start > 2) {
        pages.add(_buildEllipsis(context));
      }
    }

    // Add page numbers
    for (int i = start; i <= end; i++) {
      pages.add(_buildNumberButton(context, i));
    }

    // Add ellipsis and last page if needed
    if (end < totalPages) {
      if (end < totalPages - 1) {
        pages.add(_buildEllipsis(context));
      }
      pages.add(_buildNumberButton(context, totalPages));
    }

    return pages;
  }

  Widget _buildNumberButton(BuildContext context, int pageNumber) {
    final isActive = pageNumber == currentPage;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: isActive
            ? const Color(0xFF1976D2)
            : (isDarkMode ? const Color(0xff3a3a3a) : Colors.white),
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: pageNumber != currentPage
              ? () => onPageChanged?.call(pageNumber)
              : null,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isActive
                    ? const Color(0xFF1976D2)
                    : (isDarkMode
                          ? const Color(0xff4a4a4a)
                          : Colors.grey[300]!),
              ),
            ),
            child: Center(
              child: Text(
                pageNumber.toString(),
                style: TextStyle(
                  color: isActive
                      ? Colors.white
                      : (isDarkMode
                            ? const Color(0xFFE0E0E0)
                            : Colors.grey[700]),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        '...',
        style: TextStyle(
          color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey[600],
          fontSize: 14,
        ),
      ),
    );
  }
}
