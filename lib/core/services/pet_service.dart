import '../config/environment.dart';
import 'api_client.dart';

class PetService {
  static final ApiClient _client = ApiClient(baseUrl: EnvironmentConfig.petServiceUrl);
  
  static Future<Map<String, dynamic>> registerPet(Map<String, dynamic> petData, String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.post('/', body: petData);
      
      if (response.success) {
        return response.data;
      } else {
        // Si hay un error en la respuesta, lanzar directamente
        throw Exception(response.error ?? 'Error al registrar mascota');
      }
    } catch (e) {
      // Solo envolver en "Error de conexión" si es un error de red real
      if (e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException') ||
          e.toString().contains('ConnectionException')) {
        throw Exception('Error de conexión: $e');
      }
      // Para otros errores, re-lanzar sin envolver
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>> getPetProfile(String petId, String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.get('/$petId');
      
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error ?? 'Error al obtener perfil de mascota');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException') ||
          e.toString().contains('ConnectionException')) {
        throw Exception('Error de conexión: $e');
      }
      rethrow;
    }
  }
  
  static Future<bool> deletePet(String petId, String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.delete('/$petId');
      
      return response.success;
    } catch (e) {
      if (e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException') ||
          e.toString().contains('ConnectionException')) {
        throw Exception('Error de conexión: $e');
      }
      rethrow;
    }
  }
  
  static Future<List<Map<String, dynamic>>> getUserPets(String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.get('/');
      
      if (response.success) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception(response.error ?? 'Error al obtener mascotas del usuario');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException') ||
          e.toString().contains('ConnectionException')) {
        throw Exception('Error de conexión: $e');
      }
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>> updatePet(String petId, Map<String, dynamic> petData, String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.put('/$petId', body: petData);
      
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error ?? 'Error al actualizar mascota');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException') ||
          e.toString().contains('ConnectionException')) {
        throw Exception('Error de conexión: $e');
      }
      rethrow;
    }
  }
  
  static Future<List<Map<String, dynamic>>> getAllPets(String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.get('/all/list');
      
      if (response.success) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception(response.error ?? 'Error al obtener todas las mascotas');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException') ||
          e.toString().contains('ConnectionException')) {
        throw Exception('Error de conexión: $e');
      }
      rethrow;
    }
  }
}
