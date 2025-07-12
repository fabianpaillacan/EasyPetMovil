abstract class AuthService {
  Future<AuthResult> login(String email, String password);
  Future<AuthResult> register(String email, String password);
}

class AuthResult {
  final bool success;
  final String message;
  final String? token;

  AuthResult({
    required this.success,
    required this.message,
    this.token,
  });

  factory AuthResult.success(String message, {String? token}) {
    return AuthResult(
      success: true,
      message: message,
      token: token,
    );
  }

  factory AuthResult.failure(String message) {
    return AuthResult(
      success: false,
      message: message,
    );
  }
} 