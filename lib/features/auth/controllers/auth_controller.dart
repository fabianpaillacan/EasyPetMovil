import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AuthController {
  static Future<String> login(String email, String password) async {
    try {
      // Autenticación con Firebase
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      // Obtener el token del usuario
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        return "Error al obtener el token";
      }

      // Hacer ping al backend FastAPI
      final response = await http.get(
        Uri.parse(
          'http://10.0.2.2:8000/ping',
        ), // Asegúrate de usar esto solo en emulador
        headers: {'Authorization': 'Bearer $idToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["message"] ?? "Login correcto pero sin mensaje";
      } else {
        return "Error en backend: ${response.statusCode} ${response.body}";
      }
    } catch (e) {
      return "❌ Error en login: $e";
    }
  }
}
