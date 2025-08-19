import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/environment.dart';
import 'firebase_auth_service.dart';

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
    return AuthResult(success: true, message: message, token: token);
  }

  factory AuthResult.failure(String message) {
    return AuthResult(success: false, message: message);
  }
}

class AuthService {
  static final FirebaseAuthServiceImpl _firebaseAuth = FirebaseAuthServiceImpl();

  static Future<AuthResult> login(String email, String password) async {
    return await _firebaseAuth.login(email, password);
  }

  static Future<AuthResult> register(String email, String password, {
    String? name,
    String? phone,
    String? firstName,
    String? lastName,
    String? rut,
    String? birthDate,
    String? gender,
  }) async {
    return await _firebaseAuth.register(email, password);
  }

  static Future<AuthResult> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${EnvironmentConfig.apiBaseUrl}/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AuthResult.success(
          data["message"] ?? "Profile retrieved successfully",
          token: token,
        );
      } else {
        return AuthResult.failure("Failed to get profile");
      }
    } catch (e) {
      return AuthResult.failure("Error getting profile: $e");
    }
  }

  static Future<AuthResult> updateProfile(String token, Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('${EnvironmentConfig.apiBaseUrl}/users/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AuthResult.success(
          data["message"] ?? "Profile updated successfully",
          token: token,
        );
      } else {
        return AuthResult.failure("Failed to update profile");
      }
    } catch (e) {
      return AuthResult.failure("Error updating profile: $e");
    }
  }
} 