import 'package:mbankingbackoffice/admin/models/mbx_admin_model.dart';
import 'package:mbankingbackoffice/apis/mbx_apis.dart';

class MbxAdminApiService {
  /// Get all admins with pagination
  static Future<ApiXResponse> getAdmins({
    int page = 1,
    int perPage = 10,
  }) async {
    return await MbxApi.get(
      endpoint: '/api/admin/admins',
      params: {'page': page.toString(), 'per_page': perPage.toString()},
      headers: {},
    );
  }

  /// Get admin by ID
  static Future<ApiXResponse> getAdmin(int id) async {
    return await MbxApi.get(
      endpoint: '/api/admin/admins/$id',
      params: {},
      headers: {},
    );
  }

  /// Create new admin
  static Future<ApiXResponse> createAdmin(MbxCreateAdminRequest request) async {
    return await MbxApi.post(
      endpoint: '/api/admin/admins',
      params: Map<String, Object>.from(request.toJson()),
      headers: {},
      json: true,
    );
  }

  /// Update admin
  static Future<ApiXResponse> updateAdmin(
    int id,
    MbxUpdateAdminRequest request,
  ) async {
    return await MbxApi.put(
      endpoint: '/api/admin/admins/$id',
      params: Map<String, Object>.from(request.toJson()),
      headers: {},
      json: true,
    );
  }

  /// Delete admin
  static Future<ApiXResponse> deleteAdmin(int id) async {
    return await MbxApi.delete(
      endpoint: '/api/admin/admins/$id',
      params: {},
      headers: {},
    );
  }

  /// Parse admin list response
  static MbxAdminListResponse parseAdminListResponse(
    Map<String, dynamic> data,
  ) {
    return MbxAdminListResponse.fromJson(data);
  }

  /// Parse single admin response
  static MbxAdminModel parseAdminResponse(Map<String, dynamic> data) {
    return MbxAdminModel.fromJson(data);
  }
}
