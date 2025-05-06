import 'package:flutter/material.dart';
import 'package:easypet/features/pets/controllers/pet_profile/pet_profile_controller.dart';

class PetProfileScreen extends StatefulWidget {
  final String petId;

  const PetProfileScreen({super.key, required this.petId});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  Map<String, dynamic>? petData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPetProfile();
  }

  Future<void> fetchPetProfile() async {
    final data = await PetProfileController.getPetProfile(widget.petId);
    setState(() {
      petData = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil de Mascota')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : petData == null
              ? const Center(child: Text('No se pudo cargar la mascota'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Text('Nombre: ${petData!['name']}', style: TextStyle(fontSize: 18)),
                            Text('Raza: ${petData!['breed']}', style: TextStyle(fontSize: 18)),
                            Text('Edad: ${petData!['age']}', style: TextStyle(fontSize: 18)),
                            Text('Peso: ${petData!['weight']}', style: TextStyle(fontSize: 18)),
                            Text('Color: ${petData!['color']}', style: TextStyle(fontSize: 18)),
                            Text('Género: ${petData!['gender']}', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Volver'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Eliminar Mascota'),
                              content: const Text('¿Estás seguro de que deseas eliminar esta mascota?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await PetProfileController.deletePet(widget.petId);
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Eliminar Mascota'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
