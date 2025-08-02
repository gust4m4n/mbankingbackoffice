import 'package:mbankingbackoffice/admin/models/mbx_admin_model.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxAdminDetailDialog extends StatelessWidget {
  final MbxAdminModel admin;

  const MbxAdminDetailDialog({super.key, required this.admin});

  static void show(BuildContext context, MbxAdminModel admin) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => MbxAdminDetailDialog(admin: admin),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width > 800 ? 700.0 : screenSize.width * 0.9;
    final dialogHeight = screenSize.height * 0.85;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.5 : 0.15),
              blurRadius: 25,
              offset: const Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with close button
            _buildHeader(isDarkMode),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Admin Profile Header
                    _buildProfileHeader(isDarkMode),

                    const SizedBox(height: 20),

                    // Information Cards in a more compact layout
                    _buildInfoSection(isDarkMode),

                    const SizedBox(height: 20),

                    // Action Buttons
                    _buildActionButtons(isDarkMode),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1a1a1a) : const Color(0xFFF8F9FA),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? const Color(0xff2a2a2a)
                : const Color(0xFFE5E7EB),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Color(0xFF1976D2),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  'View and manage admin information',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode
                        ? const Color(0xFFB0B0B0)
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.close,
              color: isDarkMode ? Colors.white : Colors.black54,
            ),
            tooltip: 'Close',
            splashRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1976D2).withOpacity(0.1),
            const Color(0xFF1976D2).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1976D2).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar with gradient
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF1976D2),
                  const Color(0xFF1976D2).withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1976D2).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                admin.name.isNotEmpty ? admin.name[0].toUpperCase() : 'A',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Basic Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  admin.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  admin.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode
                        ? const Color(0xFFB0B0B0)
                        : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildCompactChip(admin.displayStatus, admin.isActive),
                    const SizedBox(width: 8),
                    _buildCompactChip(
                      admin.displayRole,
                      admin.isSuperAdmin,
                      isRole: true,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ID Badge
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xff2a2a2a) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode
                    ? const Color(0xff3a3a3a)
                    : const Color(0xFFE5E7EB),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ID',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDarkMode
                        ? const Color(0xFFB0B0B0)
                        : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '#${admin.id}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff1a1a1a) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? const Color(0xff2a2a2a) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          // Basic Information Section
          _buildInfoRow(
            'Full Name',
            admin.name,
            Icons.person_outline,
            isDarkMode,
            isFirst: true,
          ),
          _buildDivider(isDarkMode),
          _buildInfoRow(
            'Email Address',
            admin.email,
            Icons.email_outlined,
            isDarkMode,
          ),
          _buildDivider(isDarkMode),
          _buildInfoRow(
            'Admin ID',
            '#${admin.id}',
            Icons.badge_outlined,
            isDarkMode,
          ),
          _buildDivider(isDarkMode),

          // Role & Status Section
          _buildRoleStatusRow(isDarkMode),
          _buildDivider(isDarkMode),

          // Activity Information
          _buildInfoRow(
            'Created At',
            admin.createdAt != null
                ? _formatDateTime(admin.createdAt!)
                : 'Not available',
            Icons.calendar_today_outlined,
            isDarkMode,
          ),
          _buildDivider(isDarkMode),
          _buildInfoRow(
            'Last Updated',
            admin.updatedAt != null
                ? _formatDateTime(admin.updatedAt!)
                : 'Not available',
            Icons.update_outlined,
            isDarkMode,
          ),
          _buildDivider(isDarkMode),
          _buildInfoRow(
            'Last Login',
            admin.lastLoginAt != null
                ? _formatDateTime(admin.lastLoginAt!)
                : 'Never logged in',
            Icons.login_outlined,
            isDarkMode,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    bool isDarkMode, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF1976D2)),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleStatusRow(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.security_outlined,
              size: 16,
              color: Color(0xFF1976D2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              'Role & Status',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCompactChip(
                  admin.displayRole,
                  admin.isSuperAdmin,
                  isRole: true,
                ),
                const SizedBox(width: 8),
                _buildCompactChip(admin.displayStatus, admin.isActive),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDarkMode ? const Color(0xff2a2a2a) : const Color(0xFFE5E7EB),
      indent: 56,
      endIndent: 16,
    );
  }

  Widget _buildCompactChip(String text, bool isActive, {bool isRole = false}) {
    Color color;
    if (isRole) {
      color = isActive ? Colors.purple : const Color(0xFF1976D2);
    } else {
      color = isActive ? Colors.green : Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.settings_outlined,
              color: isDarkMode
                  ? const Color(0xFF1976D2)
                  : const Color(0xFF1976D2),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildCompactActionButton(
              'Edit',
              Icons.edit_outlined,
              const Color(0xFF1976D2),
              () => _editAdmin(),
            ),
            _buildCompactActionButton(
              admin.isActive ? 'Suspend' : 'Activate',
              admin.isActive ? Icons.block : Icons.check_circle_outline,
              admin.isActive ? Colors.orange : Colors.green,
              () => _toggleStatus(),
            ),
            _buildCompactActionButton(
              'Reset Password',
              Icons.lock_reset_outlined,
              Colors.purple,
              () => _resetPassword(),
            ),
            _buildCompactActionButton(
              'Delete',
              Icons.delete_outline,
              Colors.red,
              () => _deleteAdmin(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompactActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
        minimumSize: const Size(0, 36),
      ),
    );
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }

  void _editAdmin() {
    Get.back();
    ToastX.showSuccess(msg: 'Edit admin feature akan segera tersedia');
  }

  void _toggleStatus() {
    Get.back();
    ToastX.showSuccess(msg: 'Toggle status feature akan segera tersedia');
  }

  void _resetPassword() {
    Get.back();
    ToastX.showSuccess(msg: 'Reset password feature akan segera tersedia');
  }

  void _deleteAdmin() {
    Get.back();
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete admin "${admin.name}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              ToastX.showSuccess(
                msg: 'Delete admin feature akan segera tersedia',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
