import 'package:mbankingbackoffice/transfer/p2p/models/mbx_transfer_p2p_dest_model.dart';
import 'package:mbankingbackoffice/utils/mbx_format_vm.dart';

import '../../../widget-x/all_widgets.dart';

// ignore: must_be_immutable
class MbxTransferP2PPickerWidget extends StatelessWidget {
  final MbxTransferP2PDestModel dest;
  final GestureTapCallback? onDeleteClicked;

  const MbxTransferP2PPickerWidget({
    super.key,
    required this.dest,
    required this.onDeleteClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0, bottom: 8.0),
      child: Row(
        children: [
          ImageX(
            faIcon: FontAwesomeIcons.solidUser,
            backgroundColor: ColorX.transparent,
            width: 50.0,
            height: 50.0,
            cornerRadius: 8.0,
            borderWidth: 0.5,
            borderColor: ColorX.gray,
            padding: EdgeInsets.all(16.0),
          ),
          ContainerX(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextX(
                  dest.name,
                  color: ColorX.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.start,
                  maxLines: 8,
                ),
                ContainerX(height: 2.0),
                TextX(
                  MbxFormatVM.formatAccount(dest.account),
                  color: ColorX.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start,
                  maxLines: 8,
                ),
              ],
            ),
          ),
          ContainerX(width: 8.0),
          ButtonX(
            title: '',
            faIcon: FontAwesomeIcons.trashCan,
            iconWidth: 20.0,
            iconHeight: 16.0,
            width: 40.0,
            height: 40.0,
            backgroundColor: ColorX.transparent,
            clicked: onDeleteClicked,
          ),
        ],
      ),
    );
  }
}
