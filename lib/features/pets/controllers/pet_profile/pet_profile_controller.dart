import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class PetProfileController {
  static Future<Map<String, dynamic>?> getPetProfile(String petId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      final token = await user.getIdToken();
      final url = Uri.parse('http://10.0.2.2:8000/pet_profile/$petId');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error al obtener perfil de mascota: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Excepción: $e');
      return null;
    }
  }
  static Future<Map<String,dynamic>?> deletePet(String petId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final token = await user.getIdToken();
      final url = Uri.parse('http://10.0.2.2:8000/pet_profile/$petId/delete');
        final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error al obtener perfil de mascota: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Excepción: $e');
      return null;
    }
    }
  }



