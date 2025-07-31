import 'package:mbankingbackoffice/admin/models/mbx_admin_model.dart';
import 'package:mbankingbackoffice/admin/services/mbx_admin_api_service.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxAdminController extends GetxController {
  // Loading states
  var isLoading = false.obs;
  var isSubmitting = false.obs;

  // Admin list
  var admins = <MbxAdminModel>[].obs;
  var totalAdmins = 0.obs;
  var currentPage = 1.obs;
  var perPage = 10.obs;
  var totalPages = 1.obs;

  // Selected admin for view/edit/delete
  MbxAdminModel? selectedAdmin;

  // Form controllers for create/edit
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form focus nodes
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  // Form validation errors
  var nameError = '';
  var emailError = '';
  var passwordError = '';
  var confirmPasswordError = '';

  // Form states
  var selectedRole = 'admin';
  var selectedStatus = 'active';
  var isEdit = false;

  // Available options
  final roles = ['admin', 'super_admin'];
  final statuses = ['active', 'inactive', 'suspended'];

  @override
  void onInit() {
    super.onInit();
    loadAdmins();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }

  /// Load admins list
  Future<void> loadAdmins({int page = 1}) async {
    try {
      isLoading.value = true;
      currentPage.value = page;

      final response = await MbxAdminApiService.getAdmins(
        page: page,
        perPage: perPage.value,
      );

      if (response.statusCode == 200) {
        final data = response.jason.mapValue;
        final adminListResponse = MbxAdminApiService.parseAdminListResponse(
          data['data'],
        );

        admins.value = adminListResponse.admins;
        totalAdmins.value = adminListResponse.total;
        totalPages.value = adminListResponse.totalPages;

        print('Loaded ${admins.length} admins');
      } else {
        ToastX.showError(msg: 'Failed to load admins: ${response.message}');
      }
    } catch (e) {
      print('Error loading admins: $e');
      ToastX.showError(msg: 'Error loading admins: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// View admin details
  void viewAdmin(MbxAdminModel admin) {
    selectedAdmin = admin;
    Get.dialog(_buildAdminDetailsDialog(admin), barrierDismissible: true);
  }

  /// Show create admin dialog
  void showCreateAdminDialog() {
    clearForm();
    isEdit = false;
    Get.dialog(_buildCreateEditAdminDialog(), barrierDismissible: false);
  }

  /// Show edit admin dialog
  void showEditAdminDialog(MbxAdminModel admin) {
    selectedAdmin = admin;
    populateForm(admin);
    isEdit = true;
    Get.dialog(_buildCreateEditAdminDialog(), barrierDismissible: false);
  }

  /// Delete admin
  void deleteAdmin(MbxAdminModel admin) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete admin "${admin.name}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => _performDelete(admin),
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

  /// Create or update admin
  Future<void> submitAdmin() async {
    if (!_validateForm()) return;

    try {
      isSubmitting.value = true;

      if (isEdit && selectedAdmin != null) {
        await _updateAdmin();
      } else {
        await _createAdmin();
      }
    } finally {
      isSubmitting.value = false;
    }
  }

  /// Go to next page
  void nextPage() {
    if (currentPage.value < totalPages.value) {
      loadAdmins(page: currentPage.value + 1);
    }
  }

  /// Go to previous page
  void previousPage() {
    if (currentPage.value > 1) {
      loadAdmins(page: currentPage.value - 1);
    }
  }

  /// Go to first page
  void firstPage() {
    if (currentPage.value > 1) {
      loadAdmins(page: 1);
    }
  }

  /// Go to last page
  void lastPage() {
    if (currentPage.value < totalPages.value) {
      loadAdmins(page: totalPages.value);
    }
  }

  /// Go to specific page
  void goToPage(int page) {
    if (page >= 1 && page <= totalPages.value && page != currentPage.value) {
      loadAdmins(page: page);
    }
  }

  /// Refresh admin list
  void refreshAdmins() {
    loadAdmins(page: currentPage.value);
  }

  // Private methods

  Future<void> _createAdmin() async {
    try {
      final request = MbxCreateAdminRequest(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        role: selectedRole,
      );

      final response = await MbxAdminApiService.createAdmin(request);

      if (response.statusCode == 201) {
        ToastX.showSuccess(msg: 'Admin created successfully');
        Get.back(); // Close dialog
        loadAdmins(page: currentPage.value); // Refresh list
      } else {
        ToastX.showError(msg: 'Failed to create admin: ${response.message}');
      }
    } catch (e) {
      print('Error creating admin: $e');
      ToastX.showError(msg: 'Error creating admin: $e');
    }
  }

  Future<void> _updateAdmin() async {
    try {
      final request = MbxUpdateAdminRequest(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        role: selectedRole,
        status: selectedStatus,
      );

      final response = await MbxAdminApiService.updateAdmin(
        selectedAdmin!.id,
        request,
      );

      if (response.statusCode == 200) {
        ToastX.showSuccess(msg: 'Admin updated successfully');
        Get.back(); // Close dialog
        loadAdmins(page: currentPage.value); // Refresh list
      } else {
        ToastX.showError(msg: 'Failed to update admin: ${response.message}');
      }
    } catch (e) {
      print('Error updating admin: $e');
      ToastX.showError(msg: 'Error updating admin: $e');
    }
  }

  Future<void> _performDelete(MbxAdminModel admin) async {
    try {
      Get.back(); // Close confirmation dialog
      Get.loading();

      final response = await MbxAdminApiService.deleteAdmin(admin.id);

      if (response.statusCode == 200) {
        ToastX.showSuccess(msg: 'Admin deleted successfully');
        loadAdmins(page: currentPage.value); // Refresh list
      } else {
        ToastX.showError(msg: 'Failed to delete admin: ${response.message}');
      }
    } catch (e) {
      print('Error deleting admin: $e');
      ToastX.showError(msg: 'Error deleting admin: $e');
    } finally {
      Get.back(); // Close loading
    }
  }

  bool _validateForm() {
    clearErrors();
    bool isValid = true;

    // Validate name
    if (nameController.text.trim().isEmpty) {
      nameError = 'Name is required';
      isValid = false;
    } else if (nameController.text.trim().length < 2) {
      nameError = 'Name must be at least 2 characters';
      isValid = false;
    }

    // Validate email
    if (emailController.text.trim().isEmpty) {
      emailError = 'Email is required';
      isValid = false;
    } else if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(emailController.text.trim())) {
      emailError = 'Please enter a valid email';
      isValid = false;
    }

    // Validate password (only for create)
    if (!isEdit) {
      if (passwordController.text.trim().isEmpty) {
        passwordError = 'Password is required';
        isValid = false;
      } else if (passwordController.text.trim().length < 6) {
        passwordError = 'Password must be at least 6 characters';
        isValid = false;
      }

      if (confirmPasswordController.text.trim() !=
          passwordController.text.trim()) {
        confirmPasswordError = 'Passwords do not match';
        isValid = false;
      }
    }

    update();
    return isValid;
  }

  void clearErrors() {
    nameError = '';
    emailError = '';
    passwordError = '';
    confirmPasswordError = '';
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    selectedRole = 'admin';
    selectedStatus = 'active';
    clearErrors();
  }

  void populateForm(MbxAdminModel admin) {
    nameController.text = admin.name;
    emailController.text = admin.email;
    passwordController.clear();
    confirmPasswordController.clear();
    selectedRole = admin.role;
    selectedStatus = admin.status;
    clearErrors();
  }

  // Dialog builders

  Widget _buildAdminDetailsDialog(MbxAdminModel admin) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Admin Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Name', admin.name),
            _buildDetailRow('Email', admin.email),
            _buildDetailRow('Role', admin.displayRole),
            _buildDetailRow('Status', admin.displayStatus),
            if (admin.createdAt != null)
              _buildDetailRow('Created At', admin.createdAt!),
            if (admin.lastLoginAt != null)
              _buildDetailRow('Last Login', admin.lastLoginAt!),
            const SizedBox(height: 24),
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    showEditAdminDialog(admin);
                  },
                  child: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateEditAdminDialog() {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  isEdit ? 'Edit Admin' : 'Create New Admin',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Name field
            TextFieldX(
              hint: 'Full Name',
              controller: nameController,
              focusNode: nameFocusNode,
              keyboardType: TextInputType.text,
              readOnly: false,
              obscureText: false,
              onChanged: (value) => clearErrors(),
            ),
            if (nameError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  nameError,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),

            // Email field
            TextFieldX(
              hint: 'Email Address',
              controller: emailController,
              focusNode: emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              readOnly: false,
              obscureText: false,
              onChanged: (value) => clearErrors(),
            ),
            if (emailError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  emailError,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),

            // Role dropdown
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              items: roles.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role == 'super_admin' ? 'Super Admin' : 'Admin'),
                );
              }).toList(),
              onChanged: (value) {
                selectedRole = value!;
                update();
              },
            ),
            const SizedBox(height: 16),

            // Status dropdown (only for edit)
            if (isEdit) ...[
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: statuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status[0].toUpperCase() + status.substring(1)),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedStatus = value!;
                  update();
                },
              ),
              const SizedBox(height: 16),
            ],

            // Password fields (only for create)
            if (!isEdit) ...[
              TextFieldX(
                hint: 'Password',
                controller: passwordController,
                focusNode: passwordFocusNode,
                keyboardType: TextInputType.text,
                readOnly: false,
                obscureText: true,
                onChanged: (value) => clearErrors(),
              ),
              if (passwordError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    passwordError,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),

              TextFieldX(
                hint: 'Confirm Password',
                controller: confirmPasswordController,
                focusNode: confirmPasswordFocusNode,
                keyboardType: TextInputType.text,
                readOnly: false,
                obscureText: true,
                onChanged: (value) => clearErrors(),
              ),
              if (confirmPasswordError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    confirmPasswordError,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 16),
            ],

            // Action buttons
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isSubmitting.value ? null : submitAdmin,
                  child: isSubmitting.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEdit ? 'Update' : 'Create'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
