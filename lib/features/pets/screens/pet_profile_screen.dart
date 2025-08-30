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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                  // Solo el nombre de la mascota
                  Text(
                    petData!['name'],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Sección de Información de la mascota
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Información de la mascota',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Grid de información en dos columnas
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow('Nombre', petData!['name'] ?? 'N/A'),
                        _buildInfoRow('Especie', petData!['species'] ?? 'N/A'),
                        _buildInfoRow('Raza', petData!['breed'] ?? 'N/A'),
                        _buildInfoRow('Edad', _formatAge(petData!['age'], petData!['birth_date'])),
                        _buildInfoRow('Peso', _formatWeight(petData!['weight'])),
                        _buildInfoRow('Color', petData!['color'] ?? 'N/A'),
                        _buildInfoRow('Género', _formatGender(petData!['gender'])),
                        _buildInfoRow('Fecha de nacimiento', _formatDate(petData!['birth_date'])),
                        // Última fila sin línea divisoria
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Número de microchip',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4B8F7B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  petData!['microchip_number'] ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                  const SizedBox(width: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        PetProfileController.deletePet(widget.petId);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B8F7B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Línea separativa
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey[300],
        ),
      ],
    );
  }

  String _formatAge(int? age, String? birthDate) {
    if (age != null) {
      return '$age años';
    } else if (birthDate != null) {
      try {
        final birth = DateTime.parse(birthDate);
        final now = DateTime.now();
        final age = now.year - birth.year;
        if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) {
          return '${age - 1} años';
        }
        return '$age años';
      } catch (e) {
        return 'N/A';
      }
    } else {
      return 'N/A';
    }
  }

  String _formatWeight(dynamic weight) {
    if (weight == null || weight == 0 || weight == 0.0) {
      return 'Todavía no me pesan';
    }
    if (weight is int) {
      return '$weight kg';
    } else if (weight is double) {
      return '${weight.toStringAsFixed(1)} kg';
    }
    return weight.toString();
  }

  String _formatGender(dynamic gender) {
    if (gender == null) return 'N/A';
    if (gender == 'male') return 'Macho';
    if (gender == 'female') return 'Hembra';
    return gender;
  }

  String _formatDate(String? date) {
    if (date == null) return 'N/A';
    try {
      final dateTime = DateTime.parse(date);
      final months = [
        'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
        'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
      ];
      return '${dateTime.day} de ${months[dateTime.month - 1]} de ${dateTime.year}';
    } catch (e) {
      return date;
    }
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

