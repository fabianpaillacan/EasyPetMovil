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
      
      // Return success with Firebase token (will be exchanged for JWT in main auth service)
      return AuthResult.success(
        "Login exitoso con Firebase",
        accessToken: idToken,
      );
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

      // Return success with Firebase token (will be exchanged for JWT in main auth service)
      return AuthResult.success(
        "Usuario registrado exitosamente en Firebase",
        accessToken: idToken,
      );
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
          case 'operation-not-allowed':
            errorMessage = "Registro no habilitado";
            break;
          case 'weak-password':
            errorMessage = "Contraseña muy débil";
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
