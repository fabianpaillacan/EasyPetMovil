import 'package:easypet/features/configurationUser/controllers/configuration_controller.dart';
import 'package:flutter/material.dart';

class ConfigUser extends StatefulWidget {
  const ConfigUser({super.key});

  @override
  State<ConfigUser> createState() => _ConfigUserState();
}

class _ConfigUserState extends State<ConfigUser> {
  Map<String, dynamic> userInfo = {};

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    final response = await ConfigurationController.getConfigUser();
    setState(() {
      userInfo = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración de Usuario')),
      body: userInfo.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nombre: ${userInfo['first_name'] ?? 'No disponible'}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Correo: ${userInfo['email'] ?? 'No disponible'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Teléfono: ${userInfo['phone'] ?? 'No disponible'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}