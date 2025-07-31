import 'package:mbankingbackoffice/home/models/mbx_dashboard_model.dart';
import 'package:mbankingbackoffice/home/services/mbx_dashboard_api_service.dart';
import 'package:mbankingbackoffice/preferences/mbx_preferences_vm_users.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxHomeController extends GetxController {
  // Loading states
  var isLoading = false.obs;

  // Admin info
  var adminName = 'Admin User';

  // Dashboard data
  var dashboardData = Rxn<MbxDashboardModel>();

  @override
  void onInit() {
    super.onInit();
    loadAdminInfo();
    loadDashboard();
  }

  void loadAdminInfo() async {
    // Try to get admin name from stored preferences or set default
    adminName = 'Admin User'; // Default name
    update();
  }

  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;

      final response = await MbxDashboardApiService.getDashboard();

      if (response.statusCode == 200) {
        final data = response.jason.mapValue;
        final dashboard = MbxDashboardApiService.parseDashboardResponse(
          data['data'] ?? data,
        );

        print('🔍 Dashboard Data Parsed:');
        print(
          '  - Total Transactions Today Amount: ${dashboard.totalTransactions.todayAmount}',
        );
        print(
          '  - Topup Today Amount: ${dashboard.topupTransactions.todayAmount}',
        );
        print(
          '  - Withdraw Today Amount: ${dashboard.withdrawTransactions.todayAmount}',
        );
        print(
          '  - Transfer Today Amount: ${dashboard.transferTransactions.todayAmount}',
        );

        dashboardData.value = dashboard;
        print('Dashboard loaded successfully');
      } else {
        ToastX.showError(msg: 'Failed to load dashboard: ${response.message}');
      }
    } catch (e) {
      print('Error loading dashboard: $e');
      ToastX.showError(msg: 'Error loading dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    await loadDashboard();
  }

  void logout() {
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

  void showFeatureNotAvailable(String featureName) {
    ToastX.showSuccess(msg: '$featureName akan segera tersedia');
  }
}
