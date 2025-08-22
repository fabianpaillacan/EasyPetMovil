import 'package:easypet/features/pets/controllers/registerPets/pet_controller.dart';
import 'package:easypet/core/services/species_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PetRegisterScreen extends StatefulWidget {
  const PetRegisterScreen({super.key});

  @override
  State<PetRegisterScreen> createState() => _PetRegisterScreenState();
}

class _PetRegisterScreenState extends State<PetRegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  
  // Eliminamos los controladores de texto para especie y raza
  // y usamos valores String para los dropdowns
  String? selectedSpecies; // 'perro', 'gato', 'pez', etc.
  String? selectedBreed; // Raza seleccionada
  String? selectedGender; // 'Macho', 'Hembra', null
  String? result;
  
  // Listas para los dropdowns
  List<String> speciesList = [];
  List<String> breedsList = [];
  
  @override
  void initState() {
    super.initState();
    _loadSpecies();
  }
  
  // Cargar especies al inicializar
  Future<void> _loadSpecies() async {
    try {
      final species = await SpeciesService.getSpecies();
      setState(() {
        speciesList = species;
      });
    } catch (e) {
      print('Error cargando especies: $e');
    }
  }
  
  // Cargar razas cuando se selecciona una especie
  Future<void> _loadBreedsBySpecies(String species) async {
    try {
      final breeds = await SpeciesService.getBreedsBySpecies(species);
      setState(() {
        breedsList = breeds;
        selectedBreed = null; // Resetear raza seleccionada
      });
    } catch (e) {
      print('Error cargando razas: $e');
    }
  }

  void registerPets() async {
    final name = nameController.text;
    final breed = selectedBreed ?? '';
    //final weight = weightController.text;
    final age = ageController.text;
    final color = colorController.text;
    final birthDate = birthDateController.text;
    final species = selectedSpecies ?? '';

    // Validaciones
    if (selectedSpecies == null) {
      setState(() {
        result = 'Por favor selecciona la especie de la mascota';
      });
      return;
    }
    
    if (selectedBreed == null) {
      setState(() {
        result = 'Por favor selecciona la raza de la mascota';
      });
      return;
    }

    if (selectedGender == null) {
      setState(() {
        result = 'Por favor selecciona el género de la mascota';
      });
      return;
    }

    final response = await PetControllerRegister.registerPets(
      name: name,
      breed: breed,
      //weight: weight,
      age: age,
      color: color,
      gender: selectedGender!, // Usamos el valor del dropdown
      birthDate: birthDate,
      species: species,
    );

    setState(() {
      result = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Crear Mascota',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 48, 45, 5),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color.fromARGB(255, 48, 45, 5),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F9FA), Colors.white],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTextField(
              controller: nameController,
              label: 'Nombre',
              hint: 'Nombre de la mascota',
              icon: Icons.badge,
              keyboardType: TextInputType.text,
              validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),
            // Dropdown para especie
            _buildSpeciesDropdown(),
            const SizedBox(height: 16),
            // Dropdown para raza
            _buildBreedDropdown(),
            const SizedBox(height: 16),
            _buildDateField(), // Campo de fecha separado
            const SizedBox(height: 16),
            _buildTextField(
              controller: ageController,
              label: 'Edad',
              hint: 'Edad de la mascota',
              icon: Icons.cake,
              keyboardType: TextInputType.number,
              validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: colorController,
              label: 'Color',
              hint: 'Color de la mascota',
              icon: Icons.color_lens,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            // Dropdown para el género en lugar de TextField
            _buildGenderDropdown(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56.0,
              child: ElevatedButton.icon(
                onPressed: registerPets,
                icon: const Icon(Icons.pets, color: Colors.white),
                label: Text(
                  'Agregar Mascota',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 2,
                ),
              ),
            ),
            if (result != null) ...[
              const SizedBox(height: 16),
              Text(
                result!,
                style: TextStyle(
                  color: result!.toLowerCase().contains('exitosamente') ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Widget para el dropdown de especie
  Widget _buildSpeciesDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedSpecies,
        decoration: InputDecoration(
          labelText: 'Especie',
          prefixIcon: Icon(Icons.cruelty_free, color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
        ),
        items: speciesList.map((String species) {
          return DropdownMenuItem<String>(
            value: species,
            child: Text(
              species.substring(0, 1).toUpperCase() + species.substring(1),
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedSpecies = newValue;
            selectedBreed = null; // Resetear raza cuando cambia especie
          });
          if (newValue != null) {
            _loadBreedsBySpecies(newValue);
          }
        },
        validator: (value) => value == null ? 'Selecciona la especie' : null,
      ),
    );
  }

  // Widget para el dropdown de raza
  Widget _buildBreedDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedBreed,
        decoration: InputDecoration(
          labelText: 'Raza',
          prefixIcon: Icon(Icons.pets, color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
        ),
        items: breedsList.map((String breed) {
          return DropdownMenuItem<String>(
            value: breed,
            child: Text(
              breed,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: selectedSpecies == null ? null : (String? newValue) {
          setState(() {
            selectedBreed = newValue;
          });
        },
        validator: (value) => value == null ? 'Selecciona la raza' : null,
      ),
    );
  }

  // Widget para el dropdown de género
  Widget _buildGenderDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        decoration: InputDecoration(
          labelText: 'Género',
          prefixIcon: Icon(Icons.pets, color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
        ),
        items: const [
          DropdownMenuItem(
            value: 'Macho',
            child: Text('Macho'),
          ),
          DropdownMenuItem(
            value: 'Hembra',
            child: Text('Hembra'),
          ),
        ],
        onChanged: (String? newValue) {
          setState(() {
            selectedGender = newValue;
          });
        },
        validator: (value) => value == null ? 'Selecciona el género' : null,
      ),
    );
  }

  // Widget separado para el campo de fecha
  Widget _buildDateField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: birthDateController,
        readOnly: true,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            locale: const Locale('es', ''),
          );
          if (pickedDate != null) {
            String formattedDate =
                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
            setState(() {
              birthDateController.text = formattedDate;
            });
          }
        },
        decoration: InputDecoration(
          labelText: 'Fecha de Nacimiento',
          hintText: 'DD/MM/AAAA',
          prefixIcon: Icon(Icons.calendar_today, color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    bool readOnly = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        keyboardType: keyboardType,
        validator: validator,
        onTap: onTap,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
        ),
      ),
    );
  }
}