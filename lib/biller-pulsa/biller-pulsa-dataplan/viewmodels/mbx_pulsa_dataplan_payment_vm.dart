import 'package:mbankingbackoffice/apis/mbx_apis.dart';
import 'package:mbankingbackoffice/receipt/models/mbx_receipt_model.dart';

class MbxPulsaDataPlanPaymentVM {
  var receipt = MbxReceiptModel();

  Future<ApiXResponse> request({
    required String transactionId,
    required String pin,
    required bool biometric,
  }) {
    return MbxApi.post(
      endpoint: '/pulsa/dataplan/payment',
      params: {},
      headers: {},
      contractFile: 'assets/contracts/MbxPulsaDataPlanPaymentContract.json',
      contract: true,
    ).then((resp) {
      if (resp.status == 200) {
        receipt = MbxReceiptModel.fromJason(resp.jason['data']);
      }
      return resp;
    });
  }
}
