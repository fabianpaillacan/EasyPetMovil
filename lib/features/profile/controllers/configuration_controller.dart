import 'package:flutter/material.dart';
import 'package:easypet/core/services/user_service.dart';
import 'package:easypet/core/services/auth_service.dart';

class ConfigurationController with ChangeNotifier {
  static Future<Map<String, dynamic>> getConfigUser() async {
    try {
      // Usar el nuevo auth service que maneja JWT tokens
      final userData = await UserService.getUserInfo();
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

      // Limpiar datos antes de enviar - remover campos sensibles y strings vacíos
      final sanitizedData = Map<String, dynamic>.from(data);
      sanitizedData.remove('password');
      sanitizedData.remove('email'); // No permitir cambiar email desde aquí
      
      // Remover strings vacíos para evitar sobrescribir datos existentes
      sanitizedData.removeWhere((key, value) => 
        value is String && value.trim().isEmpty
      );
      
      // Preservar campos sensibles que no deben modificarse
      // Removed firebase_uid preservation for security - backend should not receive Firebase UID from mobile app
      if (data['veterinarian_id'] != null && data['veterinarian_id'].toString().isNotEmpty) {
        sanitizedData['veterinarian_id'] = data['veterinarian_id'];
      }

      debugPrint('Enviando datos actualizados a MongoDB: $sanitizedData');

      // Usar el nuevo auth service que maneja JWT tokens
      final result = await UserService.updateUserInfo(sanitizedData);
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