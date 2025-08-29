import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easypet/core/navigation/main_navigation.dart';
import 'package:easypet/features/profile/controllers/configuration_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userInfo = {};
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  bool _isLoading = true;
  String? selectedGender;
  
  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  void dispose() {      
    _firstNameController.dispose();
    _lastNameController.dispose();
    _rutController.dispose();
    _birthDateController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> fetchUser() async {
    final response = await ConfigurationController.getConfigUser();
    setState(() {
      userInfo = response;
      _firstNameController.text = userInfo['first_name'] ?? '';
      _lastNameController.text = userInfo['last_name'] ?? '';
      _birthDateController.text = userInfo['birth_date'] ?? '';
      _emailController.text = userInfo['email'] ?? '';
      _phoneController.text = userInfo['phone'] ?? '';
      _rutController.text = userInfo['rut'] ?? '';
      // Mapear el género desde MongoDB a los valores del dropdown
      final genderFromAPI = userInfo['gender'] ?? '';
      if (genderFromAPI.isNotEmpty) {
        // Solo manejar los tres valores exactos del dropdown
        if (genderFromAPI == 'Masculino') {
          selectedGender = 'Masculino';
        } else if (genderFromAPI == 'Femenino') {
          selectedGender = 'Femenino';
        } else if (genderFromAPI == 'Otro') {
          selectedGender = 'Otro';
        } else {
          // Si no coincide exactamente, no seleccionar nada
          selectedGender = null;
        }
      } else {
        selectedGender = null;
      }
      
      _isLoading = false;
    });
  }

  void _saveChanges() async {
    final data = {
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "birth_date": _birthDateController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "gender": selectedGender!,
      "rut": _rutController.text,  // Preservar RUT existente
      // Removed firebase_uid for security - mobile app should not handle Firebase UID
      "veterinarian_id": userInfo['veterinarian_id'] ?? '',  // Preservar
    };

    await ConfigurationController.updateConfigUser(data);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Datos actualizados")));
    // No need to navigate since we're already in MainNavigation
    // Just refresh the user data
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Configuración de Usuario',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 48, 45, 5),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Remove the back button since this is part of main navigation
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F9FA), Colors.white],
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildTextField(
                    controller: _firstNameController,
                    label: 'Nombre',
                    hint: 'Ej: Humberto',
                    icon: Icons.person,
                    keyboardType: TextInputType.text,
                    validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _lastNameController,  
                    label: 'Apellido Paterno',
                    hint: 'Ej: Suazo',
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.text,
                    validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildRutField(),  // Campo RUT de solo lectura
                  const SizedBox(height: 16),
                  _buildDateField(),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Correo Electrónico',
                    hint: 'Ej: example@gmail.com',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildPhoneField(),
                  const SizedBox(height: 16),
                  _buildGenderDropdown(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56.0,
                    child: ElevatedButton.icon(
                      onPressed: _saveChanges,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: Text(
                        'Guardar Cambios',
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

  Widget _buildPhoneField() {
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
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          labelText: 'Teléfono',
          hintText: 'Ej: 912345678',
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🇨🇱', // Bandera de Chile como emoji
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 6),
                const Text(
                  '+56', 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 20,
                  width: 1,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
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
        controller: _birthDateController,
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
              _birthDateController.text = formattedDate;
            });
          }
        },
        style: GoogleFonts.poppins(fontSize: 14),
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
          prefixIcon: Icon(Icons.transgender, color: Colors.deepPurple),
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
            value: 'Masculino',
            child: Text('Masculino'),
          ),
          DropdownMenuItem(
            value: 'Femenino',
            child: Text('Femenino'),
          ),
          DropdownMenuItem(
            value: 'Otro',
            child: Text('Otro'),
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

  Widget _buildRutField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,  // Color gris para indicar que es de solo lectura
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
        controller: _rutController,
        readOnly: true,  // Campo de solo lectura
        enabled: false,  // Deshabilitado visualmente
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey.shade700,  // Color más oscuro para texto
        ),
        decoration: InputDecoration(
          labelText: 'RUT (No editable)',
          hintText: 'Ej: 12345678-9',
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🇨🇱',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 6),
                const Text(
                  'RUT',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 20,
                  width: 1,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
          // Indicador visual de que es de solo lectura
          suffixIcon: const Icon(
            Icons.lock,
            color: Colors.grey,
            size: 20,
          ),
        ),
      ),
    );
  }
}