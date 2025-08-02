import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Reusable Dialog Controller untuk semua popup/dialog di aplikasi
class MbxDialogController extends GetxController {
  static MbxDialogController get instance => Get.find<MbxDialogController>();

  /// Loading state untuk dialog
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  /// Set loading state
  void setLoading(bool loading) {
    _isLoading.value = loading;
  }

  /// Show konfirmasi dialog dengan custom action
  static Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Ya',
    String cancelText = 'Batal',
    Color? confirmColor,
    IconData? icon,
    VoidCallback? onConfirm,
  }) async {
    return await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 24),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              cancelText,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (onConfirm != null) onConfirm();
              Get.back(result: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              confirmText,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Show info dialog
  static Future<void> showInfoDialog({
    required String title,
    required String message,
    String buttonText = 'OK',
    IconData? icon,
    Color? iconColor,
  }) async {
    return await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 24, color: iconColor),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 16)),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  /// Show success dialog
  static Future<void> showSuccessDialog({
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) async {
    return await showInfoDialog(
      title: title,
      message: message,
      buttonText: buttonText,
      icon: Icons.check_circle,
      iconColor: Colors.green,
    ).then((_) {
      if (onPressed != null) onPressed();
    });
  }

  /// Show error dialog
  static Future<void> showErrorDialog({
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) async {
    return await showInfoDialog(
      title: title,
      message: message,
      buttonText: buttonText,
      icon: Icons.error,
      iconColor: Colors.red,
    ).then((_) {
      if (onPressed != null) onPressed();
    });
  }

  /// Show warning dialog
  static Future<void> showWarningDialog({
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) async {
    return await showInfoDialog(
      title: title,
      message: message,
      buttonText: buttonText,
      icon: Icons.warning,
      iconColor: Colors.orange,
    ).then((_) {
      if (onPressed != null) onPressed();
    });
  }

  /// Show loading dialog
  static void showLoadingDialog({String message = 'Loading...'}) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent dismiss
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Hide loading dialog
  static void hideLoadingDialog() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  /// Show custom dialog dengan widget kustom
  static Future<T?> showCustomDialog<T>({
    required Widget content,
    bool barrierDismissible = true,
    Color? backgroundColor,
    double? elevation,
    EdgeInsets? insetPadding,
  }) async {
    return await Get.dialog<T>(
      AlertDialog(
        backgroundColor: backgroundColor,
        elevation: elevation,
        insetPadding: insetPadding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: content,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  /// Show bottom sheet dialog
  static Future<T?> showBottomSheetDialog<T>({
    required Widget content,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
  }) async {
    return await Get.bottomSheet<T>(
      Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Get.theme.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: content,
      ),
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      elevation: elevation,
    );
  }

  /// Show feature not available dialog
  static Future<void> showFeatureNotAvailable(String featureName) async {
    return await showInfoDialog(
      title: 'Fitur Belum Tersedia',
      message: '$featureName akan segera tersedia dalam update mendatang.',
      icon: Icons.construction,
      iconColor: Colors.orange,
    );
  }

  /// Show logout confirmation
  static Future<bool?> showLogoutConfirmation() async {
    return await showConfirmationDialog(
      title: 'Konfirmasi Logout',
      message: 'Apakah Anda yakin ingin keluar dari aplikasi?',
      confirmText: 'Logout',
      cancelText: 'Batal',
      confirmColor: Colors.red,
      icon: Icons.logout,
    );
  }

  /// Show delete confirmation
  static Future<bool?> showDeleteConfirmation(String itemName) async {
    return await showConfirmationDialog(
      title: 'Konfirmasi Hapus',
      message:
          'Apakah Anda yakin ingin menghapus $itemName? Tindakan ini tidak dapat dibatalkan.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      confirmColor: Colors.red,
      icon: Icons.delete_forever,
    );
  }
}
