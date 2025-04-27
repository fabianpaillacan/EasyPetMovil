import 'package:flutter/material.dart';
import 'package:easypet/features/auth/controllers/register_controller.dart'; //aca se referencia el archivo que esta en controller y pueda acceder a la funcion registerUser

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController rutController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? result;

  void registerUser() async {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final rut = rutController.text;
    final birthDate = birthDateController.text;
    final phone = phoneController.text;
    final email = emailController.text;
    final gender = genderController.text;
    final password = passwordController.text;

    final response = await RegisterController.registerUser(
      //aca llama a la funcion que esta en register_controller.dart y le envia los datos
      firstName: firstName,
      lastName: lastName,
      rut: rut,
      birthDate: birthDate,
      phone: phone,
      email: email,
      gender: gender,
      password: password,
    );

    setState(() {
      result = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: firstNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Nombres',
                  hintText: 'User Name',
                  icon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: lastNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Apellidos',
                  hintText: 'Last Name',
                  icon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: rutController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'RUT',
                  hintText: 'RUT',
                  icon: Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: birthDateController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  hintText: 'Birth Date',
                  icon: Icon(Icons.calendar_today),
                ),
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
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: genderController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Género',
                  hintText: 'Gender',
                  icon: Icon(Icons.transgender),
                ),
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
