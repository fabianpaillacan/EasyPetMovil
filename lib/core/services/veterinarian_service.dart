import '../config/environment.dart';
import 'api_client.dart';
import 'auth_service.dart';

class VeterinarianService {
  static final ApiClient _client = ApiClient(baseUrl: EnvironmentConfig.veterinarianServiceUrl);
  
  static Future<List<Map<String, dynamic>>> getVeterinarians() async {
    try {
      final token = await AuthService.getValidToken();
      if (token == null) {
        throw Exception('No hay token válido disponible');
      }
      
      _client.setAuthToken(token);
      final response = await _client.get('/veterinarians');
      
      if (response.success) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception(response.error ?? 'Error al obtener veterinarios');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  static Future<Map<String, dynamic>> getVeterinarianProfile(String veterinarianId) async {
    try {
      final token = await AuthService.getValidToken();
      if (token == null) {
        throw Exception('No hay token válido disponible');
      }
      
      _client.setAuthToken(token);
      final response = await _client.get('/veterinarians/$veterinarianId');
      
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error ?? 'Error al obtener perfil del veterinario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  static Future<List<Map<String, dynamic>>> getVeterinarianAppointments(String veterinarianId) async {
    try {
      final token = await AuthService.getValidToken();
      if (token == null) {
        throw Exception('No hay token válido disponible');
      }
      
      _client.setAuthToken(token);
      final response = await _client.get('/veterinarians/$veterinarianId/appointments');
      
      if (response.success) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception(response.error ?? 'Error al obtener citas del veterinario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  static Future<Map<String, dynamic>> updateVeterinarianProfile(String veterinarianId, Map<String, dynamic> profileData) async {
    try {
      final token = await AuthService.getValidToken();
      if (token == null) {
        throw Exception('No hay token válido disponible');
      }
      
      _client.setAuthToken(token);
      final response = await _client.put('/veterinarians/$veterinarianId', body: profileData);
      
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error ?? 'Error al actualizar perfil del veterinario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
