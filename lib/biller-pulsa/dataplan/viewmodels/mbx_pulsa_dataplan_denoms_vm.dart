import 'package:mbankingbackoffice/apis/mbx_apis.dart';
import 'package:mbankingbackoffice/biller-pulsa/dataplan/models/mbx_pulsa_dataplan_denom_model.dart';

class MbxPulsaDataPlanDenomsVM {
  List<MbxPulsaDataPlanDenomModel> list = [];

  Future<ApiXResponse> request({required String phone}) {
    return MbxApi.get(
      endpoint: '/pulsa/dataplan/denoms',
      params: {},
      headers: {},
      contractFile: 'assets/contracts/MbxPulsaDataPlanDenomsContract.json',
      contract: true,
    ).then((resp) {
      if (resp.status == 200) {
        clear();
        for (var item in resp.jason['data'].jasonListValue) {
          list.add(MbxPulsaDataPlanDenomModel.fromJason(item));
        }
      }
      return resp;
    });
  }

  void clear() {
    list = [];
  }
}
