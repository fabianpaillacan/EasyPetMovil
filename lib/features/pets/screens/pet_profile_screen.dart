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
    // Ejemplo de historial médico (puedes reemplazarlo por tus datos reales)
    final List<Map<String, String>> medicalHistory = [
      {
        'icon': 'event',
        'title': 'Consulta de rutina',
        'date': '12 de enero de 2023',
      },
      {
        'icon': 'vaccines',
        'title': 'Vacuna contra la rabia',
        'date': '20 de febrero de 2023',
      },
      {
        'icon': 'medication',
        'title': 'Tratamiento antiparasitario',
        'date': '15 de marzo de 2023',
      },
      {
        'icon': 'error_outline',
        'title': 'Alergia a la carne de res',
        'date': '10 de abril de 2023',
      },
    ]; //aca se debe agregar el historial medico de la mascota, no esta en firebase. Depende del backend Web

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        centerTitle: true,
        title: const Text(
          "Detalles de la mascota",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading || petData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar grande
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: petData!['imageUrl'] != null
                        ? NetworkImage(petData!['imageUrl'])
                        : null,
                    child: petData!['imageUrl'] == null 
                        ? Text(
                            petData!['name'][0].toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF5B2075),
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 18),
                  // Nombre
                  Text(
                    petData!['name'],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Subtítulo (raza, especie, fecha de nacimiento)
                  if (petData!['breed'] != null && petData!['species'] != null)
                    Text(
                      '${petData!['species']}, ${petData!['breed']}', //aca se debe agregar la raza de la mascota, no esta en firebase
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4B8F7B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  if (petData!['birth_date'] != null)
                    Text(
                      'Nacido el ${petData!['birth_date']}', //aca se debe agregar la fecha de nacimiento de la mascota, no esta en firebase
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF4B8F7B),
                      ),
                    ),
                  const SizedBox(height: 28),
                  // Historial Médico
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Historial Médico',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Lista de historial médico
                  ...medicalHistory.map((item) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _getIconData(item['icon']!),
                                color: const Color(0xFF5B2075),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item['date']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF4B8F7B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'event':
        return Icons.event;
      case 'vaccines':
        return Icons.vaccines;
      case 'medication':
        return Icons.medication;
      case 'error_outline':
        return Icons.error_outline;
      default:
        return Icons.pets;
    }
  }
}
