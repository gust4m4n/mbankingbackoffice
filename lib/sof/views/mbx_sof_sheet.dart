import '../../widget-x/all_widgets.dart';
import 'mbx_sof_sheet_controller.dart';
import 'mbx_sof_widget.dart';

// ignore: must_be_immutable
class MbxSofSheet extends GetWidget<MbxSofSheetController> {
  const MbxSofSheet({super.key});

  static Future<T?> show<T>() {
    FocusManager.instance.primaryFocus?.unfocus();
    const sheet = MbxSofSheet();
    return SheetX.showCustom(widget: sheet, title: 'Sumber Dana');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MbxSofSheetController>(
      init: MbxSofSheetController(),
      builder: (controller) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            physics: ClampingScrollPhysics(),
            separatorBuilder: (context, index) {
              return ContainerX(height: 8.0);
            },
            itemCount: controller.accounts.length,
            itemBuilder: (context, index) {
              return MbxSofWidget(
                account: controller.accounts[index],
                borders: true,
                onEyeClicked: () {
                  controller.btnEyeClicked(index);
                },
                clicked: () {
                  Get.back(result: controller.accounts[index]);
                },
              );
            },
          ),
          ContainerX(height: 16.0),
        ],
      ),
    );
  }
}
