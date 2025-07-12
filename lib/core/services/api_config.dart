import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:8000';
  
  late final http.Client client;
  late final Map<String, String> headers;

  ApiConfig() {
    client = http.Client();
    headers = {
      'Content-Type': 'application/json',
    };
  }

  void setAuthToken(String token) {
    headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    headers.remove('Authorization');
  }

  Future<http.Response> post(String url, {Map<String, dynamic>? body}) {
    return client.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  Future<http.Response> get(String url) {
    return client.get(
      Uri.parse(url),
      headers: headers,
    );
  }
} 