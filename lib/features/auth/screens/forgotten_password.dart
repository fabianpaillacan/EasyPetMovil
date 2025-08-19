//aqui tengo que venir despues de apretar el boton de me olvide la contrasena, ingresar mi correo y el auth de firebase se encarga de verificar. 
//lo podria mandar directamente a la pantalla de crear nueva contrasena y redirigir a la pantalla de login.
import 'package:easypet/features/auth/controllers/forgotten_password_controller.dart';
import 'package:flutter/material.dart';

class ForgottenPasswordScreen extends StatefulWidget {
  const ForgottenPasswordScreen({super.key});

  @override
  State<ForgottenPasswordScreen> createState() => _ForgottenPasswordScreenState();
}

class _ForgottenPasswordScreenState extends State<ForgottenPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String resultMessage = "";

  void handlePasswordReset() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text;

    final response = await ResetPasswordController.resetPasswordStatic(email);

    if (!mounted) return;

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
      Navigator.pop(context); // Regresa a la pantalla anterior (por ejemplo, Login)
    } else {
      setState(() {
        resultMessage = response['message'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar Contraseña"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ingresa tu correo electrónico para cambiar tu contraseña.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Correo Electrónico",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa tu correo electrónico.";
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Por favor ingresa un correo válido.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: handlePasswordReset,
                child: const Text("Enviar"),
              ),
              if (resultMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  resultMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


