import 'package:easypet/core/services/auth_service.dart';

class RegisterController {
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
      final result = await AuthService.register(
        email, 
        password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        rut: rut,
        birthDate: birthDate,
        gender: gender,
      );
      
      return {
        'success': result.success,
        'message': result.message,
        'token': result.token,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al registrar usuario: $e',
      };
    }
  }
}
