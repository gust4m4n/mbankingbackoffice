import 'package:mbankingbackoffice/user/controllers/mbx_user_controller.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxUserHeaderSearchWidget extends StatelessWidget {
  final MbxUserController controller;
  final String title;

  const MbxUserHeaderSearchWidget({
    super.key,
    required this.controller,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
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

        // Search controls on the right - no spacer
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search Input - positioned on the right
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 125, maxWidth: 188),
              child: TextFormField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  prefixIcon: const Icon(Icons.search, size: 20),
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
                  fillColor: isDarkMode
                      ? const Color(0xff2a2a2a)
                      : Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  isDense: true,
                ),
                style: const TextStyle(fontSize: 14),
                onChanged: (value) {
                  if (value.isEmpty) {
                    controller.searchUsers();
                  }
                },
                onFieldSubmitted: (value) => controller.searchUsers(),
              ),
            ),

            // Clear Button (compact) - small margin for right alignment
            Container(
              margin: const EdgeInsets.only(left: 4),
              child: Obx(() {
                return controller.isFilterActive.value
                    ? IconButton(
                        onPressed: controller.clearSearchAndFilters,
                        icon: const Icon(Icons.clear, size: 16),
                        tooltip: 'Clear search',
                        padding: const EdgeInsets.all(6),
                        constraints: const BoxConstraints(
                          minWidth: 28,
                          minHeight: 28,
                        ),
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor: Colors.red.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              }),
            ),
          ],
        ),
      ],
    );
  }
}
