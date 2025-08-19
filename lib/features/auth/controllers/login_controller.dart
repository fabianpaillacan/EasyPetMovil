import 'package:easypet/core/services/auth_service.dart';

class AuthController {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await AuthService.login(email, password);
    
    return {
      "success": result.success,
      "message": result.message,
      "token": result.token,
    };
  }
}
