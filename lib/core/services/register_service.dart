import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/environment.dart';
import 'api_client.dart';

class RegisterService {
  static final ApiClient _client = ApiClient(baseUrl: EnvironmentConfig.userServiceUrl);
  
  static Future<String> registerUser(Map<String, dynamic> userData) async {
    try {
      final response = await _client.post('/register', body: userData);
      
      if (response.success) {
        return 'Registro exitoso';
      } else {
        throw Exception(response.error ?? 'Error al registrar usuario');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}