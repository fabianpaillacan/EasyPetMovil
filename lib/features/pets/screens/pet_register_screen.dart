import 'package:easypet/features/pets/controllers/registerPets/pet_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PetRegisterScreen extends StatefulWidget {
  const PetRegisterScreen({super.key});

  @override
  State<PetRegisterScreen> createState() => _PetRegisterScreenState();
}

class _PetRegisterScreenState extends State<PetRegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();
  String? result;

  void registerPets() async {
    final name = nameController.text;
    final breed = breedController.text;
    final weight = weightController.text;
    final age = ageController.text;
    final color = colorController.text;
    final gender = genderController.text;
    final birthDate = birthDateController.text; //nuevo campo
    final species = speciesController.text; //nuevo campo

    final response = await PetControllerRegister.registerPets(
      name: name,
      breed: breed,
      weight: weight,
      age: age,
      color: color,
      gender: gender,
      birthDate: birthDate, //nuevo campo
      species: species, //nuevo campo
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
            _buildTextField(
              controller: speciesController,
              label: 'Especie',
              hint: 'Especie de la mascota',
              icon: Icons.cruelty_free,
              keyboardType: TextInputType.text,
              //validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: breedController,
              label: 'Raza',
              hint: 'Raza de la mascota',
              icon: Icons.pets,
              keyboardType: TextInputType.text,
              //validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildTextField(
                controller: birthDateController,
                label: 'Fecha de Nacimiento',
                hint: 'DD/MM/AAAA',
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
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
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Campo requerido'
                            : null,
              ),
            ),
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
              controller: weightController,
              label: 'Peso',
              hint: 'Peso de la mascota',
              icon: Icons.scale,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: colorController,
              label: 'Color',
              hint: 'Color de la mascota',
              icon: Icons.color_lens,
              keyboardType: TextInputType.text,
              //validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: genderController,
              label: 'Género',
              hint: 'Género de la mascota',
              icon: Icons.pets,
              keyboardType: TextInputType.text,
              validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
            ),
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
