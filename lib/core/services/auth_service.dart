import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/environment.dart';
import 'firebase_auth_service.dart';

class AuthResult {
  final bool success;
  final String message;
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final Map<String, dynamic>? user;

  AuthResult({
    required this.success,
    required this.message,
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.user,
  });

  factory AuthResult.success(String message, {
    String? accessToken,
    String? refreshToken,
    int? expiresIn,
    Map<String, dynamic>? user,
  }) {
    return AuthResult(
      success: true, 
      message: message,
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
      user: user,
    );
  }

  factory AuthResult.failure(String message) {
    return AuthResult(success: false, message: message);
  }

  // Legacy support for existing code
  String? get token => accessToken;
}

class AuthService {
  static final FirebaseAuthServiceImpl _firebaseAuth = FirebaseAuthServiceImpl();
  
  // Token storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  
  // In-memory cache for performance
  static String? _accessToken;
  static String? _refreshToken;
  static DateTime? _tokenExpiry;

  // Getters for token management
  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;
  static bool get isTokenExpired => _tokenExpiry == null || DateTime.now().isAfter(_tokenExpiry!);

  // Load tokens from persistent storage
  static Future<void> _loadTokensFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _accessToken = prefs.getString(_accessTokenKey);
      _refreshToken = prefs.getString(_refreshTokenKey);
      
      final expiryString = prefs.getString(_tokenExpiryKey);
      if (expiryString != null) {
        _tokenExpiry = DateTime.parse(expiryString);
      }
      
