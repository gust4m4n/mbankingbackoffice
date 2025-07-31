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
  var perPage = 10;
  var totalPages = 1.obs;

  @override
  void onInit() {
    super.onInit();
    loadAdmins();
  }

  /// Load admins list
  Future<void> loadAdmins({int page = 1}) async {
    try {
      isLoading.value = true;
      currentPage.value = page;

      final response = await MbxAdminApiService.getAdmins(
        page: page,
        perPage: perPage,
      );

      print('API Response - Status: ${response.statusCode}');
      print('API Response - Data Type: ${response.jason.mapValue.runtimeType}');
      print('API Response - Data: ${response.jason.mapValue}');

      if (response.statusCode == 200) {
        final data = response.jason.mapValue;

        // Check if the data structure is correct
        if (data['data'] != null) {
          final adminData = data['data'];
          print('Admin Data: $adminData');
          print('Admin Data Type: ${adminData.runtimeType}');

          // Try to parse the response
          if (adminData is Map<String, dynamic>) {
            final adminListResponse = MbxAdminApiService.parseAdminListResponse(
              adminData,
            );
            admins.value = adminListResponse.admins;
            totalAdmins.value = adminListResponse.total;
            totalPages.value = adminListResponse.totalPages;
            print('Successfully loaded ${admins.length} admins');
          } else {
            print('Unexpected admin data type: ${adminData.runtimeType}');
          }
        } else {
          print('No data field in response');
        }
      } else {
        print('API Error: ${response.message}');
      }
    } catch (e, stackTrace) {
      print('Error loading admins: $e');
      print('Stack trace: $stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh admin list
  void refreshAdmins() {
    loadAdmins(page: currentPage.value);
  }

  /// Next page
  void nextPage() {
    if (currentPage.value < totalPages.value) {
      loadAdmins(page: currentPage.value + 1);
    }
  }

  /// Previous page
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

  /// Placeholder methods for CRUD operations
  void showCreateAdminDialog() {
    print('Show create admin dialog');
  }

  void showEditAdminDialog(MbxAdminModel admin) {
    print('Show edit admin dialog for: ${admin.name}');
  }

  void viewAdmin(MbxAdminModel admin) {
    print('View admin: ${admin.name}');
  }

  void deleteAdmin(MbxAdminModel admin) {
    print('Delete admin: ${admin.name}');
  }
}
