import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class AuthController {
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
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
        return {"success": false, "message": "Error al obtener el token"};
      }
      
      // Hacer ping al backend FastAPI
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/auth/user/ping'), //usar esto solo en emulador
        headers: {'Authorization': 'Bearer $idToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          "success": true,
          "message": data["message"] ?? "Login correcto pero sin mensaje",
        };
      } else {
        return {
          "success": false,
          "message":
              "Error en backend: ${response.statusCode} ${response.body}",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error en login: $e"};
    }
  }
}
