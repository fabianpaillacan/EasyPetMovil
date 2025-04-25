import 'package:flutter/material.dart';
import 'package:easypet/features/updatePassword/controllers/password_controller.dart';
import 'package:easypet/features/auth/screens/login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  String result = '';

  void handleChangePassword() async {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() => result = '❌ Todos los campos son obligatorios');
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() => result = '❌ Las contraseñas no coinciden');
      return;
    }

    setState(() => isLoading = true);
    final response = await ChangePasswordController.updatePassword(newPassword);
    setState(() {
      result = response;
      isLoading = false;
    });
    //volver al login
    if (response == '✅ Contraseña actualizada correctamente') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cambiar contraseña")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: newPasswordController,
              decoration: const InputDecoration(labelText: 'Nueva contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirmar nueva contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : handleChangePassword,
              child: isLoading ? const CircularProgressIndicator() : const Text("Actualizar"),
            ),
            const SizedBox(height: 20),
            Text(result, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
