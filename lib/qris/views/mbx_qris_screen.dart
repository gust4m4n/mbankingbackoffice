import 'package:mbankingbackoffice/apis/mbx_device_info_vm.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../widget-x/all_widgets.dart';
import '../../widget-x/media_x.dart';
import 'mbx_qris_controller.dart';

class MbxQRISScreen extends StatelessWidget {
  const MbxQRISScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MbxQRISController>(
      init: MbxQRISController(),
      builder: (controller) => MbxScreen(
        navigationBarHidden: true,
        body: Stack(
          children: [
            ContainerX(backgroundColor: Colors.black),
            if (MbxDeviceInfoVM.simulator == false)
              MobileScanner(
                controller: controller.scannerController,
                onDetect: (cap) {
                  final List<Barcode> barcodes = cap.barcodes;
                  for (final barcode in barcodes) {
                    controller.qrDetected(barcode.rawValue!);
                    break;
                  }
                },
              ),
            ContainerX(
              child: Center(
                child: ContainerX(
                  width: MediaX.width - 32.0,
                  height: MediaX.width - 32.0,
                  borderWidth: 1.0,
                  borderColor: Colors.white,
                ),
              ),
            ),
            Positioned(
              left: 16.0,
              right: 16.0,
              bottom: 16.0 + MediaQuery.of(Get.context!).padding.bottom,
              child: ContainerX(
                backgroundColor: ColorX.white,
                cornerRadius: 16.0,
                padding: EdgeInsets.only(
                  left: 16.0,
                  top: 8.0,
                  right: 16.0,
                  bottom: 8.0,
                ),
                width: double.infinity,
                child: Row(
                  children: [
                    ButtonX(
                      title: '',
                      backgroundColor: ColorX.theme,
                      width: 40.0,
                      height: 40.0,
                      cornerRadius: 20.0,
                      faIcon: FontAwesomeIcons.arrowLeft,
                      iconWidth: 18.0,
                      iconHeight: 18.0,
                      faColor: ColorX.white,
                      clicked: () {
                        controller.btnBackClicked();
                      },
                    ),
                    ContainerX(width: 8.0),
                    ButtonX(
                      title: '',
                      backgroundColor: ColorX.theme,
                      width: 40.0,
                      height: 40.0,
                      cornerRadius: 20.0,
                      faIcon: FontAwesomeIcons.fileImage,
                      iconWidth: 18.0,
                      iconHeight: 18.0,
                      faColor: ColorX.white,
                      clicked: () {
                        controller.btnImageClicked();
                      },
                    ),
                    ContainerX(width: 8.0),
                    ButtonX(
                      title: '',
                      backgroundColor: controller.flashlight
                          ? ColorX.white
                          : ColorX.theme,
                      width: 40.0,
                      height: 40.0,
                      cornerRadius: 20.0,
                      faIcon: FontAwesomeIcons.bolt,
                      iconWidth: 18.0,
                      iconHeight: 18.0,
                      faColor: controller.flashlight
                          ? ColorX.theme
                          : ColorX.white,
                      clicked: () {
                        controller.btnFlashlightClicked();
                      },
                    ),
                    ContainerX(width: 8.0),
                    Expanded(
                      child: ImageX(
                        url: 'assets/images/mbx_qris.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
