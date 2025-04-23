import 'package:flutter/material.dart';
import 'package:easypet/features/auth/screens/login_screen.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:easypet/features/pets/screens/pet_register_screen.dart';
import 'package:easypet/features/pets/controllers/registerPets/pet_controller.dart';
import 'package:easypet/features/pets/screens/pet_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bienvenido a EasyPet',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PetRegisterScreen()),
                );
              },
              child: const Text('Registrar mascota'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:(context) => PetList()),
                );
              },
              child: const Text('Ver mascotas'),
            ),
             ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text('Salir'),
            ),
          ],
        ),
      ),
    );
  }
}