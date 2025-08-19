import '../config/environment.dart';
import 'api_client.dart';

class MedicalCenterService {
  static final ApiClient _client = ApiClient(baseUrl: EnvironmentConfig.medicalCenterServiceUrl);
  
  static Future<List<Map<String, dynamic>>> getMedicalCenters(String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.get('/medical-centers');
      
      if (response.success) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception(response.error ?? 'Error al obtener centros médicos');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  static Future<Map<String, dynamic>> getMedicalCenterProfile(String centerId, String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.get('/medical-centers/$centerId');
      
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error ?? 'Error al obtener perfil del centro médico');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  static Future<List<Map<String, dynamic>>> getMedicalCenterVeterinarians(String centerId, String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.get('/medical-centers/$centerId/veterinarians');
      
      if (response.success) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception(response.error ?? 'Error al obtener veterinarios del centro médico');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  static Future<Map<String, dynamic>> updateMedicalCenterProfile(String centerId, Map<String, dynamic> profileData, String token) async {
    try {
      _client.setAuthToken(token);
      final response = await _client.put('/medical-centers/$centerId', body: profileData);
      
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error ?? 'Error al actualizar perfil del centro médico');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
