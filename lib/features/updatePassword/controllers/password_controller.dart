import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ChangePasswordController {
  static Future<String> updatePassword(String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return '❌ Usuario no autenticado';

      final token = await user.getIdToken();
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/update_password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'new_password': newPassword}),
      );

      if (response.statusCode == 200) {
        return '✅ Contraseña actualizada correctamente';
      } else {
        return '❌ Error: ${response.body}';
      }
    } catch (e) {
      return '❌ Error inesperado: $e';
    }
  }
}
