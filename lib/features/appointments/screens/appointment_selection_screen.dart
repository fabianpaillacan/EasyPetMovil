import 'package:flutter/material.dart';
import 'package:easypet/features/appointments/screens/appointment_list_screen.dart';
import 'package:easypet/features/pets/controllers/listPets/petsUser_controller.dart';
import 'package:easypet/features/pets/controllers/pet_profile/pet_profile_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentSelectionScreen extends StatefulWidget {
  const AppointmentSelectionScreen({super.key});

  @override
  State<AppointmentSelectionScreen> createState() => _AppointmentSelectionScreenState();
}

class _AppointmentSelectionScreenState extends State<AppointmentSelectionScreen> {
  List<Map<String, dynamic>> _userPets = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserPets();
  }

  Future<void> _loadUserPets() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      print('🔍 [AppointmentSelection] Cargando mascotas del usuario...');
      
      // Usar el mismo controlador que ya funciona en PetListScreen
      final pets = await PetController.getPets();
      
      print('🔍 [AppointmentSelection] Mascotas obtenidas: ${pets.length}');
      for (var pet in pets) {
        print('🔍 [AppointmentSelection] Mascota: ${pet['name']} (ID: ${pet['pet_id']})');
      }

      setState(() {
        _userPets = pets;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ [AppointmentSelection] Error cargando mascotas: $e');
      setState(() {
        _error = 'Error al cargar las mascotas: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToAppointments(Map<String, dynamic> pet) {
    print('🔍 [AppointmentSelection] Navegando a citas de: ${pet['name']}');
    print('🔍 [AppointmentSelection] Pet ID: ${pet['pet_id']}');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentListScreen(
          petId: pet['pet_id'],
          petName: pet['name'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mis Mascotas - Citas',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserPets,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.deepPurple,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUserPets,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_userPets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes mascotas registradas',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Registra una mascota para poder ver sus citas',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header informativo
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          color: Colors.deepPurple.shade50,
          child: Column(
            children: [
              Icon(
                Icons.calendar_today,
                size: 48,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 12),
              Text(
                'Ver Citas de Mis Mascotas',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Selecciona una mascota para ver sus citas programadas',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        // Lista de mascotas reales del usuario
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _userPets.length,
            itemBuilder: (context, index) {
              final pet = _userPets[index];
              return _buildPetCard(pet);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () => _navigateToAppointments(pet),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar de la mascota
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.deepPurple.shade100,
                child: Icon(
                  _getPetIcon(pet['species'] ?? ''),
                  size: 30,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(width: 16),
              // Información de la mascota
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet['name'] ?? 'Sin nombre',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pet['species'] ?? 'N/A'} • ${pet['breed'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Edad: ${pet['age'] ?? 'N/A'} años',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              // Flecha de navegación
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPetIcon(String species) {
    switch (species.toLowerCase()) {
      case 'perro':
      case 'dog':
        return Icons.pets;
      case 'gato':
      case 'cat':
        return Icons.pets;
      case 'ave':
      case 'bird':
        return Icons.flutter_dash;
      case 'conejo':
      case 'rabbit':
        return Icons.pets;
      case 'hamster':
        return Icons.pets;
      default:
        return Icons.pets;
    }
  }
}
