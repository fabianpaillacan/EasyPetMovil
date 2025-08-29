import 'package:easypet/core/services/user_service.dart';

class ConfigurationController {
  static Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final userInfo = await UserService.getUserInfo();
      return {
        'success': true,
        'message': 'User info retrieved successfully',
        'user': userInfo,
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
      final result = await UserService.updateUserInfo(userData);
      return {
        'success': true,
        'message': 'User info updated successfully',
        'user': result,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Error updating user info: $e',
      };
    }
  }
}
