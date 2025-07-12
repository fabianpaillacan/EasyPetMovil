import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class FirebaseAuthServiceImpl implements AuthService {
  final FirebaseAuth _firebaseAuth;
  final http.Client _httpClient;

  FirebaseAuthServiceImpl({
    FirebaseAuth? firebaseAuth,
    http.Client? httpClient,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _httpClient = httpClient ?? http.Client();

  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      // Autenticación con Firebase
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Obtener el token del usuario
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        return AuthResult.failure("Error al obtener el token");
      }
      
      // Hacer ping al backend FastAPI
      final response = await _httpClient.get(
        Uri.parse(ApiConfig.authPingUrl),
        headers: {'Authorization': 'Bearer $idToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AuthResult.success(
          data["message"] ?? "Login correcto pero sin mensaje",
          token: idToken,
        );
      } else {
        return AuthResult.failure(
          "Error en backend: ${response.statusCode} ${response.body}",
        );
      }
    } catch (e) {
      return AuthResult.failure("Error en login: $e");
    }
  }
}
