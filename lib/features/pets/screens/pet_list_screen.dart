import 'package:easypet/features/pets/controllers/listPets/petsUser_controller.dart';
import 'package:easypet/features/pets/controllers/pet_profile/pet_profile_controller.dart';
import 'package:easypet/features/pets/screens/pet_profile_screen.dart';
import 'package:easypet/features/pets/screens/pet_register_screen.dart';
import 'package:flutter/material.dart';

// Wrapper class for HomeScreen compatibility
class PetListScreen extends StatelessWidget {
  const PetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PetList(token: "dev_token_123");
  }
}

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
      appBar: AppBar(
        title: const Text('Mis Mascotas',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF5B2075),
              foregroundColor: Colors.white, //color del texto
              shape: RoundedRectangleBorder( //borde del boton
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PetRegisterScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: pets.length,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        itemBuilder: (context, index) {
          final pet = pets[index];
          return GestureDetector(
            onTap: () {
              final petId = pet['pet_id'];
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
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      pet['name'][0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${pet['pet_id']}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
