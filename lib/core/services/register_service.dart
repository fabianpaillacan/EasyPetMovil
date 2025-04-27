import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterService {
  static Future<String> registerUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );

    if (response.statusCode == 201) {
      return 'Registro exitoso';
    } else {
      throw Exception('Error al registrar usuario');
    }
  }
}