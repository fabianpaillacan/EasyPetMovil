import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/environment.dart';

class ApiResponse {
  final bool success;
  final dynamic data;
  final String? error;
  final int statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.error,
    required this.statusCode,
  });

  factory ApiResponse.fromHttpResponse(http.Response response) {
    final body = jsonDecode(response.body);
    
    // Handle different response formats
    dynamic data;
    String? error;
    
    if (body is Map<String, dynamic>) {
      // Response is a map/object
      data = body['data'] ?? body;
      error = body['error'] ?? body['message'];
    } else if (body is List) {
      // Response is a list (like pets list)
      data = body;
      error = null;
    } else {
      // Response is a primitive type
      data = body;
      error = null;
    }
    
    return ApiResponse(
      success: response.statusCode >= 200 && response.statusCode < 300,
      data: data,
      error: error,
      statusCode: response.statusCode,
    );
  }

  factory ApiResponse.error(String error, {int statusCode = 500}) {
    return ApiResponse(
      success: false,
      error: error,
      statusCode: statusCode,
    );
  }
}

class ApiClient {
  final String baseUrl;
  final Map<String, String> _headers;
  String? _authToken;

  ApiClient({required this.baseUrl}) : _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  void setAuthToken(String token) {
    _authToken = token;
    _headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _authToken = null;
    _headers.remove('Authorization');
  }

  Future<ApiResponse> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      ).timeout(EnvironmentConfig.requestTimeout);

      return ApiResponse.fromHttpResponse(response);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(EnvironmentConfig.requestTimeout);

      return ApiResponse.fromHttpResponse(response);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(EnvironmentConfig.requestTimeout);

      return ApiResponse.fromHttpResponse(response);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  Future<ApiResponse> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      ).timeout(EnvironmentConfig.requestTimeout);

      return ApiResponse.fromHttpResponse(response);
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // Upload file
  Future<ApiResponse> uploadFile(String endpoint, String filePath, String fieldName) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));
      
      // Add headers
      request.headers.addAll(_headers);
      
      // Add file
      request.files.add(await http.MultipartFile.fromPath(fieldName, filePath));
      
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      return ApiResponse(
        success: response.statusCode >= 200 && response.statusCode < 300,
        data: jsonDecode(responseBody),
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error('Upload error: $e');
    }
  }
} 