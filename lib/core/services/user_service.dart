import '../config/environment.dart';
import 'api_client.dart';

class UserService {
  static final ApiClient _client = ApiClient(baseUrl: EnvironmentConfig.userServiceUrl);
  
  static Future<Map<String, dynamic>> getUserInfo(String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.get('/information');
      
      if (response.success) {
        return response.data['user'] ?? {};
      } else {
        throw Exception(response.error ?? 'Error al obtener información del usuario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  static Future<Map<String, dynamic>> updateUserInfo(Map<String, dynamic> userData, String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.put('/update', body: userData);
      
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error ?? 'Error al actualizar usuario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}