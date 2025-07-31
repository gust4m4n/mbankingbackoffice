import 'dart:async';

// Platform-aware HTTP client - only works on web
class WebHttpClient {
  static Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> data,
    Map<String, String>? headers,
  }) async {
    try {
      print('[WebHttpClient] Making POST request to: $url');
      print('[WebHttpClient] Data: $data');
      print('[WebHttpClient] Headers: $headers');

      // For non-web platforms, this fallback is not needed
      // since the main HTTP client should work fine
      return {
        'statusCode': -1,
        'error': 'WebHttpClient fallback not available on this platform',
      };
    } catch (e) {
      print('[WebHttpClient] Exception: $e');
      return {'statusCode': -1, 'error': e.toString()};
    }
  }
}
