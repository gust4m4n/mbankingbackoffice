import 'package:mbankingbackoffice/apis/mbx_apis.dart';
import 'package:mbankingbackoffice/qris/models/mbx_qris_inquiry_model.dart';

class MbxQRISInquiryVM {
  var loading = false;
  var inqury = MbxQRISInquiryModel();

  Future<ApiXResponse> request({required String qrCode}) {
    loading = true;
    final params = {'qr_code': qrCode};
    return MbxApi.post(
      endpoint: '/qris/inquiry',
      params: params,
      headers: {},
      contractFile: 'assets/contracts/MbxQRISInquiryContract.json',
      contract: true,
    ).then((resp) async {
      loading = false;
      if (resp.status == 200) {
        inqury = MbxQRISInquiryModel.fromJason(resp.jason['data']);
      }
      return resp;
    });
  }
}
