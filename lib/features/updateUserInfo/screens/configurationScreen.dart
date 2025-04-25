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
  final TextEditingController _genderController = TextEditingController();

  bool _isLoading = true;

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
    _genderController.dispose();
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
      _genderController.text = userInfo['gender'] ?? '';
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
      "gender": _genderController.text,
    };

    await ConfigurationController.updateConfigUser(data);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("✅ Datos actualizados")));
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
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      'Nombre',
                      _firstNameController,
                      'Ej: Diego',
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
                      'Ej: diego@gmail.com',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Teléfono',
                      _phoneController,
                      'Ej: 912345678',
                    ),
                    const SizedBox(height: 16),
                    _buildGenderField(),
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

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Género',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: _genderController,
          decoration: InputDecoration(
            hintText: 'Ingrese su género',
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
