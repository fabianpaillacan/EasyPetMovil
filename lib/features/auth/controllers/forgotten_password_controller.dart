import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easypet/features/auth/screens/forgotten_password.dart';

class PasswordResetResponse {
  final bool success;
  final String message;

  PasswordResetResponse({required this.success, required this.message});
}

class ResetPasswordController {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<PasswordResetResponse> resetPasswordStatic(String email) async {
    try {
      // Verificar si el email existe
      final signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isEmpty) {
        return PasswordResetResponse(
          success: false,
          message: "No hay cuenta asociada a este correo",
        );
      }

      // Enviar email de recuperación
      await _auth.sendPasswordResetEmail(email: email);

      return PasswordResetResponse(
        success: true,
        message: "Hemos enviado un correo con instrucciones para restablecer tu contraseña",
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = "El correo ingresado no es válido";
          break;
        case 'user-not-found':
          errorMessage = "No hay cuenta asociada a este correo";
          break;
        default:
          errorMessage = "Ocurrió un error inesperado: ${e.message}";
      }
      return PasswordResetResponse(success: false, message: errorMessage);
    } catch (e) {
      return PasswordResetResponse(
        success: false,
        message: "Error al procesar la solicitud",
      );
    }
  }

  Future resetPassword(String email) async {
    try {
      await ResetPasswordController.resetPasswordStatic(email);
    } catch (e) {
      print(e.toString());
      // Maneja el error según sea necesario
    }
  }
}


