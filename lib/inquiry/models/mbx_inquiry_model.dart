import 'package:mbankingbackoffice/receipt/models/mbx_label_value_model.dart';

import '../../utils/all_utils.dart';

class MbxInquiryModel {
  List<MbxLabelValueModel> details = [];
  String transactionId = '';

  MbxInquiryModel();

  MbxInquiryModel.fromJason(Jason jason) {
    for (final item in jason['details'].jasonListValue) {
      final detail = MbxLabelValueModel(item);
      details.add(detail);
    }
    transactionId = jason['transaction_id'].stringValue;
  }
}
