import 'package:easypet/features/updateUserInfo/controllers/configuration_controller.dart';
import 'package:flutter/material.dart';
import 'package:easypet/features/home/screens/home.dart';

class ConfigUser extends StatefulWidget {
  const ConfigUser({super.key});

  @override
  State<ConfigUser> createState() => _ConfigUserState();
}

class _ConfigUserState extends State<ConfigUser> {
  Map<String, dynamic> userInfo = {};
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
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
      
       // Mapear el género desde Firebase a los valores del dropdown
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
           print('DEBUG - Género no reconocido: "$genderFromAPI"');
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
      "gender": selectedGender!, // ← CORREGIDO: Usar selectedGender
    };

    await ConfigurationController.updateConfigUser(data);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Datos actualizados")));
     Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración de Usuario')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    'Nombre',
                    _firstNameController,
                    'Ej: Humberto',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Apellido Paterno',
                    _lastNameController,
                    'Ej: Suazo',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Fecha de Nacimiento',
                    _birthDateController,
                    'Ej: 10/03/2002',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Correo Electrónico',
                    _emailController,
                    'Ej: example@gmail.com',
                  ),
                  const SizedBox(height: 16),
                  _buildPhoneField(),
                  const SizedBox(height: 16),
                  _buildGenderSection(),
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  // ← CORREGIDO: Widget separado para la sección de género
  Widget _buildPhoneField() {
      return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Teléfono',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
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
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    ],
  );
  }

  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Género',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildGenderDropdown(),
      ],
    );
  }

Widget _buildGenderDropdown() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: DropdownButtonFormField<String>(
      value: selectedGender,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: InputBorder.none,
        prefixIcon: const Icon(Icons.transgender, color: Colors.deepPurple),
      ),
      items: [
        DropdownMenuItem(
          value: 'Masculino',
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0), // Ajusta este valor
            child: Text('Masculino'),
          ),
        ),
        DropdownMenuItem(
          value: 'Femenino',
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0), // Ajusta este valor
            child: Text('Femenino'),
          ),
        ),
        DropdownMenuItem(
          value: 'Otro',
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0), // Ajusta este valor
            child: Text('Otro'),
          ),
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

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            side: const BorderSide(color: Colors.grey),
          ),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _saveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text('Guardar', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}