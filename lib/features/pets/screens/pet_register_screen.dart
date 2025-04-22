import 'dart:io';
import 'package:easypet/features/pets/controllers/pet_controller.dart';
import 'package:flutter/material.dart';
import 'package:easypet/features/home/screens/home.dart';

class PetRegisterScreen extends StatelessWidget {
  final PetController petController = PetController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido a registro de mascotas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Pet Name'),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
