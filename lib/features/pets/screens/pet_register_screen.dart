import 'dart:io';
import 'package:easypet/features/pets/controllers/registerPets/pet_controller.dart';
import 'package:flutter/material.dart';
import 'package:easypet/features/home/screens/home.dart';


class PetRegisterScreen extends StatefulWidget {
  const PetRegisterScreen({Key? key}) : super(key: key);

  @override
  State<PetRegisterScreen> createState() => _PetRegisterScreenState();
}
class _PetRegisterScreenState extends State<PetRegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  //final TextEditingController speciesController = TextEditingController(); // Removed unused speciesController
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  String? result;
 
 void registerPets() async {
    final name = nameController.text;
    final breed = breedController.text; // Rename controller to breedController for clarity
    final weight = weightController.text; // Rename controller to weightController for clarity
    final age = ageController.text; // Rename controller to ageController for clarity
    final color = colorController.text; // Rename controller to colorController for clarity
    final gender = genderController.text;
    //final uid = emailController.text; // Replace with actual logic to fetch the logged-in user's UID

    final response = await PetController.registerPets(
      name: name,
      breed: breed,
      weight: weight,
      age: age,
      color: color,
      gender: gender // Added missing gender parameter
    );

    setState(() {
      result = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Mascota')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: breedController,
              decoration: const InputDecoration(
                labelText: 'Raza',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(
                labelText: 'Peso',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Edad',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: colorController,
              decoration: const InputDecoration(
                labelText: 'Color',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: genderController,
              decoration: const InputDecoration(
                labelText: 'Género',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: registerPets,
              child: const Text('Registrar Mascota'),
            ),
            if (result != null) ...[
              const SizedBox(height: 16),
              Text(
                result!,
                style: const TextStyle(color: Colors.green),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
