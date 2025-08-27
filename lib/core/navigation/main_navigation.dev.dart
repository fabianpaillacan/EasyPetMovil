import 'package:flutter/material.dart';
import 'package:easypet/features/pets/screens/pet_register_screen.dart';
import 'package:easypet/features/pets/screens/pet_list_screen.dart';
import 'package:easypet/features/profile/screens/profile_screen.dart';
import 'package:easypet/features/appointments/screens/appointment_selection_screen.dart';
import 'package:easypet/features/dashboard/screens/dashboard_screen.dev.dart';
import 'package:easypet/core/widgets/custom_bottom_nav_bar.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
        return const DashboardScreen();
      case 1:
        return const PetListScreen();
      case 2:
        return const Center(
          child: Text('Citas - Modo Desarrollo'),
        );
      case 3:
        return const ProfileScreen();
      default:
        return const DashboardScreen();
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
} 