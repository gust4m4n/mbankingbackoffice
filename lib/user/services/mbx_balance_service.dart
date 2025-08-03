import 'package:mbankingbackoffice/apis/mbx_apis.dart';

class MbxBalanceService {
  static const String _basePath = '/api/admin/users';

  /// Topup user balance
  static Future<ApiXResponse> topupBalance({
    required int userId,
    required double amount,
    required String description,
  }) async {
    try {
      final params = {'amount': amount, 'description': description};

      print(
        'API Request - POST $_basePath/$userId/topup (amount: $amount, description: $description)',
      );

      final response = await MbxApi.post(
        endpoint: '$_basePath/$userId/topup',
        params: params,
        headers: {},
        json: true,
      );

      print('API Response - Status: ${response.statusCode}');
      print('API Response - Data: ${response.jason.mapValue}');

      return response;
    } catch (e) {
      print('Error topup balance: $e');
      rethrow;
    }
  }

  /// Adjust user balance (positive for credit, negative for debit)
  static Future<ApiXResponse> adjustBalance({
    required int userId,
    required double amount,
    required String reason,
    required String type,
    required String description,
  }) async {
    try {
      final params = {
        'amount': amount,
        'reason': reason,
        'type': type,
        'description': description,
      };

      print(
        'API Request - POST $_basePath/$userId/adjust (amount: $amount, reason: $reason, type: $type)',
      );

      final response = await MbxApi.post(
        endpoint: '$_basePath/$userId/adjust',
        params: params,
        headers: {},
        json: true,
      );

      print('API Response - Status: ${response.statusCode}');
      print('API Response - Data: ${response.jason.mapValue}');

      return response;
    } catch (e) {
      print('Error adjusting balance: $e');
      rethrow;
    }
  }

  /// Set exact user balance
  static Future<ApiXResponse> setBalance({
    required int userId,
    required double amount,
    required String reason,
    String? description,
  }) async {
    try {
      final params = {
        'amount': amount,
        'reason': reason,
        if (description != null && description.isNotEmpty)
          'description': description,
      };

      print(
        'API Request - POST $_basePath/$userId/set-balance (amount: $amount, reason: $reason)',
      );

      final response = await MbxApi.post(
        endpoint: '$_basePath/$userId/set-balance',
        params: params,
        headers: {},
        json: true,
      );

      print('API Response - Status: ${response.statusCode}');
      print('API Response - Data: ${response.jason.mapValue}');

      return response;
    } catch (e) {
      print('Error set balance: $e');
      rethrow;
    }
  }

  /// Get user balance history
  static Future<ApiXResponse> getBalanceHistory({
    required int userId,
    int page = 1,
    int limit = 20,
    String? type,
  }) async {
    try {
      final params = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (type != null && type.isNotEmpty) 'type': type,
      };

      print(
        'API Request - GET $_basePath/$userId/balance-history (page: $page, limit: $limit, type: $type)',
      );

      final response = await MbxApi.get(
        endpoint: '$_basePath/$userId/balance-history',
        params: params,
        headers: {},
      );

      print('API Response - Status: ${response.statusCode}');
      print('API Response - Data: ${response.jason.mapValue}');

      return response;
    } catch (e) {
      print('Error get balance history: $e');
      rethrow;
    }
  }
}
