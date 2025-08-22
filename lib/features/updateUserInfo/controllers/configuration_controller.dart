import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easypet/core/services/user_service.dart';

class ConfigurationController with ChangeNotifier {
  static Future<Map<String, dynamic>> getConfigUser() async {
    try {
      // Obtener usuario actual de Firebase
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('Usuario no autenticado');
        return {};
      }

      // Obtener token de Firebase
      final token = await user.getIdToken();
      if (token == null) {
        debugPrint('Error al obtener token de Firebase');
        return {};
      }

      // Usar tu servicio de usuario que se conecta a MongoDB
      final userData = await UserService.getUserInfo(token);
      debugPrint('Datos del usuario obtenidos: $userData');
      
      return userData;
    } catch (e) {
      debugPrint('Error al obtener información del usuario: $e');
      return {};
    }
  }

  static Future<void> updateConfigUser(Map<String, dynamic> data) async {
    try {
      // Obtener usuario actual de Firebase
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('Usuario no autenticado');
        return;
      }

      // Obtener token de Firebase
      final token = await user.getIdToken();
      if (token == null) {
        debugPrint('Error al obtener token de Firebase');
        return;
      }

      // Limpiar datos antes de enviar
      final sanitizedData = Map<String, dynamic>.from(data);
      sanitizedData.remove('password');

      // Usar tu servicio de usuario que se conecta a MongoDB
      final result = await UserService.updateUserInfo(sanitizedData, token);
      debugPrint('Usuario actualizado exitosamente: $result');
      
    } catch (e) {
      debugPrint('Error al actualizar usuario: $e');
      throw Exception('Error al actualizar usuario: $e');
    }
  }
}