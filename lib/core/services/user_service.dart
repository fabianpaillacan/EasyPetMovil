import '../config/environment.dart';
import 'api_client.dart';

class UserService {
  static final ApiClient _client = ApiClient(baseUrl: EnvironmentConfig.userServiceUrl);
  
  static Future<Map<String, dynamic>> getUserInfo(String token) async {
    try {
      _client.setAuthToken(token);
      // Corregir el endpoint para que coincida con el backend
      final response = await _client.get('/user/information');
      
      if (response.success) {
        // El backend devuelve {"user": {...}}, extraer solo los datos del usuario
        final userData = response.data['user'] ?? {};
        
        // Mapear los campos del backend a los que espera la app móvil
        return {
          'first_name': userData['name'] ?? '',
          'last_name': userData['last_name'] ?? '',
          'birth_date': userData['birth_date'] ?? '',
          'email': userData['email'] ?? '',
          'phone': userData['phone'] ?? '',
          'gender': userData['gender'] ?? '',
          'rut': userData['rut'] ?? '',
          'firebase_uid': userData['firebase_uid'] ?? '',
          'veterinarian_id': userData['veterinarian_id'] ?? '',
          'is_active': userData['is_active'] ?? true,
          'user_id': userData['user_id'] ?? '',
          'created_at': userData['created_at'] ?? '',
          'updated_at': userData['updated_at'] ?? '',
        };
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
      
      // Mapear los campos de la app móvil a los del backend
      final backendData = {
        'name': userData['first_name'] ?? '',
        'last_name': userData['last_name'] ?? '',
        'birth_date': userData['birth_date'] ?? '',
        'phone': userData['phone'] ?? '',
        'gender': userData['gender'] ?? '',
        'rut': userData['rut'] ?? '',  // Preservar RUT existente
        'firebase_uid': userData['firebase_uid'] ?? '',  // Preservar
        'veterinarian_id': userData['veterinarian_id'] ?? '',  // Preservar
      };
      
      final response = await _client.put('/user/update', body: backendData);
      
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