import 'package:mbankingbackoffice/apis/mbx_apis.dart';
import 'package:mbankingbackoffice/inquiry/models/mbx_inquiry_model.dart';

class MbxPDAMInquiryVM {
  var loading = false;
  var inquiry = MbxInquiryModel();

  Future<ApiXResponse> request() {
    loading = true;
    return MbxApi.post(
      endpoint: '/pdam/inquiry',
      params: {},
      headers: {},
      contractFile: 'assets/contracts/MbxPDAMInquiryContract.json',
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