      developer.log('🔐 AUTH: Loaded tokens from storage');
      developer.log('🔐 AUTH: Access token: ${_accessToken?.substring(0, 20)}...');
      developer.log('🔐 AUTH: Token expiry: $_tokenExpiry');
    } catch (e) {
      developer.log('❌ AUTH: Error loading tokens from storage: $e');
    }
  }

  // Save tokens to persistent storage
  static Future<void> _saveTokensToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_accessToken != null) {
        await prefs.setString(_accessTokenKey, _accessToken!);
      }
      if (_refreshToken != null) {
        await prefs.setString(_refreshTokenKey, _refreshToken!);
      }
      if (_tokenExpiry != null) {
        await prefs.setString(_tokenExpiryKey, _tokenExpiry!.toIso8601String());
      }
      
      developer.log('🔐 AUTH: Saved tokens to storage');
    } catch (e) {
      developer.log('❌ AUTH: Error saving tokens to storage: $e');
    }
  }

  // Clear tokens from persistent storage
  static Future<void> _clearTokensFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_tokenExpiryKey);
      
      developer.log('🔐 AUTH: Cleared tokens from storage');
    } catch (e) {
      developer.log('❌ AUTH: Error clearing tokens from storage: $e');
    }
  }

  static Future<AuthResult> login(String email, String password) async {
    try {
      developer.log('🔐 AUTH: Starting login process for $email');
      
      // Step 1: Authenticate with Firebase
      developer.log('🔐 AUTH: Step 1 - Authenticating with Firebase...');
      final firebaseResult = await _firebaseAuth.login(email, password);
      
      if (!firebaseResult.success) {
        developer.log('❌ AUTH: Firebase authentication failed: ${firebaseResult.message}');
        return firebaseResult;
      }

      developer.log('✅ AUTH: Firebase authentication successful');
      developer.log('🔐 AUTH: Firebase token received: ${firebaseResult.accessToken?.substring(0, 50)}...');

      // Step 2: Exchange Firebase token for JWT tokens
      developer.log('🔐 AUTH: Step 2 - Exchanging Firebase token for JWT...');
      final jwtResult = await _exchangeFirebaseTokenForJWT(firebaseResult.accessToken!);
      
      if (jwtResult.success) {
        developer.log('✅ AUTH: JWT token exchange successful');
        developer.log('🔐 AUTH: Access token: ${jwtResult.accessToken?.substring(0, 50)}...');
        developer.log('🔐 AUTH: Refresh token: ${jwtResult.refreshToken?.substring(0, 50)}...');
        developer.log('⏰ AUTH: Token expires in: ${jwtResult.expiresIn} seconds');
        
        // Store tokens
        _accessToken = jwtResult.accessToken;
        _refreshToken = jwtResult.refreshToken;
        _tokenExpiry = DateTime.now().add(Duration(seconds: jwtResult.expiresIn ?? 900));
        
        // Save tokens to persistent storage
        await _saveTokensToStorage();
        
        return jwtResult;
      } else {
        developer.log('❌ AUTH: JWT token exchange failed: ${jwtResult.message}');
        return jwtResult;
      }
    } catch (e) {
      developer.log('❌ AUTH: Login process error: $e');
      return AuthResult.failure("Error en login: $e");
    }
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
    try {
      // Step 1: Register with Firebase
      final firebaseResult = await _firebaseAuth.register(
        email, 
        password,
        name: name,
        phone: phone,
        firstName: firstName,
        lastName: lastName,
        rut: rut,
        birthDate: birthDate,
        gender: gender,
      );
      
      if (!firebaseResult.success) {
        return firebaseResult;
      }

      // Step 2: Exchange Firebase token for JWT tokens
      final jwtResult = await _exchangeFirebaseTokenForJWT(firebaseResult.accessToken!);
      
      if (jwtResult.success) {
        // Store tokens
        _accessToken = jwtResult.accessToken;
        _refreshToken = jwtResult.refreshToken;
        _tokenExpiry = DateTime.now().add(Duration(seconds: jwtResult.expiresIn ?? 900));
        
        // Save tokens to persistent storage
        await _saveTokensToStorage();
        
        return jwtResult;
      } else {
        return jwtResult;
      }
    } catch (e) {
      return AuthResult.failure("Error en registro: $e");
    }
  }

  static Future<AuthResult> _exchangeFirebaseTokenForJWT(String firebaseToken) async {
    try {
      developer.log('🔐 AUTH: Sending request to ${EnvironmentConfig.apiBaseUrl}/auth/firebase-login');
      developer.log('🔐 AUTH: Request payload: {"id_token": "${firebaseToken.substring(0, 50)}..."}');
      
      final response = await http.post(
        Uri.parse('${EnvironmentConfig.apiBaseUrl}/auth/firebase-login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id_token': firebaseToken,
        }),
      );

      developer.log('🔐 AUTH: Response status code: ${response.statusCode}');
      developer.log('🔐 AUTH: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        developer.log('✅ AUTH: JWT exchange successful, response data: $data');
        return AuthResult.success(
          data["message"] ?? "Login exitoso",
          accessToken: data["access_token"],
          refreshToken: data["refresh_token"],
          expiresIn: data["expires_in"],
          user: data["user"],
        );
      } else {
        final errorData = json.decode(response.body);
        developer.log('❌ AUTH: JWT exchange failed with status ${response.statusCode}: $errorData');
        return AuthResult.failure(errorData["detail"] ?? "Error en autenticación");
      }
    } catch (e) {
      developer.log('❌ AUTH: JWT exchange request error: $e');
      return AuthResult.failure("Error en comunicación con el servidor: $e");
    }
  }

  static Future<AuthResult> refreshAccessToken() async {
    if (_refreshToken == null) {
      developer.log('❌ AUTH: No refresh token available');
      return AuthResult.failure("No hay token de refresco disponible");
    }

    try {
      developer.log('🔐 AUTH: Refreshing access token...');
      developer.log('🔐 AUTH: Refresh token: ${_refreshToken!.substring(0, 50)}...');
      
      final response = await http.post(
        Uri.parse('${EnvironmentConfig.apiBaseUrl}/auth/refresh'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'refresh_token': _refreshToken,
        }),
      );

      developer.log('🔐 AUTH: Refresh response status: ${response.statusCode}');
      developer.log('🔐 AUTH: Refresh response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Update stored tokens
        _accessToken = data["access_token"];
        _tokenExpiry = DateTime.now().add(Duration(seconds: data["expires_in"] ?? 900));
        
        // Save updated tokens to storage
        await _saveTokensToStorage();
        
        developer.log('✅ AUTH: Token refreshed successfully');
        developer.log('🔐 AUTH: New access token: ${_accessToken!.substring(0, 50)}...');
        
        return AuthResult.success(
          data["message"] ?? "Token refrescado exitosamente",
          accessToken: data["access_token"],
          expiresIn: data["expires_in"],
        );
      } else {
        final errorData = json.decode(response.body);
        developer.log('❌ AUTH: Token refresh failed: $errorData');
        return AuthResult.failure(errorData["detail"] ?? "Error al refrescar token");
      }
    } catch (e) {
      developer.log('❌ AUTH: Token refresh error: $e');
      return AuthResult.failure("Error al refrescar token: $e");
    }
  }

  static Future<String?> getValidToken() async {
    developer.log('🔐 AUTH: Getting valid token...');
    
    // If tokens are not in memory, try to load from storage
    if (_accessToken == null) {
      developer.log('🔐 AUTH: Tokens not in memory, loading from storage...');
      await _loadTokensFromStorage();
    }
    
    developer.log('🔐 AUTH: Current token expiry: $_tokenExpiry');
    developer.log('🔐 AUTH: Is token expired: $isTokenExpired');
    
    // If token is expired or will expire soon (within 1 minute), refresh it
    if (isTokenExpired || (_tokenExpiry != null && 
        _tokenExpiry!.difference(DateTime.now()).inMinutes < 1)) {
      developer.log('🔐 AUTH: Token expired or expiring soon, refreshing...');
      final refreshResult = await refreshAccessToken();
      if (!refreshResult.success) {
        developer.log('❌ AUTH: Failed to refresh token: ${refreshResult.message}');
        return null;
      }
    }
    
    developer.log('✅ AUTH: Returning valid token: ${_accessToken?.substring(0, 50)}...');
    return _accessToken;
  }

  static Future<AuthResult> getProfile() async {
    final token = await getValidToken();
    if (token == null) {
      return AuthResult.failure("No hay token válido disponible");
    }

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
          data["message"] ?? "Perfil obtenido exitosamente",
          accessToken: token,
        );
      } else {
        return AuthResult.failure("Error al obtener perfil");
      }
    } catch (e) {
      return AuthResult.failure("Error al obtener perfil: $e");
    }
  }

  static Future<AuthResult> updateProfile(Map<String, dynamic> userData) async {
    final token = await getValidToken();
    if (token == null) {
      return AuthResult.failure("No hay token válido disponible");
    }

    try {
      final response = await http.put(
        Uri.parse('${EnvironmentConfig.apiBaseUrl}/users/user/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AuthResult.success(
          data["message"] ?? "Perfil actualizado exitosamente",
          accessToken: token,
        );
      } else {
        return AuthResult.failure("Error al actualizar perfil");
      }
    } catch (e) {
      return AuthResult.failure("Error al actualizar perfil: $e");
    }
  }

  static Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
    
    // Clear tokens from persistent storage
    await _clearTokensFromStorage();
    
    developer.log('🔐 AUTH: Logout completed, tokens cleared');
  }
} 