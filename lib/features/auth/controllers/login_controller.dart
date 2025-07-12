import 'package:easypet/core/services/auth_service.dart';
import 'package:easypet/core/services/firebase_auth_service.dart';

class AuthController {
  final AuthService _authService;

  AuthController({AuthService? authService}) 
    : _authService = authService ?? FirebaseAuthServiceImpl();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await _authService.login(email, password);
    
    return {
      "success": result.success,
      "message": result.message,
    };
  }
}
