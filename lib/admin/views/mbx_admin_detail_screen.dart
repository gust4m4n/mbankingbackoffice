import 'package:mbankingbackoffice/admin/models/mbx_admin_model.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxAdminDetailScreen extends StatelessWidget {
  final MbxAdminModel admin;

  const MbxAdminDetailScreen({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return MbxManagementScaffold(
      title: 'Admin Details',
      currentRoute: '/admin-detail',
      showAddButton: false,
      actions: [
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
        ),
      ],
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Profile Header
            _buildProfileHeader(isDarkMode),

            const SizedBox(height: 24),

            // Basic Information Card
            _buildBasicInfoCard(isDarkMode),

            const SizedBox(height: 20),

            // Role & Status Card
            _buildRoleStatusCard(isDarkMode),

            const SizedBox(height: 20),

            // Activity Information Card
            _buildActivityCard(isDarkMode),

            const SizedBox(height: 20),

            // Action Buttons
            _buildActionButtons(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
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
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Basic Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  admin.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  admin.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode
                        ? const Color(0xFFB0B0B0)
                        : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildStatusChip(admin.displayStatus, admin.isActive),
                    const SizedBox(width: 12),
                    _buildRoleChip(admin.displayRole, admin.isSuperAdmin),
                  ],
                ),
              ],
            ),
          ),

          // ID Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xff2a2a2a) : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  'ID',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode
                        ? const Color(0xFFB0B0B0)
                        : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '#${admin.id}',
                  style: TextStyle(
                    fontSize: 16,
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

  Widget _buildBasicInfoCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: isDarkMode
                    ? const Color(0xFF1976D2)
                    : const Color(0xFF1976D2),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Basic Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Full Name',
            admin.name,
            Icons.person_outline,
            isDarkMode,
          ),
          _buildInfoRow(
            'Email Address',
            admin.email,
            Icons.email_outlined,
            isDarkMode,
          ),
          _buildInfoRow(
            'Admin ID',
            '#${admin.id}',
            Icons.badge_outlined,
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleStatusCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security_outlined,
                color: isDarkMode
                    ? const Color(0xFF1976D2)
                    : const Color(0xFF1976D2),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Role & Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildRoleStatusItem(
                  'Role',
                  admin.displayRole,
                  admin.isSuperAdmin ? Colors.purple : const Color(0xFF1976D2),
                  admin.isSuperAdmin ? Icons.star : Icons.admin_panel_settings,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildRoleStatusItem(
                  'Status',
                  admin.displayStatus,
                  admin.isActive ? Colors.green : Colors.red,
                  admin.isActive ? Icons.check_circle : Icons.cancel,
                  isDarkMode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time_outlined,
                color: isDarkMode
                    ? const Color(0xFF1976D2)
                    : const Color(0xFF1976D2),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Activity Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Created At',
            admin.createdAt != null
                ? _formatDateTime(admin.createdAt!)
                : 'Not available',
            Icons.calendar_today_outlined,
            isDarkMode,
          ),
          _buildInfoRow(
            'Last Updated',
            admin.updatedAt != null
                ? _formatDateTime(admin.updatedAt!)
                : 'Not available',
            Icons.update_outlined,
            isDarkMode,
          ),
          _buildInfoRow(
            'Last Login',
            admin.lastLoginAt != null
                ? _formatDateTime(admin.lastLoginAt!)
                : 'Never logged in',
            Icons.login_outlined,
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings_outlined,
                color: isDarkMode
                    ? const Color(0xFF1976D2)
                    : const Color(0xFF1976D2),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildActionButton(
                'Edit Admin',
                Icons.edit_outlined,
                const Color(0xFF1976D2),
                () => _editAdmin(),
              ),
              _buildActionButton(
                admin.isActive ? 'Suspend' : 'Activate',
                admin.isActive ? Icons.block : Icons.check_circle_outline,
                admin.isActive ? Colors.orange : Colors.green,
                () => _toggleStatus(),
              ),
              _buildActionButton(
                'Reset Password',
                Icons.lock_reset_outlined,
                Colors.purple,
                () => _resetPassword(),
              ),
              _buildActionButton(
                'Delete Admin',
                Icons.delete_outline,
                Colors.red,
                () => _deleteAdmin(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    bool isDarkMode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
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
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleStatusItem(
    String label,
    String value,
    Color color,
    IconData icon,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff2a2a2a) : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: isActive ? Colors.green : Colors.red,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildRoleChip(String role, bool isSuperAdmin) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSuperAdmin
            ? Colors.purple.withOpacity(0.1)
            : const Color(0xFF1976D2).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: isSuperAdmin ? Colors.purple : const Color(0xFF1976D2),
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    // Navigate to edit admin screen or show edit dialog
    ToastX.showSuccess(msg: 'Edit admin feature akan segera tersedia');
  }

  void _toggleStatus() {
    // Toggle admin status
    ToastX.showSuccess(msg: 'Toggle status feature akan segera tersedia');
  }

  void _resetPassword() {
    // Reset admin password
    ToastX.showSuccess(msg: 'Reset password feature akan segera tersedia');
  }

  void _deleteAdmin() {
    // Show delete confirmation
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
