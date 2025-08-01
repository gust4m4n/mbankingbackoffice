import 'package:mbankingbackoffice/home-tab/models/mbx_foreign_exchange_model.dart';
import 'package:mbankingbackoffice/utils/mbx_format_vm.dart';

import '../../widget-x/all_widgets.dart';

// ignore: must_be_immutable
class MbxForeignExchangeWidget extends StatelessWidget {
  final MbxForeignExchangeModel model;
  const MbxForeignExchangeWidget(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextX(
            model.currency,
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
            color: ColorX.black,
          ),
        ),
        ContainerX(width: 8.0),
        Expanded(
          child: TextX(
            MbxFormatVM.foreignExchange(value: model.buy),
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
            color: ColorX.black,
          ),
        ),
        ContainerX(width: 8.0),
        Expanded(
          child: TextX(
            MbxFormatVM.foreignExchange(value: model.sell),
            fontSize: 15.0,
            fontWeight: FontWeight.w400,
            color: ColorX.black,
          ),
        ),
      ],
    );
  }
}
