import 'package:mbankingbackoffice/login/models/mbx_account_model.dart';
import 'package:mbankingbackoffice/login/viewmodels/mbx_profile_vm.dart';

import '../../widget-x/all_widgets.dart';

class MbxSofSheetController extends GetxController {
  List<MbxAccountModel> accounts = [];

  MbxSofSheetController() {
    for (var item in MbxProfileVM.profile.accounts) {
      if (item.sof) {
        item.visible = false;
        accounts.add(item);
      }
    }
  }

  btnCloseClicked() {
    Get.back();
  }

  btnEyeClicked(int index) {
    accounts[index].visible = !accounts[index].visible;
    update();
  }
}
