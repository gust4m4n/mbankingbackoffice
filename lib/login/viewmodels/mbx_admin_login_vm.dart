import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:mbankingbackoffice/apis/mbx_apis.dart';
import 'package:mbankingbackoffice/apis/mbx_baseurl_vm.dart';
import 'package:mbankingbackoffice/apis/web_http_client.dart';

class MbxAdminLoginResponse {
  final int status;
  final String message;
  final AdminLoginData? data;

  MbxAdminLoginResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory MbxAdminLoginResponse.fromJson(Map<String, dynamic> json) {
    return MbxAdminLoginResponse(
      status: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? AdminLoginData.fromJson(json['data']) : null,
    );
  }
}

class AdminLoginData {
  final AdminUser admin;
  final String accessToken;
  final int expiresIn;

  AdminLoginData({
    required this.admin,
    required this.accessToken,
    required this.expiresIn,
  });

  factory AdminLoginData.fromJson(Map<String, dynamic> json) {
    return AdminLoginData(
      admin: AdminUser.fromJson(json['admin']),
      accessToken: json['access_token'] ?? '',
      expiresIn: json['expires_in'] ?? 0,
    );
  }
}

class AdminUser {
  final int id;
  final String name;
  final String email;
  final String role;
  final String createdAt;
  final String updatedAt;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class MbxAdminLoginVM {
  static Future<MbxAdminLoginResponse> request({
    required String email,
    required String password,
  }) async {
    try {
      print('[DEBUG] Starting admin login request...');
      print('[DEBUG] Email: $email');
      print('[DEBUG] Base URL: ${MbxBaseUrlVM.baseUrl}');

      // Test basic connectivity first
      try {
        print('[DEBUG] Testing basic HTTP connectivity...');
        var testResponse = await http.get(
          Uri.parse('${MbxBaseUrlVM.baseUrl}/'),
        );
        print(
          '[DEBUG] Basic connectivity test - Status: ${testResponse.statusCode}',
        );
      } catch (e) {
        print('[DEBUG] Basic connectivity test failed: $e');
      }

      // Try MbxApi first
      try {
        print('[DEBUG] Trying MbxApi...');
        final response = await MbxApi.post(
          endpoint: '/api/admin/login',
          params: {'email': email, 'password': password},
          json: true,
        );

        print('[DEBUG] MbxApi Response status code: ${response.statusCode}');
        print('[DEBUG] MbxApi Response status: ${response.status}');
        print('[DEBUG] MbxApi Response message: ${response.message}');
        print('[DEBUG] MbxApi Response body: ${response.body}');

        if (response.statusCode == 200 && response.jason.mapValue.isNotEmpty) {
          print('[DEBUG] MbxApi Login successful, parsing response...');
          return MbxAdminLoginResponse.fromJson(response.jason.mapValue);
        } else if (response.statusCode > 0) {
          // Real HTTP error, not client error
          print(
            '[DEBUG] MbxApi Login failed with HTTP status: ${response.status}',
          );
          return MbxAdminLoginResponse(
            status: response.status,
            message: response.message.isNotEmpty
                ? response.message
                : 'Login gagal. Silakan coba lagi.',
          );
        } else {
          // Client error (-1), try WebHttpClient as fallback
          throw Exception('MbxApi client error: ${response.message}');
        }
      } catch (e) {
        print('[DEBUG] MbxApi failed: $e');

        // Fallback to WebHttpClient for web platform
        if (kIsWeb) {
          print('[DEBUG] Trying WebHttpClient fallback...');
          try {
            final webResponse = await WebHttpClient.post(
              url: '${MbxBaseUrlVM.baseUrl}/api/admin/login',
              data: {'email': email, 'password': password},
              headers: {
                'X-DEVICE-ID': 'web-client-fallback',
                'X-DEVICE-NAME': 'Flutter Web',
                'X-DEVICE-OS': 'Web',
                'X-DEVICE-OS-VERSION': '1.0',
                'X-DEVICE-OS-VERSION-CODE': '1.0',
              },
            );

            print('[DEBUG] WebHttpClient Response: $webResponse');

            if (webResponse['statusCode'] == 200 &&
                webResponse['data'] != null) {
              print('[DEBUG] WebHttpClient Login successful!');
              return MbxAdminLoginResponse.fromJson(webResponse['data']);
            } else {
              print('[DEBUG] WebHttpClient Login failed');
              return MbxAdminLoginResponse(
                status: webResponse['statusCode'] ?? 500,
                message:
                    webResponse['error'] ?? 'Login gagal dengan WebHttpClient.',
              );
            }
          } catch (webError) {
            print('[DEBUG] WebHttpClient also failed: $webError');
            return MbxAdminLoginResponse(
              status: 500,
              message: 'Kedua method HTTP gagal. Error: $webError',
            );
          }
        } else {
          return MbxAdminLoginResponse(
            status: 500,
            message: 'Terjadi kesalahan pada MbxApi: $e',
          );
        }
      }
    } catch (e) {
      print('[DEBUG] General exception in admin login: $e');
      return MbxAdminLoginResponse(
        status: 500,
        message: 'Terjadi kesalahan umum. Silakan coba lagi.',
      );
    }
  }
}
