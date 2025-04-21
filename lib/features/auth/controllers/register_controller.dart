import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class RegisterController {
  static Future<String> registerUser({
    required String firstName,
    required String lastName,
    required String rut,
    required String birthDate,
    required String phone,
    required String email,
    required String gender,
    required String password,
  }) async {
    final url = Uri.parse('http://10.0.2.2:8000/register'); 
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'rut': rut,
          'birth_date': birthDate,
          'phone': phone,
          'email': email,
          'gender': gender,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Registro exitoso';
      } else {
        return 'Error en el backend: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error al registrar usuario: $e';
    }
  }
}

