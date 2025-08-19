import 'package:flutter/material.dart';
import 'package:easypet/features/auth/screens/login_screen.dart';
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
    // In development mode, we'll use a mock token
    setState(() {
      idToken = "dev_token_123";
    });
  }

  Future<void> _logout(BuildContext context) async {
    // In development mode, just navigate to login
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
          'EasyPet (Dev)',
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
        return const Center(
          child: Text('Inicio - Modo Desarrollo'),
        );
      case 1:
        return const PetListScreen();
      case 2:
        return const Center(
          child: Text('Citas - Modo Desarrollo'),
        );
      case 3:
        return const ConfigurationScreen();
      default:
        return const Center(
          child: Text('Inicio - Modo Desarrollo'),
        );
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
} 