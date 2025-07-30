import 'dart:async';
import 'dart:io';

import 'package:mbankingbackoffice/apis/mbx_apis.dart';
import 'package:mbankingbackoffice/login/models/mbx_profile_model.dart';
import 'package:mbankingbackoffice/login/views/mbx_login_screen.dart';
import 'package:mbankingbackoffice/preferences/mbx_preferences_vm_users.dart';
import 'package:mbankingbackoffice/utils/jason_x.dart';
import 'package:mbankingbackoffice/utils/logger_x.dart';
import 'package:mbankingbackoffice/widget-x/all_widgets.dart';

class MbxProfileVM {
  static var profile = MbxProfileModel();

  static Future<ApiXResponse> request() {
    return MbxApi.post(
      endpoint: '/profile',
      params: {},
      headers: {},
      contractFile: 'assets/contracts/MbxProfileContract.json',
      contract: true,
    ).then((resp) async {
      if (resp.status == 200) {
        profile.decode(resp.jason['data']);
        await save();
      }
      return resp;
    });
  }

  static save() async {
    final jason = profile.encode();
    await MbxUserPreferencesVM.setProfile(jason.encoded(minify: true));
    LoggerX.log('[Profile] saved:\n${jason.encoded(minify: false)}');
  }

  static load() async {
    final jsonString = await MbxUserPreferencesVM.getProfile();
    final jason = Jason.decode(jsonString);
    profile.decode(jason);
    LoggerX.log('[Profile] loaded:\n${jason.encoded(minify: false)}');
  }

  static logout() {
    profile = MbxProfileModel();
    save();
    MbxUserPreferencesVM.resetAll();
    Get.deleteAll();
    Get.offAll(MbxLoginScreen());
    LoggerX.log('[Profile] logout');
  }

  static void forceQuit() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}
