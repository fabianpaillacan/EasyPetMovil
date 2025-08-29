import '../config/environment.dart';
import 'api_client.dart';
import 'auth_service.dart';

class AppointmentService {
  static final ApiClient _client = ApiClient(baseUrl: EnvironmentConfig.appointmentServiceUrl);
  
  static Future<Map<String, dynamic>> createAppointment(Map<String, dynamic> appointmentData) async {
    try {
      final token = await AuthService.getValidToken();
      if (token == null) {
        throw Exception('No hay token válido disponible');
      }
      
      _client.setAuthToken(token);
      final response = await _client.post('/create', body: appointmentData);
      
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error ?? 'Error al crear cita');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  static Future<Map<String, dynamic>> getAppointment(String appointmentId) async {
    try {
      final token = await AuthService.getValidToken();
      if (token == null) {
        throw Exception('No hay token válido disponible');
      }
      
      _client.setAuthToken(token);
      final response = await _client.get('/$appointmentId');
      
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error ?? 'Error al obtener cita');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  static Future<List<Map<String, dynamic>>> getUserAppointments() async {
    try {
      final token = await AuthService.getValidToken();
      if (token == null) {
        throw Exception('No hay token válido disponible');
      }
      
      _client.setAuthToken(token);
      final response = await _client.get('/user/appointments');
      
      if (response.success) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception(response.error ?? 'Error al obtener citas del usuario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  static Future<bool> cancelAppointment(String appointmentId) async {
    try {
      final token = await AuthService.getValidToken();
      if (token == null) {
        throw Exception('No hay token válido disponible');
      }
      
      _client.setAuthToken(token);
      final response = await _client.delete('/$appointmentId');
      
      return response.success;
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
  
  static Future<Map<String, dynamic>> updateAppointment(String appointmentId, Map<String, dynamic> appointmentData) async {
    try {
      final token = await AuthService.getValidToken();
      if (token == null) {
        throw Exception('No hay token válido disponible');
      }
      
      _client.setAuthToken(token);
      final response = await _client.put('/$appointmentId', body: appointmentData);
      
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.error ?? 'Error al actualizar cita');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
