import 'package:mbankingbackoffice/apis/mbx_apis.dart';
import 'package:mbankingbackoffice/inquiry/models/mbx_inquiry_model.dart';

class MbxTransferP2BankInquiryVM {
  var loading = false;
  var inquiry = MbxInquiryModel();

  Future<ApiXResponse> request() {
    loading = true;
    return MbxApi.post(
      endpoint: '/transfer/p2bank/inquiry',
      params: {},
      headers: {},
      contractFile: 'assets/contracts/MbxTransferP2BankInquiryContract.json',
      contract: true,
    ).then((resp) {
      loading = false;
      if (resp.status == 200) {
        inquiry = MbxInquiryModel.fromJason(resp.jason['data']);
      }
      return resp;
    });
  }
}
