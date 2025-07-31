import 'package:mbankingbackoffice/preferences/mbx_preferences_vm_users.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxHomeController extends GetxController {
  var adminName = 'Admin User';

  @override
  void onInit() {
    super.onInit();
    loadAdminInfo();
  }

  void loadAdminInfo() async {
    // Try to get admin name from stored preferences or set default
    adminName = 'Admin User'; // Default name
    update();
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
