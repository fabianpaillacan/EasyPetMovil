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
      debugPrint('Datos del usuario obtenidos de MongoDB: $userData');
      
      return userData;
    } catch (e) {
      debugPrint('Error al obtener información del usuario: $e');
      return {};
    }
  }

  static Future<void> updateConfigUser(Map<String, dynamic> data) async {
    try {
      // Validar datos antes de enviar
      if (!_validateUserData(data)) {
        throw Exception('Datos de usuario inválidos');
      }

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
      sanitizedData.remove('email'); // No permitir cambiar email desde aquí
      
      // Preservar campos sensibles que no deben modificarse
      if (data['firebase_uid'] != null) {
        sanitizedData['firebase_uid'] = data['firebase_uid'];
      }
      if (data['veterinarian_id'] != null) {
        sanitizedData['veterinarian_id'] = data['veterinarian_id'];
      }

      debugPrint('Enviando datos actualizados a MongoDB: $sanitizedData');

      // Usar tu servicio de usuario que se conecta a MongoDB
      final result = await UserService.updateUserInfo(sanitizedData, token);
      debugPrint('Usuario actualizado exitosamente en MongoDB: $result');
      
    } catch (e) {
      debugPrint('Error al actualizar usuario en MongoDB: $e');
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  // Validar datos del usuario antes de enviar
  static bool _validateUserData(Map<String, dynamic> data) {
    // Validar nombre
    if (data['first_name'] == null || data['first_name'].toString().trim().isEmpty) {
      debugPrint('Error: Nombre es requerido');
      return false;
    }

    // Validar apellido
    if (data['last_name'] == null || data['last_name'].toString().trim().isEmpty) {
      debugPrint('Error: Apellido es requerido');
      return false;
    }

    // Validar teléfono (formato chileno)
    final phone = data['phone']?.toString().trim() ?? '';
    if (phone.isNotEmpty && !RegExp(r'^[0-9]{9}$').hasMatch(phone)) {
      debugPrint('Error: Teléfono debe tener 9 dígitos');
      return false;
    }

    // Validar género
    if (data['gender'] == null || data['gender'].toString().trim().isEmpty) {
      debugPrint('Error: Género es requerido');
      return false;
    }

    return true;
  }
}