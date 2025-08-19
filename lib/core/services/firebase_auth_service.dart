import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../config/environment.dart';
import 'auth_service.dart';

class FirebaseAuthServiceImpl {
  final FirebaseAuth _firebaseAuth;
  final http.Client _httpClient;

  FirebaseAuthServiceImpl({
    FirebaseAuth? firebaseAuth,
    http.Client? httpClient,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _httpClient = httpClient ?? http.Client();

  Future<AuthResult> login(String email, String password) async {
    try {
      // Authenticate with Firebase
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Get user token
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        return AuthResult.failure("Error al obtener el token");
      }
      
      print("Firebase login successful for: ${userCredential.user?.email}");
      
      // Sync with backend
      try {
        final response = await _httpClient.get(
          Uri.parse('${EnvironmentConfig.apiBaseUrl}/users/me'),
          headers: {'Authorization': 'Bearer $idToken'},
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return AuthResult.success(
            data["message"] ?? "Login exitoso",
            token: idToken,
          );
        } else {
          // Even if backend verification fails, Firebase auth succeeded
          return AuthResult.success(
            "Login exitoso con Firebase",
            token: idToken,
          );
        }
      } catch (backendError) {
        // If backend is not available, still return success for Firebase auth
        print("Backend verification failed: $backendError");
        return AuthResult.success(
          "Login exitoso con Firebase",
          token: idToken,
        );
      }
    } catch (e) {
      print("Firebase login error: $e");
      String errorMessage = "Error en login";
      
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = "Usuario no encontrado";
            break;
          case 'wrong-password':
            errorMessage = "Contraseña incorrecta";
            break;
          case 'invalid-email':
            errorMessage = "Email inválido";
            break;
          case 'user-disabled':
            errorMessage = "Usuario deshabilitado";
            break;
          default:
            errorMessage = "Error de autenticación: ${e.message}";
        }
      }
      
      return AuthResult.failure(errorMessage);
    }
  }

  Future<AuthResult> register(String email, String password, {
    String? name,
    String? phone,
    String? firstName,
    String? lastName,
    String? rut,
    String? birthDate,
    String? gender,
  }) async {
    try {
      // Create user in Firebase
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Get user token
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        return AuthResult.failure("Error al obtener el token después del registro");
      }

      print("Firebase registration successful for: ${userCredential.user?.email}");

      // Sync user data with backend using the new sync endpoint
      try {
        final userData = {
          'email': email,
          'firebase_uid': userCredential.user?.uid,
          'name': name ?? firstName ?? lastName ?? '',
          'phone': phone ?? '',
          'created_at': DateTime.now().toIso8601String(),
        };
        
        final response = await _httpClient.post(
          Uri.parse('${EnvironmentConfig.apiBaseUrl}/users/firebase/sync'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $idToken',
          },
          body: json.encode(userData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = json.decode(response.body);
          return AuthResult.success(
            "Usuario registrado exitosamente",
            token: idToken,
          );
        } else {
          // Even if backend sync fails, Firebase registration succeeded
          print("Backend sync failed with status: ${response.statusCode}");
          return AuthResult.success(
            "Usuario registrado exitosamente en Firebase",
            token: idToken,
          );
        }
      } catch (backendError) {
        // If backend is not available, still return success for Firebase registration
        print("Backend sync failed: $backendError");
        return AuthResult.success(
          "Usuario registrado exitosamente en Firebase",
          token: idToken,
        );
      }
    } catch (e) {
      print("Firebase registration error: $e");
      String errorMessage = "Error en registro";
      
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = "El email ya está en uso";
            break;
          case 'invalid-email':
            errorMessage = "Email inválido";
            break;
          case 'weak-password':
            errorMessage = "La contraseña es muy débil";
            break;
          default:
            errorMessage = "Error de registro: ${e.message}";
        }
      }
      
      return AuthResult.failure(errorMessage);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }
}
