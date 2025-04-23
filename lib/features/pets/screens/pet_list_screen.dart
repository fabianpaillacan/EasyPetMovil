import 'package:easypet/features/pets/controllers/listPets/petsUser_controller.dart';
import 'package:flutter/material.dart';

class PetList extends StatefulWidget {
  const PetList({super.key});

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
              pet['name'],
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
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(pet['name']),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Edad: ${pet['age']} años'),
                        Text('Peso: ${pet['weight']} kg'),
                        Text('Color: ${pet['color']}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
