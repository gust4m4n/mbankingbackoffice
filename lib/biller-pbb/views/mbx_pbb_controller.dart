import 'package:mbankingbackoffice/biller-pbb/viewmodels/mbx_pbb_inquiry_vm.dart';
import 'package:mbankingbackoffice/biller-pbb/viewmodels/mbx_pbb_payment_vm.dart';
import 'package:mbankingbackoffice/inquiry/models/mbx_inquiry_model.dart';
import 'package:mbankingbackoffice/login/models/mbx_account_model.dart';
import 'package:mbankingbackoffice/login/viewmodels/mbx_profile_vm.dart';
import 'package:mbankingbackoffice/pin/views/mbx_pin_sheet.dart';
import 'package:mbankingbackoffice/sof/views/mbx_sof_sheet.dart';

import '../../inquiry/views/mbx_inquiry_sheet.dart';
import '../../string-picker/views/mbx_string_picker.dart';
import '../../widget-x/all_widgets.dart';

class MbxPBBController extends GetxController {
  var sof = MbxAccountModel();

  final nopController = TextEditingController();
  final nopNode = FocusNode();
  var nopError = '';

  var yearSelected = '';
  var yearError = '';

  @override
  void onReady() {
    super.onReady();
    sof = MbxProfileVM.profile.accounts[0];

    update();
  }

  btnBackClicked() {
    Get.back();
  }

  nopChanged(String value) {
    update();
  }

  btnPickYearClicked() {
    List<String> years = [];
    for (int i = 1990; i <= DateTime.now().year; i++) {
      years.insert(0, i.toString());
    }

    final picker = MbxStringPicker(title: 'Pilih Tahun', list: years);
    picker.show().then((selectedIndex) {
      if (selectedIndex != null) {
        yearSelected = years[selectedIndex];
        update();
      }
    });
  }

  btnSofClicked() {
    MbxSofSheet.show().then((sof) {
      if (sof != null) {
        this.sof = sof;
        update();
      }
    });
  }

  btnSofEyeClicked() {
    sof.visible = !sof.visible;
    update();
  }

  bool validate() {
    if (nopController.text.isEmpty) {
      nopError = 'Masukkan NOP.';
      update();
      nopNode.requestFocus();
      return false;
    }
    nopError = '';

    if (yearSelected.isEmpty) {
      yearError = 'Pilih tahun';
      update();
      return false;
    }
    yearError = '';

    update();
    return true;
  }

  bool readyToSubmit() {
    if (nopController.text.isNotEmpty && yearSelected.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  btnNextClicked() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (validate() == true) {
      inquiry();
    }
  }

  inquiry() {
    Get.loading();
    final inquiryVM = MbxPBBInquiryVM();
    inquiryVM.request().then((resp) {
      Get.back();
      if (resp.status == 200) {
        final sheet = MbxInquirySheet(
          title: 'confirmation'.tr,
          confirmBtnTitle: 'pay'.tr,
          inquiry: inquiryVM.inquiry,
        );
        sheet.show().then((value) {
          if (value == true) {
            authenticate(inquiry: inquiryVM.inquiry);
          }
        });
      } else {
        // inquiry request failed
      }
    });
  }

  authenticate({required MbxInquiryModel inquiry}) {
    final pinSheet = MbxPinSheet();
    pinSheet.show(
      title: 'pin'.tr,
      message: 'enter_pin_message'.tr,
      secure: true,
      biometric: true,
      onSubmit: (code, biometric) async {
        payment(transactionId: code, pin: code, biometric: biometric);
      },
      optionTitle: 'forgot_pin'.tr,
      optionClicked: () {
        pinSheet.clear('');
        ToastX.showSuccess(msg: 'pin_reset_message'.tr);
      },
    );
  }

  payment({
    required String transactionId,
    required String pin,
    required bool biometric,
  }) {
    Get.loading();
    final paymentVM = MbxPBBPaymentVM();
    paymentVM
        .request(transactionId: transactionId, pin: pin, biometric: biometric)
        .then((resp) {
          if (resp.status == 200) {
            Get.back();
            Get.offNamed(
              '/receipt',
              arguments: {
                'receipt': paymentVM.receipt,
                'backToHome': true,
                'askFeedback': true,
              },
            );
          } else {
            // payment request failed
          }
        });
  }
}
