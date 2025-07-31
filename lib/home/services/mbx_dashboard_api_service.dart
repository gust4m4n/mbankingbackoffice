import 'package:mbankingbackoffice/apis/mbx_apis.dart';
import 'package:mbankingbackoffice/home/models/mbx_dashboard_model.dart';

class MbxDashboardApiService {
  /// Get dashboard statistics
  static Future<ApiXResponse> getDashboard() async {
    try {
      print('API Request - GET /api/admin/dashboard');

      final response = await MbxApi.get(
        endpoint: '/api/admin/dashboard',
        params: {},
        headers: {},
      );

      print('API Response - Status: ${response.statusCode}');
      print('API Response - Data Type: ${response.jason.mapValue.runtimeType}');
      print('API Response - Data: ${response.jason.mapValue}');

      return response;
    } catch (e) {
      print('Error getting dashboard: $e');
      rethrow;
    }
  }

  /// Parse dashboard response
  static MbxDashboardModel parseDashboardResponse(dynamic data) {
    try {
      print('Dashboard Data: $data');
      print('Dashboard Data Type: ${data.runtimeType}');

      if (data is Map<String, dynamic>) {
        return MbxDashboardModel.fromJson(data);
      } else {
        throw Exception(
          'Unexpected dashboard data format: ${data.runtimeType}',
        );
      }
    } catch (e) {
      print('Error parsing dashboard response: $e');
      print('Data: $data');
      rethrow;
    }
  }
}
