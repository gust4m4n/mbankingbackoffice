class MbxBaseUrlVM {
  static String baseUrl = 'http://127.0.0.1:8080';
  // static String baseUrl = 'https://0.0.0.0:8443'; // TLS certificate issue

  static String apiUrl(String endpoint) {
    if (endpoint.toLowerCase().startsWith('http://') ||
        endpoint.toLowerCase().startsWith('https://')) {
      return endpoint;
    } else {
      return baseUrl + endpoint;
    }
  }
}
