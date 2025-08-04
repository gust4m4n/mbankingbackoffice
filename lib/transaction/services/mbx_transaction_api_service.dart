import 'package:mbankingbackoffice/apis/mbx_apis.dart';
import 'package:mbankingbackoffice/transaction/models/mbx_transaction_model.dart';

class MbxTransactionApiService {
  static const String _baseUrl = '/api/admin/transactions';

  /// Get all transactions with pagination and optional filtering
  static Future<ApiXResponse> getTransactions({
    int page = 1,
    int perPage = 10,
    String? search,
    String? userId,
    String? type,
    String? status,
    String? startDate,
    String? endDate,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'limit': perPage.toString(),
    };

    if (search != null && search.isNotEmpty) {
      params['search'] = search;
    }
    if (userId != null && userId.isNotEmpty) {
      params['user_id'] = userId;
    }
    if (type != null && type.isNotEmpty) {
      params['type'] = type;
    }
    if (status != null && status.isNotEmpty) {
      params['status'] = status;
    }
    if (startDate != null && startDate.isNotEmpty) {
      params['start_date'] = startDate;
    }
    if (endDate != null && endDate.isNotEmpty) {
      params['end_date'] = endDate;
    }

    return await MbxApi.get(endpoint: _baseUrl, params: params, headers: {});
  }

  /// Get transaction details by ID
  static Future<ApiXResponse> getTransactionById(String transactionId) async {
    return await MbxApi.get(
      endpoint: '$_baseUrl/$transactionId',
      params: {},
      headers: {},
    );
  }

  /// Reverse a transaction (admin only)
  static Future<ApiXResponse> reverseTransaction(
    MbxTransactionReversalRequest request,
  ) async {
    return await MbxApi.post(
      endpoint: '$_baseUrl/reversal',
      params: Map<String, Object>.from(request.toJson()),
      headers: {},
      json: true,
    );
  }

  /// Parse transaction list response
  static MbxTransactionListResponse parseTransactionListResponse(
    Map<String, dynamic> data,
  ) {
    return MbxTransactionListResponse.fromJson(data);
  }

  /// Parse single transaction response
  static MbxTransactionModel parseTransactionResponse(
    Map<String, dynamic> data,
  ) {
    return MbxTransactionModel.fromJson(data);
  }
}
