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
    print("=== FLUTTER REGISTER CONTROLLER: registerUser called ===");
    print("First Name: $firstName");
    print("Last Name: $lastName");
    print("RUT: $rut");
    print("Birth Date: $birthDate");
    print("Phone: $phone");
    print("Email: $email");
    print("Gender: $gender");
    print("Password: ${password.isNotEmpty ? '[PROVIDED]' : '[EMPTY]'}");
    print("=====================================================");
    
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
      
      print("=== FLUTTER REGISTER CONTROLLER: AuthService result ===");
      print("Success: ${result.success}");
      print("Message: ${result.message}");
      print("Token: ${result.token?.substring(0, 20) ?? 'None'}...");
      print("=====================================================");
      
      return {
        'success': result.success,
        'message': result.message,
        'token': result.token,
      };
    } catch (e) {
      print("=== FLUTTER REGISTER CONTROLLER: Error ===");
      print("Error type: ${e.runtimeType}");
      print("Error message: $e");
      print("=========================================");
      return {
        'success': false,
        'message': 'Error al registrar usuario: $e',
      };
    }
  }
}
