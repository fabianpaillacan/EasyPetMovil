import 'package:flutter/material.dart';
import 'package:easypet/features/auth/screens/login_screen.dart';
import 'package:easypet/features/auth/controllers/register_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Crear Cuenta',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 48, 45, 5),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 48, 45, 5)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F9FA), Colors.white],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              // Header con logo
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 32.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logos/easypet_logo.jpg',
                      width: 80.0,
                      height: 80.0,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.pets,
                          size: 80.0,
                          color: Colors.deepPurple,
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      '¡Únete a EasyPet!',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 48, 45, 5),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Crea tu cuenta para cuidar mejor a tus mascotas',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // Sección: Información Personal
              _buildSectionTitle('Información Personal'),
              const SizedBox(height: 16.0),
              
              // Nombres y Apellidos en fila
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: firstNameController,
                      label: 'Nombres',
                      hint: 'Tu nombre',
                      icon: Icons.person,
                      validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: _buildTextField(
                      controller: lastNameController,
                      label: 'Apellidos',
                      hint: 'Tu apellido',
                      icon: Icons.person_outline,
                      validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              
              // RUT y Fecha de Nacimiento
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: rutController,
                      label: 'RUT',
                      hint: '12345678-9',
                      icon: Icons.badge,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'RUT requerido';
                        if (value.length > 10) return 'Máximo 10 caracteres';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: _buildTextField(
                      controller: birthDateController,
                      label: 'Fecha de Nacimiento',
                      hint: 'DD/MM/AAAA',
                      icon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                          locale: const Locale('es', ''),
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
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              
              // Teléfono y Género
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: phoneController,
                      label: 'Teléfono',
                      hint: '912345678',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Teléfono requerido';
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) return 'Sólo números';
                        if (value.length != 9) return 'Debe tener 9 dígitos';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: _buildTextField(
                      controller: genderController,
                      label: 'Género',
                      hint: 'Masculino/Femenino',
                      icon: Icons.transgender,
                      validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              
              // Sección: Información de Cuenta
              _buildSectionTitle('Información de Cuenta'),
              const SizedBox(height: 16.0),
              
              // Email
              _buildTextField(
                controller: emailController,
                label: 'Correo Electrónico',
                hint: 'tu@email.com',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Correo requerido';
                  if (!value.contains('@')) return 'Correo inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              
              // Contraseñas
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: passwordController,
                      label: 'Contraseña',
                      hint: 'Mínimo 6 caracteres',
                      icon: Icons.lock,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Contraseña requerida';
                        if (value.length < 6) return 'Mínimo 6 caracteres';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: _buildTextField(
                      controller: confirmPasswordController,
                      label: 'Confirmar Contraseña',
                      hint: 'Repite tu contraseña',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) {
                        if (value != passwordController.text) return 'Las contraseñas no coinciden';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              
              // Botón de registro
              SizedBox(
                width: double.infinity,
                height: 56.0,
                child: ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Crear Cuenta',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                            ),
              const SizedBox(height: 16.0),
              
              // Enlace para ir a login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes cuenta? ',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Inicia Sesión',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color.fromARGB(255, 48, 45, 5),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    bool readOnly = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        ),
      ),
    );
  }
}
