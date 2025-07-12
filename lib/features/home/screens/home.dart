import 'package:flutter/material.dart';
import 'package:easypet/features/auth/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easypet/features/pets/screens/pet_register_screen.dart';
import 'package:easypet/features/pets/screens/pet_list_screen.dart';
import 'package:easypet/features/updateUserInfo/screens/configurationScreen.dart';
import 'package:easypet/features/updatePassword/screens/password.dart';
import 'package:easypet/core/widgets/custom_bottom_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? idToken;
  int _currentIndex = 0;

  final List<BottomNavItem> _navItems = [
    const BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Inicio',
    ),
    const BottomNavItem(
      icon: Icons.pets_outlined,
      activeIcon: Icons.pets,
      label: 'Mascotas',
    ),
    const BottomNavItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today,
      label: 'Citas',
    ),
    const BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Perfil',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();
    setState(() {
      idToken = token;
    });
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'EasyPet',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 48, 45, 5),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color.fromARGB(255, 48, 45, 5)),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavItemTapped,
        items: _navItems,
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildPetsContent();
      case 2:
        return _buildAppointmentsContent();
      case 3:
        return _buildProfileContent();
      default:
        return _buildHomeContent();
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '¡Bienvenido a EasyPet!',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 48, 45, 5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tu compañero para el cuidado de mascotas',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildActionCard(
            icon: Icons.pets,
            title: 'Registrar Mascota',
            subtitle: 'Agrega una nueva mascota a tu familia',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PetRegisterScreen()),
            ),
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            icon: Icons.list_alt,
            title: 'Ver Mascotas',
            subtitle: 'Gestiona tus mascotas registradas',
            onTap: idToken == null
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PetList(token: idToken!)),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetsContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Mis Mascotas',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 48, 45, 5),
            ),
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            icon: Icons.add_circle_outline,
            title: 'Registrar Nueva Mascota',
            subtitle: 'Agrega una nueva mascota',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PetRegisterScreen()),
            ),
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            icon: Icons.list_alt,
            title: 'Ver Todas las Mascotas',
            subtitle: 'Gestiona tus mascotas',
            onTap: idToken == null
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PetList(token: idToken!)),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 64,
            color: Colors.deepPurple,
          ),
          SizedBox(height: 16),
          Text(
            'Próximamente',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Sistema de citas veterinarias',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildActionCard(
            icon: Icons.person_outline,
            title: 'Configurar Perfil',
            subtitle: 'Actualiza tu información personal',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ConfigUser()),
            ),
          ),
          const SizedBox(height: 16),
          _buildActionCard(
            icon: Icons.lock_outline,
            title: 'Cambiar Contraseña',
            subtitle: 'Actualiza tu contraseña de seguridad',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.deepPurple,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

