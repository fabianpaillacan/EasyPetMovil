import 'package:easypet/features/pets/controllers/listPets/petsUser_controller.dart';
import 'package:easypet/features/pets/controllers/pet_profile/pet_profile_controller.dart';
import 'package:easypet/features/pets/screens/pet_profile_screen.dart';
import 'package:flutter/material.dart';

class PetList extends StatefulWidget {
   final String token;

  const PetList({super.key, required this.token});

  @override
  State<PetList> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetList> {
  List pets = [];

  @override
  void initState() {
    super.initState();
    fetchPets();
  }

  Future<void> fetchPets() async {
    final response = await PetController.getPets();
    setState(() {
      pets = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Mascotas')),
      body: ListView.builder(
        itemCount: pets.length,
        itemBuilder: (context, index) {
          final pet = pets[index];
          return ListTile(
            title: Text(
              '${pet['name']} (${pet['id']})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                pet['name'][0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            tileColor: index % 2 == 0 ? Colors.grey[200] : Colors.white,
        onTap: () {
              final petId = pet['id']; // <-- Este valor debe existir
              if (petId != null && petId is String) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PetProfileScreen(petId: petId),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ID de mascota no válido')),
                );
              }
            }

          );
        },
      ),
    );
  }
}

//yo aca no deberia mostrar la informacion de la mascota. apreto el boton y me lleva a la informacion de la mascota.