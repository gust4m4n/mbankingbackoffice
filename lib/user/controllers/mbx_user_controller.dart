import 'package:mbankingbackoffice/user/models/mbx_user_model.dart';
import 'package:mbankingbackoffice/user/services/mbx_user_api_service.dart';
import 'package:mbankingbackoffice/user/views/mbx_user_detail_dialog.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxUserController extends GetxController {
  // Loading states
  var isLoading = false.obs;

  // User list
  var users = <MbxUserModel>[].obs;
  var totalUsers = 0.obs;
  var currentPage = 1.obs;
  var perPage = 32.obs; // Changed from 10 to 32
  var totalPages = 1.obs;

  // Selected user for view/delete
  MbxUserModel? selectedUser;

  // Search and filter controllers
  final searchController = TextEditingController();
  final nameFilterController = TextEditingController();
  final phoneFilterController = TextEditingController();

  // Filter states
  var selectedStatus = ''.obs;
  var isFilterActive = false.obs;

  // Available status options for filtering
  final statusOptions = <String>['active', 'inactive', 'suspended', 'pending'];

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  @override
  void onClose() {
    searchController.dispose();
    nameFilterController.dispose();
    phoneFilterController.dispose();
    super.onClose();
  }

  /// Load users list with search and filters
  Future<void> loadUsers({
    int page = 1,
    String? search,
    String? name,
    String? phone,
    String? status,
  }) async {
    try {
      isLoading.value = true;
      currentPage.value = page;

      final response = await MbxUserApiService.getUsers(
        page: page,
        perPage: perPage.value,
        search: search ?? searchController.text.trim(),
        name: name ?? nameFilterController.text.trim(),
        phone: phone ?? phoneFilterController.text.trim(),
        status:
            status ??
            (selectedStatus.value.isEmpty ? null : selectedStatus.value),
      );

      if (response.statusCode == 200) {
        final data = response.jason.mapValue;
        final userListResponse = MbxUserApiService.parseUserListResponse(
          data['data'] ?? data,
        );

        users.value = userListResponse.users;
        totalUsers.value = userListResponse.total;
        totalPages.value = userListResponse.totalPages;

        // Validate pagination data consistency
        final calculatedTotalPages =
            (userListResponse.total / userListResponse.perPage).ceil();
        if (calculatedTotalPages != userListResponse.totalPages) {
          print(
            'Warning: totalPages mismatch - calculated: $calculatedTotalPages, received: ${userListResponse.totalPages}',
          );
          totalPages.value = calculatedTotalPages;
        }

        print('Successfully loaded ${users.length} users');
        print(
          'Pagination: page=${userListResponse.page}, total=${userListResponse.total}, perPage=${userListResponse.perPage}, totalPages=${totalPages.value}',
        );
      } else {
        ToastX.showError(msg: 'Failed to load users: ${response.message}');
      }
    } catch (e) {
      print('Error loading users: $e');
      ToastX.showError(msg: 'Error loading users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// View user details
  void viewUser(MbxUserModel user) {
    selectedUser = user;
    MbxUserDetailDialog.show(Get.context!, user);
  }

  /// Delete user
  void deleteUser(MbxUserModel user) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text(
          'Are you sure you want to delete user "${user.name}"?\n\nThis action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => _performDelete(user),
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

  /// Go to next page
  void nextPage() {
    if (currentPage.value < totalPages.value) {
      loadUsers(page: currentPage.value + 1);
    }
  }

  /// Go to previous page
  void previousPage() {
    if (currentPage.value > 1) {
      loadUsers(page: currentPage.value - 1);
    }
  }

  /// Go to first page
  void firstPage() {
    if (currentPage.value > 1) {
      loadUsers(page: 1);
    }
  }

  /// Go to last page
  void lastPage() {
    if (currentPage.value < totalPages.value) {
      loadUsers(page: totalPages.value);
    }
  }

  /// Go to specific page
  void goToPage(int page) {
    if (page >= 1 && page <= totalPages.value && page != currentPage.value) {
      loadUsers(page: page);
    }
  }

  /// Refresh user list
  void refreshUsers() {
    loadUsers(page: currentPage.value);
  }

  /// Search users
  void searchUsers() {
    _checkFilterStatus();
    loadUsers(page: 1);
  }

  /// Clear search and filters
  void clearSearchAndFilters() {
    searchController.clear();
    nameFilterController.clear();
    phoneFilterController.clear();
    selectedStatus.value = '';
    isFilterActive.value = false;
    loadUsers(page: 1);
  }

  /// Apply filters
  void applyFilters() {
    _checkFilterStatus();
    loadUsers(page: 1);
  }

  /// Check if any filter is active
  void _checkFilterStatus() {
    isFilterActive.value =
        searchController.text.trim().isNotEmpty ||
        nameFilterController.text.trim().isNotEmpty ||
        phoneFilterController.text.trim().isNotEmpty ||
        selectedStatus.value.isNotEmpty;
  }

  // Private methods

  Future<void> _performDelete(MbxUserModel user) async {
    try {
      Get.back(); // Close confirmation dialog
      Get.loading();

      final response = await MbxUserApiService.deleteUser(user.id);

      if (response.statusCode == 200) {
        ToastX.showSuccess(msg: 'User deleted successfully');
        loadUsers(page: currentPage.value); // Refresh list
      } else {
        ToastX.showError(msg: 'Failed to delete user: ${response.message}');
      }
    } catch (e) {
      print('Error deleting user: $e');
      ToastX.showError(msg: 'Error deleting user: $e');
    } finally {
      Get.back(); // Close loading
    }
  }
}
