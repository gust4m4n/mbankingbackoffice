import 'package:mbankingbackoffice/preferences/mbx_preferences_vm_users.dart';
import 'package:mbankingbackoffice/theme/widgets/mbx_dark_mode_switch.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxSidebarWidget extends StatefulWidget {
  final String currentRoute;

  const MbxSidebarWidget({super.key, required this.currentRoute});

  @override
  State<MbxSidebarWidget> createState() => _MbxSidebarWidgetState();
}

class _MbxSidebarWidgetState extends State<MbxSidebarWidget> {
  String? hoveredItem;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 280,
      color: isDark
          ? const Color(0xFF333333) // Dark gray untuk dark mode
          : const Color(0xFF1565C0), // Blue untuk light mode
      child: Column(
        children: [
          // Logo/Header
          Container(
            height: 80,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(
                      0xFF404040,
                    ) // Slightly lighter gray untuk header dark mode
                  : const Color(
                      0xFF0D47A1,
                    ), // Darker blue untuk header light mode
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'MBanking\nBackOffice',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
                // Dark Mode Switch
                const MbxDarkModeSwitch(iconSize: 18, showLabel: false),
              ],
            ),
          ),

          // Navigation Menu
          Expanded(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildMenuItem(
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  route: '/home',
                  isActive: widget.currentRoute == '/home',
                ),
                _buildMenuItem(
                  icon: Icons.people_outline,
                  title: 'User Management',
                  route: '/user-management',
                  isActive: widget.currentRoute == '/user-management',
                ),
                _buildMenuItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Transaction Management',
                  route: '/transaction-management',
                  isActive: widget.currentRoute == '/transaction-management',
                ),
                _buildMenuItem(
                  icon: Icons.analytics_outlined,
                  title: 'Reports',
                  onTap: () => _showFeatureNotAvailable('Reports'),
                ),
                _buildMenuItem(
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Admin Management',
                  route: '/admin-management',
                  isActive: widget.currentRoute == '/admin-management',
                ),
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () => _showFeatureNotAvailable('Settings'),
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.white24),
                _buildMenuItem(
                  icon: Icons.logout_outlined,
                  title: 'Logout',
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? route,
    bool isActive = false,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;
    final isHovered = hoveredItem == title;
    final shouldHighlight = isActive || isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredItem = title),
      onExit: (_) => setState(() => hoveredItem = null),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: shouldHighlight
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: isActive
                      ? (isDark
                            ? [
                                const Color(0xFF1976D2).withOpacity(0.8),
                                const Color(0xFF1565C0).withOpacity(0.6),
                              ]
                            : [
                                Colors.white.withOpacity(0.95),
                                Colors.white.withOpacity(0.85),
                              ])
                      : (isDark
                            ? [
                                Colors.white.withOpacity(0.08),
                                Colors.white.withOpacity(0.04),
                              ]
                            : [
                                Colors.white.withOpacity(0.15),
                                Colors.white.withOpacity(0.05),
                              ]),
                )
              : null,
          boxShadow: shouldHighlight
              ? [
                  BoxShadow(
                    color: isActive
                        ? (isDark
                              ? const Color(0xFF1976D2).withOpacity(0.3)
                              : Colors.white.withOpacity(0.3))
                        : (isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.white.withOpacity(0.2)),
                    blurRadius: isActive ? 8 : 4,
                    offset: Offset(0, isActive ? 2 : 1),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap:
                onTap ??
                () {
                  if (route != null && route != widget.currentRoute) {
                    Get.offNamed(route);
                  }
                },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: shouldHighlight
                          ? (isActive
                                ? (isDark
                                      ? Colors.white.withOpacity(0.15)
                                      : const Color(
                                          0xFF1976D2,
                                        ).withOpacity(0.1))
                                : (isDark
                                      ? Colors.white.withOpacity(0.08)
                                      : Colors.white.withOpacity(0.1)))
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: shouldHighlight
                          ? (isActive
                                ? (isDark
                                      ? Colors.white
                                      : const Color(0xFF1976D2))
                                : (isDark
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.white.withOpacity(0.9)))
                          : Colors.white70,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: shouldHighlight
                            ? (isActive
                                  ? (isDark
                                        ? Colors.white
                                        : const Color(0xFF1976D2))
                                  : (isDark
                                        ? Colors.white.withOpacity(0.9)
                                        : Colors.white.withOpacity(0.9)))
                            : Colors.white70,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : (isHovered ? FontWeight.w600 : FontWeight.w500),
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  if (isActive)
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white : const Color(0xFF1976D2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  if (isHovered && !isActive)
                    Icon(
                      Icons.chevron_right,
                      color: isDark
                          ? Colors.white.withOpacity(0.7)
                          : Colors.white.withOpacity(0.7),
                      size: 18,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showFeatureNotAvailable(String featureName) {
    ToastX.showSuccess(msg: '$featureName akan segera tersedia');
  }

  void _logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              Get.loading();

              // Clear stored token
              await MbxUserPreferencesVM.setToken('');

              // Navigate to login
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.back();
                Get.offAllNamed('/login');
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
