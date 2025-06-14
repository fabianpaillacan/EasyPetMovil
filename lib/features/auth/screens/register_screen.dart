import 'package:flutter/material.dart';
import 'package:easypet/features/auth/screens/login_screen.dart';
import 'package:easypet/features/auth/controllers/register_controller.dart';
import 'package:firebase_auth/firebase_auth.dart'; // <- para validar si el correo ya existe

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController rutController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();

    try {
      // Validar si el correo ya está registrado en Firebase Auth
      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("El correo ya está registrado"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al verificar el correo: $e"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Llamar al backend para registrar el usuario
    final response = await RegisterController.registerUser(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      rut: rutController.text.trim(),
      birthDate: birthDateController.text.trim(),
      phone: phoneController.text.trim(),
      email: email,
      gender: genderController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response),
        backgroundColor: response.contains("correctamente") ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );

    if (response.contains('correctamente')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombres',
                  hintText: 'User Name',
                  icon: Icon(Icons.person),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Apellidos',
                  hintText: 'Last Name',
                  icon: Icon(Icons.person_outline),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: rutController,
                decoration: const InputDecoration(
                  labelText: 'RUT',
                  hintText: 'RUT',
                  icon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'RUT requerido';
                  if (value.length > 10) return 'Máximo 10 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 10),
           TextFormField(
                controller: birthDateController,
                readOnly: true, // <- Importante: el usuario no escribe directamente
                decoration: const InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  hintText: 'Birth Date',
                  icon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode()); // Oculta teclado

                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000), // Fecha inicial sugerida
                    firstDate: DateTime(1900),   // Límite inferior
                    lastDate: DateTime.now(),    // Límite superior
                    locale: const Locale('es', ''), // Opcional: calendario en español
                  );

                  if (pickedDate != null) {
                    String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    setState(() {
                      birthDateController.text = formattedDate;
                    });
                  }
                },
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  hintText: 'Phone Number',
                  icon: Icon(Icons.phone),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Teléfono requerido';
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Sólo números';
                  if (value.length != 9) return 'Debe tener 9 dígitos';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  hintText: 'Email',
                  icon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Correo requerido';
                  if (!value.contains('@')) return 'Correo inválido';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: genderController,
                decoration: const InputDecoration(
                  labelText: 'Género',
                  hintText: 'Gender',
                  icon: Icon(Icons.transgender),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  hintText: 'Password',
                  icon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Contraseña requerida';
                  if (value.length < 6) return 'Mínimo 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Repetir Contraseña',
                  hintText: 'Confirm Password',
                  icon: Icon(Icons.lock_outline),
                ),
                validator: (value) {
                  if (value != passwordController.text) return 'Las contraseñas no coinciden';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerUser,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
