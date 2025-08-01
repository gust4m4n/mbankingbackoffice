import 'package:mbankingbackoffice/qris/viewmodels/mbx_qris_inquiry_vm.dart';
import 'package:mbankingbackoffice/qris/views/mbx_qris_amount_screen.dart';
import 'package:mbankingbackoffice/utils/all_utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../widget-x/all_widgets.dart';

class MbxQRISController extends GetxController {
  MobileScannerController? scannerController;
  var flashlight = false;
  final inquiryVM = MbxQRISInquiryVM();

  @override
  Future<void> onReady() async {
    super.onReady();
    scannerController = MobileScannerController(
      autoStart: false,
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
    await scannerController?.start();
  }

  btnBackClicked() async {
    await scannerController?.stop();
    await scannerController?.dispose();
    Get.back();
  }

  btnImageClicked() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1024.0,
      maxHeight: 1024.0,
      preferredCameraDevice: CameraDevice.front,
    );
    if (pickedFile != null) {
      LoggerX.log("QR file: ${pickedFile.path}");
      final cap = await scannerController?.analyzeImage(pickedFile.path);
      if (cap == null) {
        ToastX.showError(msg: 'QR tidak terdeteksi.');
        return;
      }
      final List<Barcode> barcodes = cap.barcodes;
      for (final barcode in barcodes) {
        qrDetected(barcode.rawValue!);
        break;
      }
    }
  }

  btnFlashlightClicked() {
    scannerController?.toggleTorch();
    flashlight = !flashlight;
    update();
  }

  qrDetected(String code) async {
    LoggerX.log('QR Code: $code');
    await scannerController?.stop();
    Get.loading();
    inquiryVM.request(qrCode: code).then((resp) async {
      Get.back();
      if (resp.status == 200) {
        Get.to(MbxQRISAmountScreen(inquiry: inquiryVM.inqury))?.then((
          value,
        ) async {
          await scannerController?.start();
        });
      } else {
        await scannerController?.start();
      }
    });
  }
}
