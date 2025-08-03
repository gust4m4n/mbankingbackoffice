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
      children: [
        // Title - Allow it to shrink if needed
        Flexible(
          flex: 1,
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

        const SizedBox(width: 16),

        // Search Input - Flexible width with constraints
        Flexible(
          flex: 2,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 200, maxWidth: 400),
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
                  horizontal: 12,
                  vertical: 8,
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
        ),

        const SizedBox(width: 12),

        // Clear Button (compact)
        Obx(() {
          return controller.isFilterActive.value
              ? IconButton(
                  onPressed: controller.clearSearchAndFilters,
                  icon: const Icon(Icons.clear, size: 18),
                  tooltip: 'Clear search',
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
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
      ],
    );
  }
}
