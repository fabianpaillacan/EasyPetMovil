import 'package:easypet/core/services/api_config.dart';
import 'dart:convert';

class RegisterController {
  final ApiConfig _apiConfig;

  RegisterController({
    ApiConfig? apiConfig,
  }) : _apiConfig = apiConfig ?? ApiConfig();

  Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String rut,
    required String birthDate,
    required String phone,
    required String email,
    required String gender,
    required String password,
  }) async {
    try {
      final response = await _apiConfig.post(
        '${ApiConfig.baseUrl}/user/register',
        body: {
          'first_name': firstName,
          'last_name': lastName,
          'rut': rut,
          'birth_date': birthDate,
          'phone': phone,
          'email': email,
          'gender': gender,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Registro exitoso',
          'user': data['user'],
        };
      } else {
        return {
          'success': false,
          'message': 'Error en el backend: ${response.statusCode} - ${response.body}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al registrar usuario: $e',
      };
    }
  }
}
