import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  static const String baseUrl = 'http://10.0.2.2:8008'; // Para emulador Android
  // static const String baseUrl = 'http://localhost:8008'; // Para dispositivo físico

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  // Get access token from local storage
  static Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_accessTokenKey);
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }

  // Get refresh token from local storage
  static Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (e) {
      print('Error getting refresh token: $e');
      return null;
    }
  }

  // Get user ID from local storage
  static Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userIdKey);
    } catch (e) {
      print('Error getting user ID: $e');
      return null;
    }
  }

  // Store tokens in local storage
  static Future<bool> storeTokens({
    required String accessToken,
    required String refreshToken,
    String? userId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, accessToken);
      await prefs.setString(_refreshTokenKey, refreshToken);
      if (userId != null) {
        await prefs.setString(_userIdKey, userId);
      }
      return true;
    } catch (e) {
      print('Error storing tokens: $e');
      return false;
    }
  }

  // Clear tokens from local storage
  static Future<bool> clearTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_userIdKey);
      return true;
    } catch (e) {
      print('Error clearing tokens: $e');
      return false;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // Login with email and password
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Store tokens
          await storeTokens(
            accessToken: data['access_token'],
            refreshToken: data['refresh_token'],
            userId: data['user']?['user_id'],
          );
          
          return {
            'success': true,
            'data': data,
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Error en el login',
          };
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['detail'] ?? 'Error en el servidor',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // Login with Firebase token
  static Future<Map<String, dynamic>> firebaseLogin({
    required String idToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/firebase-login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id_token': idToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Store tokens
          await storeTokens(
            accessToken: data['access_token'],
            refreshToken: data['refresh_token'],
            userId: data['user']?['user_id'],
          );
          
          return {
            'success': true,
            'data': data,
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Error en el login',
          };
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['detail'] ?? 'Error en el servidor',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // Refresh access token
  static Future<Map<String, dynamic>> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        return {
          'success': false,
          'message': 'No hay refresh token',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'refresh_token': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Store new tokens
          await storeTokens(
            accessToken: data['access_token'],
            refreshToken: data['refresh_token'] ?? refreshToken,
          );
          
          return {
            'success': true,
            'data': data,
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Error al refrescar el token',
          };
        }
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['detail'] ?? 'Error en el servidor',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // Logout
  static Future<bool> logout() async {
    try {
      // Clear local tokens
      await clearTokens();
      
      // Optionally call logout endpoint
      final token = await getAccessToken();
      if (token != null) {
        try {
          await http.post(
            Uri.parse('$baseUrl/auth/logout'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );
        } catch (e) {
          // Ignore logout endpoint errors
          print('Logout endpoint error: $e');
        }
      }
      
      return true;
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }

  // Verify if current token is valid
  static Future<bool> isTokenValid() async {
    try {
      final token = await getAccessToken();
      if (token == null) return false;

      final response = await http.get(
        Uri.parse('$baseUrl/auth/verify'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error verifying token: $e');
      return false;
    }
  }
}
