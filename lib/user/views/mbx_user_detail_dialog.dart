import 'package:mbankingbackoffice/user/models/mbx_user_model.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxUserDetailDialog extends StatelessWidget {
  final MbxUserModel user;

  const MbxUserDetailDialog({super.key, required this.user});

  static void show(BuildContext context, MbxUserModel user) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => MbxUserDetailDialog(user: user),
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
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Profile Header
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
      ),
      child: Row(
        children: [
          Text(
            'User Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.of(Get.context!).pop(),
            icon: Icon(
              Icons.close_rounded,
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
            style: IconButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.white10 : Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF1976D2), const Color(0xFF1565C0)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1976D2).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.maskedAccountNumber,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: user.isActive
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: user.isActive ? Colors.green : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    user.displayStatus,
                    style: TextStyle(
                      color: user.isActive ? Colors.white : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Balance
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Balance',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                user.formattedBalance,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 16),

        // Grid layout for info cards
        LayoutBuilder(
          builder: (context, constraints) {
            // Use 2 columns on wider screens, 1 column on narrow screens
            bool useTwoColumns = constraints.maxWidth > 500;

            if (useTwoColumns) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Full Name',
                          user.name,
                          Icons.person,
                          isDarkMode,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          'Phone Number',
                          user.phone,
                          Icons.phone,
                          isDarkMode,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Mother Name',
                          user.motherName,
                          Icons.family_restroom,
                          isDarkMode,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          'PIN ATM',
                          user.maskedPinAtm,
                          Icons.lock,
                          isDarkMode,
                        ),
                      ),
                    ],
                  ),
                  if (user.createdAt != null || user.updatedAt != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (user.createdAt != null)
                          Expanded(
                            child: _buildInfoCard(
                              'Created At',
                              user.createdAt!,
                              Icons.calendar_today,
                              isDarkMode,
                            ),
                          ),
                        if (user.createdAt != null && user.updatedAt != null)
                          const SizedBox(width: 12),
                        if (user.updatedAt != null)
                          Expanded(
                            child: _buildInfoCard(
                              'Updated At',
                              user.updatedAt!,
                              Icons.update,
                              isDarkMode,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              );
            } else {
              return Column(
                children: [
                  _buildInfoCard(
                    'Full Name',
                    user.name,
                    Icons.person,
                    isDarkMode,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    'Phone Number',
                    user.phone,
                    Icons.phone,
                    isDarkMode,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    'Mother Name',
                    user.motherName,
                    Icons.family_restroom,
                    isDarkMode,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    'PIN ATM',
                    user.maskedPinAtm,
                    Icons.lock,
                    isDarkMode,
                  ),
                  if (user.createdAt != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'Created At',
                      user.createdAt!,
                      Icons.calendar_today,
                      isDarkMode,
                    ),
                  ],
                  if (user.updatedAt != null) ...[
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      'Updated At',
                      user.updatedAt!,
                      Icons.update,
                      isDarkMode,
                    ),
                  ],
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
    IconData icon,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xff2a2a2a) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.white10 : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: const Color(0xFF1976D2)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return Row(
      children: [
        const Spacer(),

        // Edit User Button (disabled for now)
        ElevatedButton.icon(
          onPressed: () =>
              ToastX.showSuccess(msg: 'Edit user feature akan segera tersedia'),
          icon: const Icon(Icons.edit, size: 18),
          label: const Text('Edit User'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDarkMode
                ? const Color(0xff3a3a3a)
                : Colors.grey[100],
            foregroundColor: isDarkMode ? Colors.white70 : Colors.grey[700],
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Close Button
        ElevatedButton.icon(
          onPressed: () => Navigator.of(Get.context!).pop(),
          icon: const Icon(Icons.close, size: 18),
          label: const Text('Close'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
