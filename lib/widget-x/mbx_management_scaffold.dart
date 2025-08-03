import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxManagementScaffold extends StatelessWidget {
  final String title;
  final String currentRoute;
  final Widget child;
  final List<Widget>? actions;
  final bool showAddButton;
  final VoidCallback? onAddPressed;
  final Widget? customHeaderWidget;

  const MbxManagementScaffold({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.child,
    this.actions,
    this.showAddButton = false,
    this.onAddPressed,
    this.customHeaderWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          // Sidebar - always visible on desktop
          MbxSidebarWidget(currentRoute: currentRoute),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Title and custom header widget
                      if (customHeaderWidget != null)
                        Expanded(child: customHeaderWidget!)
                      else
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).appBarTheme.foregroundColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      // Actions
                      if (actions != null) ...actions!,

                      // Add button - always shown if enabled
                      if (showAddButton && onAddPressed != null) ...[
                        ElevatedButton.icon(
                          onPressed: onAddPressed,
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text('Add'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF1565C0,
                            ), // Same blue as login screen
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ],
                  ),
                ),

                // Content
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
