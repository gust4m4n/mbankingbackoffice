import 'dart:io';

import '../../widget-x/all_widgets.dart';
import '../services/universal_camera_service.dart';
import '../services/upgrade_data_service.dart';

class MbxUpgradeKtpPhotoController extends GetxController {
  // Removed duplicate btnNextClicked and replaced warning with showError in main method below

  final UniversalCameraService _cameraService =
      Get.find<UniversalCameraService>();
  final UpgradeDataService _ekycDataService = Get.find<UpgradeDataService>();

  bool isLoading = false;
  bool hasPhoto = false;
  dynamic currentPhoto; // File for mobile, Uint8List for web

  @override
  void onInit() {
    super.onInit();
    _checkExistingPhoto();
  }

  void _checkExistingPhoto() {
    if (_ekycDataService.hasValidKtpPhoto()) {
      currentPhoto = _ekycDataService.ktpPhoto;
      hasPhoto = true;
      update();
    }
  }

  Future<void> btnCaptureClicked() async {
    try {
      isLoading = true;
      update();

      final photo = await _cameraService.captureRearPhoto();
      if (photo != null) {
        currentPhoto = photo;
        hasPhoto = true;
        _ekycDataService.saveKtpPhoto(photo);
        // Tidak perlu tampilkan toast, langsung tampilkan foto di preview
      }
    } catch (e) {
      // Tidak perlu tampilkan toast error
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> btnGalleryClicked() async {
    try {
      isLoading = true;
      update();

      final photo = await _cameraService.pickFromGallery();
      if (photo != null) {
        currentPhoto = photo;
        hasPhoto = true;
        _ekycDataService.saveKtpPhoto(photo);
        // Tidak perlu tampilkan toast, langsung tampilkan foto di preview
      }
    } catch (e) {
      // Tidak perlu tampilkan toast error
    } finally {
      isLoading = false;
      update();
    }
  }

  void showPhotoOptions() {
    Get.bottomSheet(
      ContainerX(
        backgroundColor: ColorX.white,
        topLeftRadius: 20.0,
        topRightRadius: 20.0,
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextX(
              'Choose Photo Source',
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: ColorX.black,
            ),
            ContainerX(height: 24.0),
            ButtonX(
              faIcon: Icons.camera_alt,
              title: 'Camera',
              clicked: () {
                Get.back();
                btnCaptureClicked();
              },
            ),
            ContainerX(height: 16.0),
            ButtonX(
              faIcon: Icons.photo_library,
              title: 'Gallery',
              backgroundColor: Colors.grey[200]!,
              titleColor: ColorX.black,
              clicked: () {
                Get.back();
                btnGalleryClicked();
              },
            ),
            ContainerX(height: 16.0),
            ButtonX(
              title: 'Cancel',
              backgroundColor: ColorX.lightGray,
              titleColor: ColorX.black,
              clicked: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void btnBackClicked() {
    Get.back();
  }

  void btnNextClicked() {
    if (!hasPhoto) {
      // Tidak perlu tampilkan toast error
      return;
    }
    // Setelah foto KTP, klik Continue masuk ke screen input data diri
    Get.toNamed('/ekyc/data-entry');
    print('✅ KTP photo completed, proceeding to data entry screen...');
  }

  Widget buildPhotoWidget() {
    if (!hasPhoto || currentPhoto == null) {
      return Container(
        width: double.infinity,
        height: 200.0,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey[300]!, width: 2.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card, size: 64.0, color: Colors.grey[400]),
            ContainerX(height: 16.0),
            TextX("Belum ada foto ID", color: Colors.grey[600], fontSize: 16.0),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 200.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.green, width: 2.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: _buildPhotoWidget(currentPhoto),
      ),
    );
  }

  Widget _buildPhotoWidget(dynamic photo) {
    if (kIsWeb && photo is Uint8List) {
      return Image.memory(photo, fit: BoxFit.cover);
    } else if (photo is File) {
      return Image.file(photo, fit: BoxFit.cover);
    } else if (photo is String) {
      return Image.file(File(photo), fit: BoxFit.cover);
    } else {
      return Icon(Icons.error, size: 48.0, color: Colors.red);
    }
  }

  // Helper untuk StandardPhotoPreview - returns widget atau null
  Widget? getPhotoWidget() {
    if (!hasPhoto || currentPhoto == null) return null;

    if (kIsWeb && currentPhoto is Uint8List) {
      return Image.memory(currentPhoto, fit: BoxFit.cover);
    } else if (currentPhoto is File) {
      return Image.file(currentPhoto, fit: BoxFit.cover);
    } else if (currentPhoto is String) {
      return Image.file(File(currentPhoto), fit: BoxFit.cover);
    }
    return null;
  }
}
