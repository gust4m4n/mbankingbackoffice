import 'package:intl/intl.dart';
import 'package:mbankingbackoffice/inquiry/models/mbx_inquiry_model.dart';
import 'package:mbankingbackoffice/login/models/mbx_account_model.dart';
import 'package:mbankingbackoffice/login/viewmodels/mbx_profile_vm.dart';
import 'package:mbankingbackoffice/pin/views/mbx_pin_sheet.dart';
import 'package:mbankingbackoffice/sof/views/mbx_sof_sheet.dart';
import 'package:mbankingbackoffice/transfer/p2p/models/mbx_transfer_p2p_dest_model.dart';
import 'package:mbankingbackoffice/transfer/p2p/viewmodels/mbx_transfer_p2p_inquiry_vm.dart';
import 'package:mbankingbackoffice/transfer/p2p/viewmodels/mbx_transfer_p2p_payment_vm.dart';

import '../../../inquiry/views/mbx_inquiry_sheet.dart';
import '../../../widget-x/all_widgets.dart';
import 'mbx_transfer_p2p_picker.dart';

class MbxTransfeP2PController extends GetxController {
  var dest = MbxTransferP2PDestModel();
  var destError = '';

  final amountController = TextEditingController();
  final amountNode = FocusNode();
  var amountError = '';
  int amount = 0;

  final messageController = TextEditingController();
  final messageNode = FocusNode();
  var messageError = '';

  var sof = MbxAccountModel();

  @override
  void onReady() {
    super.onReady();
    sof = MbxProfileVM.profile.accounts[0];

    update();
  }

  btnBackClicked() {
    Get.back();
  }

  btnPickDestinationClicked() {
    final picker = MbxTransferP2PPicker();
    picker.show().then((value) {
      if (value != null) {
        dest = value;
        update();
      }
    });
  }

  btnClearClicked() {
    dest = MbxTransferP2PDestModel();
    update();
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

  messageChanged(String value) {
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
    if (dest.account.isEmpty) {
      destError = 'Pilih rekening tujuan terlebih dahulu.';
      update();
      return false;
    }
    destError = '';

    if (amountController.text.isEmpty || amount <= 0) {
      amountError = 'Masukkan nominal transfer.';
      update();
      amountNode.requestFocus();
      return false;
    }
    amountError = '';

    if (messageController.text.isEmpty) {
      messageError = 'Berita harus diisi.';
      update();
      messageNode.requestFocus();
      return false;
    }
    messageError = '';
    update();

    return true;
  }

  bool readyToSubmit() {
    if (dest.account.isNotEmpty &&
        amount > 0 &&
        messageController.text.isNotEmpty) {
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
    final inquiryVM = MbxTransferP2PInquiryVM();
    inquiryVM.request().then((resp) {
      Get.back();
      if (resp.status == 200) {
        final sheet = MbxInquirySheet(
          title: 'confirmation'.tr,
          confirmBtnTitle: 'Transfer',
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
    final paymentVM = MbxTransferP2PPaymentVM();
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
