import 'dart:async';

import 'package:mbankingbackoffice/apis/mbx_apis.dart';
import 'package:mbankingbackoffice/preferences/mbx_preferences_vm_users.dart';

class MbxReloginVM {
  static Future<ApiXResponse> request({
    required String pin,
    required bool biometric,
  }) {
    final params = {'pin': pin, 'biometric': biometric};
    return MbxApi.post(
      endpoint: '/relogin',
      params: params,
      headers: {},
      contractFile: 'assets/contracts/MbxReloginContract.json',
      contract: true,
    ).then((resp) async {
      if (resp.status == 200) {
        MbxUserPreferencesVM.setToken(resp.jason['data']['token'].stringValue);
      } else {}
      return resp;
    });
  }
}
