import '../config/environment.dart';
import 'api_client.dart';

class RatingService {
  static final ApiClient _client = ApiClient(baseUrl: EnvironmentConfig.ratingServiceUrl);
  
  static Future<Map<String, dynamic>> createRating(Map<String, dynamic> ratingData, String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.post('/ratings', body: ratingData);
      
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error ?? 'Error al crear calificación');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  static Future<List<Map<String, dynamic>>> getVeterinarianRatings(String veterinarianId, String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.get('/veterinarians/$veterinarianId/ratings');
      
      if (response.success) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception(response.error ?? 'Error al obtener calificaciones del veterinario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  static Future<List<Map<String, dynamic>>> getMedicalCenterRatings(String centerId, String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.get('/medical-centers/$centerId/ratings');
      
      if (response.success) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception(response.error ?? 'Error al obtener calificaciones del centro médico');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  static Future<Map<String, dynamic>> updateRating(String ratingId, Map<String, dynamic> ratingData, String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.put('/ratings/$ratingId', body: ratingData);
      
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error ?? 'Error al actualizar calificación');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  static Future<bool> deleteRating(String ratingId, String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.delete('/ratings/$ratingId');
      
      return response.success;
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
