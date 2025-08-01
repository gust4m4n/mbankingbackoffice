import 'package:mbankingbackoffice/sof/views/mbx_sof_widget.dart';

import '../../../widget-x/all_widgets.dart';
import 'mbx_pulsa_dataplan_controller.dart';
import 'mbx_pulsa_dataplan_denom_widget.dart';

class MbxPulsaDataPlanScreen extends StatelessWidget {
  const MbxPulsaDataPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MbxPulsaDataPlanController>(
      init: MbxPulsaDataPlanController(),
      builder: (controller) => MbxScreen(
        title: 'data_package'.tr,
        scrollingBody: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextX(
                  'SUMBER DANA',
                  color: ColorX.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start,
                ),
                ContainerX(height: 4.0),
                ContainerX(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    left: 12.0,
                    top: 8.0,
                    right: 12.0,
                    bottom: 8.0,
                  ),
                  borderWidth: 1.0,
                  borderColor: ColorX.lightGray,
                  cornerRadius: 8.0,
                  child: Row(
                    children: [
                      Expanded(
                        child: MbxSofWidget(
                          account: controller.sof,
                          borders: false,
                          onEyeClicked: () {
                            controller.btnSofEyeClicked();
                          },
                        ),
                      ),
                      ContainerX(width: 8.0),
                      ButtonX(
                        faIcon: FontAwesomeIcons.chevronDown,
                        backgroundColor: ColorX.transparent,
                        iconWidth: 16.0,
                        iconHeight: 16.0,
                        title: '',
                        width: 40.0,
                        height: 40.0,
                        borderWidth: 0.5,
                        borderColor: ColorX.gray,
                        clicked: () {
                          controller.btnSofClicked();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ContainerX(height: 12.0),
            ContainerError(
              error: controller.customerIdError,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextX(
                    'NO. HANDPHONE',
                    color: ColorX.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.start,
                  ),
                  ContainerX(height: 4.0),
                  TextFieldX(
                    hint: '08xxxxxxxxxx',
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    readOnly: false,
                    controller: controller.customerIdController,
                    focusNode: controller.customerIdNode,
                    rightIcon: controller.customerIdController.text.isNotEmpty
                        ? ImageX(
                            url: 'assets/images/mbx_operator_im3.png',
                            width: 32.0,
                            height: 32.0,
                            padding: EdgeInsets.all(4.0),
                            cornerRadius: 4.0,
                          )
                        : null,
                    onChanged: (value) {
                      controller.customerIdChanged(value);
                    },
                  ),
                ],
              ),
            ),
            ContainerX(height: 12.0),
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: ClampingScrollPhysics(),
              itemCount: controller.denomsVM.list.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                childAspectRatio: 1.9,
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                final denom = controller.denomsVM.list[index];
                return MbxPulsaDataPlanDenomWidget(
                  denom: denom,
                  selected:
                      denom.name == controller.selectedDenom.name &&
                      denom.price == controller.selectedDenom.price,
                  clicked: () {
                    controller.selectDenom(controller.denomsVM.list[index]);
                  },
                );
              },
            ),
            ContainerX(height: 16.0),
            ButtonX(
              backgroundColor: ColorX.theme,
              disabledBackgroundColor: ColorX.theme.withValues(alpha: 0.1),
              title: 'continue_text'.tr,
              enabled: controller.readyToSubmit(),
              clicked: () {
                controller.btnNextClicked();
              },
            ),
          ],
        ),
      ),
    );
  }
}
