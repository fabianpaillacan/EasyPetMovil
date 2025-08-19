class ForgottenPasswordController {
  static Future<Map<String, dynamic>> resetPassword(String email) async {
    // Mock implementation for development
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'message': 'Password reset email sent (dev mode)',
    };
  }
}
