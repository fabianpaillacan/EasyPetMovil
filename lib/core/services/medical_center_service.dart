import '../config/environment.dart';
import 'api_client.dart';
import 'auth_service.dart';

class MedicalCenterService {
  static final ApiClient _client = ApiClient(baseUrl: EnvironmentConfig.medicalCenterServiceUrl);
  
  static Future<List<Map<String, dynamic>>> getMedicalCenters() async {
    try {
      final token = await AuthService.getValidToken();
      if (token == null) {
        throw Exception('No hay token válido disponible');
      }
      
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
  
  static Future<Map<String, dynamic>> getMedicalCenterProfile(String centerId) async {
    try {
      final token = await AuthService.getValidToken();
      if (token == null) {
        throw Exception('No hay token válido disponible');
      }
      
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
  
  static Future<List<Map<String, dynamic>>> getMedicalCenterVeterinarians(String centerId) async {
    try {
      final token = await AuthService.getValidToken();
      if (token == null) {
        throw Exception('No hay token válido disponible');
      }
      
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
  
  static Future<Map<String, dynamic>> updateMedicalCenterProfile(String centerId, Map<String, dynamic> profileData) async {
    try {
      final token = await AuthService.getValidToken();
      if (token == null) {
        throw Exception('No hay token válido disponible');
      }
      
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
