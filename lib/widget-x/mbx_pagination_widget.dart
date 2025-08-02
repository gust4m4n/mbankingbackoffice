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
    // Always show pagination info, but disable controls if only 1 page
    final isMobile = MediaQuery.of(context).size.width < 768;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final startItem = ((currentPage - 1) * itemsPerPage) + 1;
    final endItem = (currentPage * itemsPerPage > totalItems)
        ? totalItems
        : currentPage * itemsPerPage;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff2a2a2a) : Colors.grey[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          // Info Row
          if (!isMobile) ...[
            Row(
              children: [
                Text(
                  'Showing $startItem-$endItem of $totalItems items',
                  style: TextStyle(
                    color: isDarkMode
                        ? const Color(0xFFB0B0B0)
                        : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  'Page $currentPage of $totalPages',
                  style: TextStyle(
                    color: isDarkMode
                        ? const Color(0xFFB0B0B0)
                        : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],

          // Navigation Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First Page Button
              if (!isMobile && totalPages > 5)
                _buildPageButton(
                  context,
                  icon: Icons.first_page,
                  onPressed: currentPage > 1 ? onFirst : null,
                  tooltip: 'First Page',
                ),

              // Previous Button
              _buildPageButton(
                context,
                icon: Icons.chevron_left,
                onPressed: currentPage > 1 ? onPrevious : null,
                tooltip: 'Previous Page',
              ),

              const SizedBox(width: 8),

              // Page Numbers (desktop only)
              if (!isMobile) ..._buildPageNumbers(context),

              // Mobile page info
              if (isMobile) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xff161616) : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isDarkMode
                          ? const Color(0xff2a2a2a)
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    '$currentPage / $totalPages',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: isDarkMode ? const Color(0xFFF0F0F0) : null,
                    ),
                  ),
                ),
              ],

              const SizedBox(width: 8),

              // Next Button
              _buildPageButton(
                context,
                icon: Icons.chevron_right,
                onPressed: currentPage < totalPages ? onNext : null,
                tooltip: 'Next Page',
              ),

              // Last Page Button
              if (!isMobile && totalPages > 5)
                _buildPageButton(
                  context,
                  icon: Icons.last_page,
                  onPressed: currentPage < totalPages ? onLast : null,
                  tooltip: 'Last Page',
                ),
            ],
          ),

          // Mobile info
          if (isMobile) ...[
            const SizedBox(height: 8),
            Text(
              'Showing $startItem-$endItem of $totalItems items',
              style: TextStyle(
                color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
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
            ? (isDarkMode ? const Color(0xff161616) : Colors.white)
            : (isDarkMode ? const Color(0xff1a1a1a) : Colors.grey[200]),
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
                    ? (isDarkMode ? const Color(0xff2a2a2a) : Colors.grey[300]!)
                    : (isDarkMode
                          ? const Color(0xff1a1a1a)
                          : Colors.grey[200]!),
              ),
            ),
            child: Icon(
              icon,
              size: 18,
              color: onPressed != null
                  ? (isDarkMode ? const Color(0xFFF0F0F0) : Colors.grey[700])
                  : (isDarkMode ? const Color(0xFF404040) : Colors.grey[400]),
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

    // Calculate visible page range
    if (totalPages > 7) {
      if (currentPage <= 4) {
        end = 7;
      } else if (currentPage >= totalPages - 3) {
        start = totalPages - 6;
      } else {
        start = currentPage - 3;
        end = currentPage + 3;
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
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: isActive
            ? const Color(0xFF1976D2)
            : (isDarkMode ? const Color(0xff161616) : Colors.white),
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
                          ? const Color(0xff2a2a2a)
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
                            ? const Color(0xFFF0F0F0)
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
