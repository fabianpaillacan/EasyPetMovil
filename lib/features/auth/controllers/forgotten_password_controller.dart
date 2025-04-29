
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easypet/features/auth/screens/forgotten_password.dart';

class ResetPasswordController {
  static Future<Map<String, dynamic>>resetPasswordStatic(String email) async {
    try {
      // Llama a la función para enviar el correo de restablecimiento
      await sendPasswordResetEmail(email: email);

      return {"success": true, "message": "Correo de restablecimiento enviado"};
    } catch (e) {
      return {"success": false, "message": "Error al restablecer la contraseña: $e"};
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

  static Future<void> sendPasswordResetEmail({required String email}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    // Envía el correo de restablecimiento de contraseña
    await auth.sendPasswordResetEmail(email: email);
  }
}


