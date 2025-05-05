import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class PetControllerRegister with ChangeNotifier {
  static Future<String> registerPets({
    required String name,
    required String breed,
    required String weight,
    required String color,
    required String gender,
    required String age,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return 'Usuario no autenticado';
    }

    final url = Uri.parse('http://10.0.2.2:8000/register_pet');
    try {
      final user = FirebaseAuth.instance.currentUser;
      final token = await user?.getIdToken();
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'breed': breed,
          'age': age,
          'weight': weight,
          'color': color,
          'gender': gender,
          'owner_id': user?.uid, // Enviamos el UID del usuario
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Registro de mascota exitoso';
      } else {
        return 'Error en el backend: ${response.statusCode}';
      }
    } catch (e) {
      return 'Error al registrar mascota: $e';
    }
  }
}
