import 'package:mbankingbackoffice/apis/mbx_apis.dart';
import 'package:mbankingbackoffice/user/models/mbx_user_model.dart';

class MbxUserApiService {
  /// Get all users with pagination, search, and filters
  static Future<ApiXResponse> getUsers({
    int page = 1,
    int perPage = 10,
    String? search,
    String? name,
    String? phone,
    String? status,
  }) async {
    try {
      final params = <String, String>{
        'page': page.toString(),
        'per_page': perPage.toString(),
      };

      // Add search parameters if provided
      if (search != null && search.isNotEmpty) {
        params['search'] = search;
      }
      if (name != null && name.isNotEmpty) {
        params['name'] = name;
      }
      if (phone != null && phone.isNotEmpty) {
        params['phone'] = phone;
      }
      if (status != null && status.isNotEmpty) {
        params['status'] = status;
      }

      print('API Request - GET /api/admin/users (page: $page, perPage: $perPage, search: $search, name: $name, phone: $phone, status: $status)');

      final response = await MbxApi.get(
        endpoint: '/api/admin/users',
        params: params,
        headers: {},
      );

      print('API Response - Status: ${response.statusCode}');
      print('API Response - Data Type: ${response.jason.mapValue.runtimeType}');
      print('API Response - Data: ${response.jason.mapValue}');

      return response;
    } catch (e) {
      print('Error getting users: $e');
      rethrow;
    }
  }

  /// Get user by ID
  static Future<ApiXResponse> getUserById(int userId) async {
    try {
      print('API Request - GET /api/users/$userId');

      final response = await MbxApi.get(
        endpoint: '/api/users/$userId',
        params: {},
        headers: {},
      );

      print('API Response - Status: ${response.statusCode}');
      print('API Response - Data: ${response.jason.mapValue}');

      return response;
    } catch (e) {
      print('Error getting user by ID: $e');
      rethrow;
    }
  }

  /// Delete user by ID
  static Future<ApiXResponse> deleteUser(int userId) async {
    try {
      print('API Request - DELETE /api/users/$userId');

      final response = await MbxApi.delete(
        endpoint: '/api/users/$userId',
        params: {},
        headers: {},
      );

      print('API Response - Status: ${response.statusCode}');
      print('API Response - Data: ${response.jason.mapValue}');

      return response;
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  /// Parse user list response
  static MbxUserListResponse parseUserListResponse(dynamic data) {
    try {
      print('User Data: $data');
      print('User Data Type: ${data.runtimeType}');

      if (data is Map<String, dynamic>) {
        // Handle paginated response structure
        final users = (data['users'] ?? data['data'] ?? []) as List<dynamic>;
        final userModels = users.map((user) {
          try {
            return MbxUserModel.fromJson(user);
          } catch (e) {
            print('Error parsing individual user: $e');
            print('User data: $user');
            rethrow;
          }
        }).toList();

        return MbxUserListResponse(
          users: userModels,
          total: data['total'] ?? userModels.length,
          page: data['page'] ?? 1,
          perPage: data['per_page'] ?? userModels.length,
          totalPages:
              data['total_pages'] ??
              ((data['total'] ?? userModels.length) /
                      (data['per_page'] ?? userModels.length))
                  .ceil(),
        );
      } else if (data is List<dynamic>) {
        // Handle direct array response
        final userModels = data.map((user) {
          try {
            return MbxUserModel.fromJson(user);
          } catch (e) {
            print('Error parsing individual user: $e');
            print('User data: $user');
            rethrow;
          }
        }).toList();

        return MbxUserListResponse(
          users: userModels,
          total: userModels.length,
          page: 1,
          perPage: userModels.length,
          totalPages: 1,
        );
      } else {
        throw Exception('Unexpected data format: ${data.runtimeType}');
      }
    } catch (e) {
      print('Error parsing user list response: $e');
      print('Data: $data');
      rethrow;
    }
  }

  /// Parse single user response
  static MbxUserModel parseUserResponse(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        // Handle object response
        return MbxUserModel.fromJson(data);
      } else {
        throw Exception('Unexpected user data format: ${data.runtimeType}');
      }
    } catch (e) {
      print('Error parsing user response: $e');
      print('Data: $data');
      rethrow;
    }
  }
}
