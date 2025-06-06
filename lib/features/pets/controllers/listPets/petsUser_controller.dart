import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class PetController with ChangeNotifier {
  static Future<List> getPets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }

    try {
      final token = await user.getIdToken();
      final url = Uri.parse('http://10.0.2.2:8000/user/pets');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['pets'] ?? [];
      } else {
        debugPrint('Error fetching pets: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Exception occurred: $e');
      return [];
    }
  }
}
