class PasswordController {
  static Future<Map<String, dynamic>> updatePassword(String newPassword) async {
    // Mock implementation for development
    await Future.delayed(const Duration(seconds: 1));
    return {
      'success': true,
      'message': 'Password updated successfully (dev mode)',
    };
  }
}

class ChangePasswordController {
  static Future<String> updatePassword(String newPassword) async {
    // Mock implementation for development
    await Future.delayed(const Duration(seconds: 1));
    return 'Contraseña actualizada correctamente';
  }
}
