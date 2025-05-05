import 'package:flutter/material.dart';
import 'package:easypet/features/auth/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easypet/features/pets/screens/pet_register_screen.dart';
import 'package:easypet/features/pets/screens/pet_list_screen.dart';
import 'package:easypet/features/updateUserInfo/screens/configurationScreen.dart';
import 'package:easypet/features/updatePassword/screens/password.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? idToken;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();
    setState(() {
      idToken = token;
    });
  }

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
      appBar: AppBar(title: const Text('EasyPet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bienvenido',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PetRegisterScreen()),
                );
              },
              child: const Text('Registrar mascota'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: idToken == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PetList(token: idToken!)),
                      );
                    },
              child: const Text('Ver mascotas'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConfigUser()),
                );
              },
              child: const Text('Cambiar información de usuario'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                );
              },
              child: const Text('Cambiar Contraseña'),
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

