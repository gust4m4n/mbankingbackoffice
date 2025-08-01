import 'package:intl/intl.dart';
import 'package:mbankingbackoffice/cardless/viewmodels/mbx_cardless_denoms_vm.dart';
import 'package:mbankingbackoffice/cardless/viewmodels/mbx_cardless_inquiry_vm.dart';
import 'package:mbankingbackoffice/cardless/viewmodels/mbx_cardless_payment_vm.dart';
import 'package:mbankingbackoffice/inquiry/models/mbx_inquiry_model.dart';
import 'package:mbankingbackoffice/inquiry/views/mbx_inquiry_sheet.dart';
import 'package:mbankingbackoffice/login/models/mbx_account_model.dart';
import 'package:mbankingbackoffice/login/viewmodels/mbx_profile_vm.dart';
import 'package:mbankingbackoffice/pin/views/mbx_pin_sheet.dart';
import 'package:mbankingbackoffice/sof/views/mbx_sof_sheet.dart';

import '../../widget-x/all_widgets.dart';

class MbxCardlessController extends GetxController {
  var sof = MbxAccountModel();

  final amountController = TextEditingController();
  final amountNode = FocusNode();
  var amountError = '';
  int amount = 0;

  final denomsVM = MbxCardlessDenomsVM();

  @override
  void onReady() {
    super.onReady();
    sof = MbxProfileVM.profile.accounts[0];
    update();
    denomsVM.request().then((resp) {
      update();
    });
  }

  btnBackClicked() {
    Get.back();
  }

  amountChanged(String value) {
    String newValue = value.replaceAll('.', '');
    int? intValue = int.tryParse(newValue);
    if (intValue != null) {
      amount = intValue;
      final formatter = NumberFormat('#,###');
      String formatted = formatter.format(intValue).replaceAll(',', '.');
      amountController.text = formatted;
      amountController.selection = TextSelection.fromPosition(
        TextPosition(offset: formatted.length),
      );
    } else {
      amount = 0;
      amountController.text = '';
    }
    update();
  }

  selectDenom(int value) {
    amount = value;
    amountController.text = value.toString();
    update();
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
    if (amountController.text.isEmpty || amount <= 0) {
      amountError = 'Masukkan nominal transfer.';
      update();
      amountNode.requestFocus();
      return false;
    }
    amountError = '';
    update();

    return true;
  }

  bool readyToSubmit() {
    if (amount > 0) {
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
    final inquiryVM = MbxCardlessInquiryVM();
    inquiryVM.request().then((resp) {
      Get.back();
      if (resp.status == 200) {
        final sheet = MbxInquirySheet(
          title: 'confirmation'.tr,
          confirmBtnTitle: 'Tarik',
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
    final paymentVM = MbxCardlessPaymentVM();
    paymentVM
        .request(transactionId: transactionId, pin: pin, biometric: biometric)
        .then((resp) {
          if (resp.status == 200) {
            Get.back();
            Get.offNamed('/cardless/payment', arguments: paymentVM.steps);
          } else {
            // payment request failed
          }
        });
  }
}
