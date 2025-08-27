import 'package:flutter/material.dart';
import 'package:easypet/features/profile/controllers/password_controller.dart';
import 'package:easypet/features/auth/screens/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  String result = '';

  void handleChangePassword() async {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() => result = 'Todos los campos son obligatorios');
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() => result = 'Las contraseñas no coinciden');
      return;
    }

    setState(() => isLoading = true);
    final response = await ChangePasswordController.updatePassword(newPassword);
    setState(() {
      result = response;
      isLoading = false;
    });
    //volver al login
    if (response == 'Contraseña actualizada correctamente') {
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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Cambiar Contraseña',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 48, 45, 5),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(
              controller: newPasswordController,
              label: 'Nueva contraseña',
              icon: Icons.lock_outline,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: confirmPasswordController,
              label: 'Confirmar nueva contraseña',
              icon: Icons.lock_outline,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isLoading ? null : handleChangePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 48, 45, 5),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoading 
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "Actualizar Contraseña",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
            ),
            const SizedBox(height: 20),
            if (result.isNotEmpty)
              Text(
                result, 
                style: TextStyle(
                  color: result.contains('correctamente') ? Colors.green : Colors.red,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 48, 45, 5)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color.fromARGB(255, 48, 45, 5), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
