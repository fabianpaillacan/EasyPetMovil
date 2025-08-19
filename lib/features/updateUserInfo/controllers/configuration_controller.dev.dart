import 'package:easypet/core/services/auth_service.dart';

class ConfigurationController {
  static Future<Map<String, dynamic>> getUserInfo() async {
    try {
      // Use mock token for development
      const mockToken = "dev_token_123";
      final result = await AuthService.getProfile(mockToken);
      return {
        'success': result.success,
        'message': result.message,
        'user': {'email': 'dev@example.com', 'name': 'Dev User'},
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error getting user info: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> updateUserInfo(Map<String, dynamic> userData) async {
    try {
      // Use mock token for development
      const mockToken = "dev_token_123";
      final result = await AuthService.updateProfile(mockToken, userData);
      return {
        'success': result.success,
        'message': result.message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error updating user info: $e',
      };
    }
  }
}
