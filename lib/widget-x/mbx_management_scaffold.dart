import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxManagementScaffold extends StatelessWidget {
  final String title;
  final String currentRoute;
  final Widget child;
  final List<Widget>? actions;
  final bool showAddButton;
  final VoidCallback? onAddPressed;
  final VoidCallback? onRefreshPressed;
  final Widget? customHeaderWidget;

  const MbxManagementScaffold({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.child,
    this.actions,
    this.showAddButton = false,
    this.onAddPressed,
    this.onRefreshPressed,
    this.customHeaderWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 700;

          return Row(
            children: [
              // Sidebar - hanya tampil di desktop
              if (!isMobile) MbxSidebarWidget(currentRoute: currentRoute),

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
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.3)
                                : Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Mobile menu button
                          if (isMobile) ...[
                            IconButton(
                              onPressed: _showMobileDrawer,
                              icon: const Icon(Icons.menu),
                            ),
                            const SizedBox(width: 8),
                          ],

                          // Title and custom header widget
                          if (customHeaderWidget != null)
                            Expanded(child: customHeaderWidget!)
                          else
                            Expanded(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: isMobile ? 18 : 24,
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

                          // Add button
                          if (showAddButton &&
                              !isMobile &&
                              onAddPressed != null) ...[
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
                          ] else if (showAddButton &&
                              isMobile &&
                              onAddPressed != null) ...[
                            IconButton(
                              onPressed: onAddPressed,
                              icon: const Icon(Icons.add),
                              tooltip: 'Add',
                            ),
                            const SizedBox(width: 8),
                          ],

                          // Refresh button
                          if (onRefreshPressed != null)
                            IconButton(
                              onPressed: onRefreshPressed,
                              icon: const Icon(Icons.refresh),
                              tooltip: 'Refresh',
                            ),
                        ],
                      ),
                    ),

                    // Content
                    Expanded(child: child),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMobileDrawer() {
    Get.dialog(
      Dialog(
        alignment: Alignment.centerLeft,
        insetPadding: EdgeInsets.zero,
        child: SizedBox(
          width: 280,
          height: double.infinity,
          child: MbxSidebarWidget(currentRoute: currentRoute),
        ),
      ),
    );
  }
}
