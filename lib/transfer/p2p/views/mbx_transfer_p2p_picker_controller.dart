import 'package:mbankingbackoffice/transfer/p2p/models/mbx_transfer_p2p_dest_model.dart';
import 'package:mbankingbackoffice/transfer/p2p/viewmodels/mbx_transfer_p2p_dest_list_vm.dart';

import '../../../widget-x/all_widgets.dart';

class MbxTransferP2PPickerController extends GetxController {
  TextEditingController txtSearch = TextEditingController();
  var loading = true;
  var destListVM = MbxTransferP2PDestListVM();

  @override
  void onReady() {
    super.onReady();
    update();
    destListVM.nextPage().then((resp) {
      loading = false;
      destListVM.sort();
      destListVM.setFilter('');
      update();
    });
  }

  btnCloseClicked() {
    Get.back(result: null);
  }

  txtSearchChanged(String value) {
    destListVM.setFilter(value);
    update();
  }

  onDeleteClicked(MbxTransferP2PDestModel dest) {
    SheetX.showMessage(
      title: 'delete'.tr,
      message:
          'Apakah anda yakin ingin menghapus ${dest.name} dengan nomor rekening ${dest.account} ?',
      leftBtnTitle: 'yes'.tr,
      onLeftBtnClicked: () {
        Get.back();
      },
      rightBtnTitle: 'no'.tr,
      onRightBtnClicked: () {
        Get.back();
      },
    );
  }

  onAddClicked() {}
}
