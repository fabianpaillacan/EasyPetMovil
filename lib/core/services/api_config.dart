import '../config/environment.dart';
import 'api_client.dart';

class ApiConfig {
  static final ApiClient _client = ApiClient(baseUrl: EnvironmentConfig.apiBaseUrl);
  
  static ApiClient get client => _client;
  
  // Convenience methods for backward compatibility
  static void setAuthToken(String token) {
    _client.setAuthToken(token);
  }
  
  static void clearAuthToken() {
    _client.clearAuthToken();
  }
  
  static Future<ApiResponse> post(String endpoint, {Map<String, dynamic>? body}) {
    return _client.post(endpoint, body: body);
  }
  
  static Future<ApiResponse> get(String endpoint) {
    return _client.get(endpoint);
  }
} 