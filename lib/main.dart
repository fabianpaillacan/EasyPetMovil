import 'package:flutter/material.dart';

void main() {
  runApp(const EasyPetApp());
}

class EasyPetApp extends StatelessWidget {
  const EasyPetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyPet Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const PetsScreen(),
    const AgendaScreen(),
    const MessagesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Índice de la pestaña seleccionada actualmente
        onTap: (index) {// Evento que se dispara al tocar una pestaña
          setState(() {
            _currentIndex = index; // Cambia el índice actual al índice de la pestaña tocada
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Mascotas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Mensajes',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Próximas Citas Veterinarias',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  AppointmentCard(
                    petName: 'Max',
                    date: '10 de Abril, 2025',
                    time: '10:00 AM',
                    vetName: 'Dr. López',
                  ),
                  AppointmentCard(
                    petName: 'Luna',
                    date: '12 de Abril, 2025',
                    time: '2:00 PM',
                    vetName: 'Dra. García',
                  ),
                  AppointmentCard(
                    petName: 'Diego',
                    date: '15 de Abril, 2025',
                    time: '11:30 AM',
                    vetName: 'Dr. Pérez',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String petName;
  final String date;
  final String time;
  final String vetName;

  const AppointmentCard({
    super.key,
    required this.petName,
    required this.date,
    required this.time,
    required this.vetName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.pets, color: Colors.teal),
        title: Text('$petName - $date'),
        subtitle: Text('Hora: $time\nVeterinario: $vetName'),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}

class PetsScreen extends StatelessWidget {
  const PetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mascotas'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Aquí puedes agregar funcionalidad para añadir una nueva mascota
            },
            child: const Text('Agregar Mascota'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  leading: Icon(Icons.pets),
                  title: Text('Max'),
                  subtitle: Text('Perro - Labrador'),
                ),
                ListTile(
                  leading: Icon(Icons.pets),
                  title: Text('Luna'),
                  subtitle: Text('Gato - Siamés'),
                ),
                // Agrega más mascotas aquí
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'Citas Programadas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('10 de Abril, 2025'),
                  subtitle: Text('Cita con Dr. López - Max'),
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('12 de Abril, 2025'),
                  subtitle: Text('Cita con Dra. García - Luna'),
                ),
                // Agrega más citas aquí
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            'Mensajes Recientes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  leading: Icon(Icons.message),
                  title: Text('Dr. López'),
                  subtitle: Text('Hola, ¿cómo está Max?'),
                ),
                ListTile(
                  leading: Icon(Icons.message),
                  title: Text('Dra. García'),
                  subtitle: Text('Recuerda la cita de Luna.'),
                ),
                // Agrega más mensajes aquí
              ],
            ),
          ),
        ],
      ),
    );
  }
}
