import 'package:mbankingbackoffice/user/controllers/mbx_user_controller.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxUserSearchFilterWidget extends StatelessWidget {
  final MbxUserController controller;

  const MbxUserSearchFilterWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1a1a1a) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? const Color(0xff2a2a2a) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search Input
          Expanded(
            child: TextFormField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText:
                    'Search users by name or phone... (Press Enter to search)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: isDarkMode
                    ? const Color(0xff2a2a2a)
                    : Colors.grey[50],
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  controller.searchUsers();
                }
              },
              onFieldSubmitted: (value) => controller.searchUsers(),
            ),
          ),
          const SizedBox(width: 12),

          // Clear Button
          Obx(() {
            return controller.isFilterActive.value
                ? TextButton.icon(
                    onPressed: controller.clearSearchAndFilters,
                    icon: const Icon(Icons.clear, size: 18),
                    label: const Text('Clear'),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
