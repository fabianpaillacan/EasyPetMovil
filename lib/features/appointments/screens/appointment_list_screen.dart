import 'package:flutter/material.dart';
import 'package:easypet/features/appointments/models/appointment.dart';
import 'package:easypet/features/appointments/services/appointment_service.dart';
import 'package:easypet/core/services/firebase_auth_service.dart';
import 'package:intl/intl.dart';

class AppointmentListScreen extends StatefulWidget {
  final String petId;
  final String petName;

  const AppointmentListScreen({
    super.key,
    required this.petId,
    required this.petName,
  });

  @override
  State<AppointmentListScreen> createState() => _AppointmentListScreenState();
}

class _AppointmentListScreenState extends State<AppointmentListScreen> {
  List<Appointment> _appointments = [];
  bool _isLoading = true;
  String? _error;
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      print('🔍 [AppointmentListScreen] Cargando citas para mascota: ${widget.petName}');
      print('🔍 [AppointmentListScreen] Pet ID: ${widget.petId}');

      // Obtener el token de Firebase (mismo método que usa PetController)
      final currentUser = FirebaseAuthServiceImpl().getCurrentUser();
      if (currentUser == null) {
        setState(() {
          _error = 'No hay usuario autenticado';
          _isLoading = false;
        });
        return;
      }

      final idToken = await currentUser.getIdToken();
      if (idToken == null) {
        setState(() {
          _error = 'No se pudo obtener el token de acceso';
          _isLoading = false;
        });
        return;
      }

      print('🔍 [AppointmentListScreen] Token obtenido: ${idToken.substring(0, 20)}...');
      setState(() {
        _accessToken = idToken;
      });

      // Load appointments for this pet
      print('🔍 [AppointmentListScreen] Llamando al servicio de citas...');
      final appointments = await AppointmentService.getAppointmentsByPet(
        petId: widget.petId,
        token: idToken,
      );

      print('🔍 [AppointmentListScreen] Respuesta del servicio: success=${appointments.success}');
      print('🔍 [AppointmentListScreen] Mensaje: ${appointments.message}');
      print('🔍 [AppointmentListScreen] Error: ${appointments.error}');

      if (appointments.success) {
        setState(() {
          _appointments = appointments.data ?? [];
          _isLoading = false;
        });
        print('🔍 [AppointmentListScreen] Citas cargadas: ${_appointments.length}');
      } else {
        setState(() {
          _error = appointments.message ?? 'Error al cargar las citas';
          _isLoading = false;
        });
        print('❌ [AppointmentListScreen] Error: ${_error}');
      }
    } catch (e) {
      print('❌ [AppointmentListScreen] Exception: $e');
      setState(() {
        _error = 'Error de conexión: $e';
        _isLoading = false;
      });
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return 'Programada';
      case 'confirmed':
        return 'Confirmada';
      case 'completed':
        return 'Completada';
      case 'cancelled':
        return 'Cancelada';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'confirmed':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getAppointmentTypeText(String type) {
    switch (type.toLowerCase()) {
      case 'consultation':
        return 'Consulta';
      case 'vaccination':
        return 'Vacunación';
      case 'surgery':
        return 'Cirugía';
      case 'emergency':
        return 'Emergencia';
      case 'checkup':
        return 'Revisión';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Citas de ${widget.petName}'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAppointments,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create appointment screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Función de crear cita próximamente')),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
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
              onPressed: _loadAppointments,
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

    if (_appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay citas programadas',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.petName} no tiene citas pendientes',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAppointments,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _appointments.length,
        itemBuilder: (context, index) {
          final appointment = _appointments[index];
          return _buildAppointmentCard(appointment);
        },
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    final scheduledDate = DateTime.parse(appointment.scheduledDate);
    final formattedDate = DateFormat('EEEE, d MMMM yyyy', 'es_ES').format(scheduledDate);
    final formattedTime = DateFormat('HH:mm').format(scheduledDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(appointment.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(appointment.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.access_time,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '${appointment.durationMinutes} min',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.deepPurple,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Colors.deepPurple,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  formattedTime,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.medical_services,
                  color: Colors.deepPurple,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _getAppointmentTypeText(appointment.appointmentType),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.note,
                    color: Colors.deepPurple,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appointment.notes!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Navigate to appointment details
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Detalles próximamente')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.deepPurple),
                    ),
                    child: const Text(
                      'Ver Detalles',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                if (appointment.status.toLowerCase() == 'scheduled' ||
                    appointment.status.toLowerCase() == 'confirmed')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Cancel appointment
                        _showCancelDialog(appointment);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(Appointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancelar Cita'),
          content: Text(
            '¿Estás seguro de que quieres cancelar la cita del ${DateFormat('d MMMM yyyy', 'es_ES').format(DateTime.parse(appointment.scheduledDate))}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _cancelAppointment(appointment.appointmentId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Sí, Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    try {
      if (_accessToken == null) return;

      final result = await AppointmentService.cancelAppointment(
        appointmentId: appointmentId,
        token: _accessToken!,
      );

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cita cancelada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        _loadAppointments(); // Reload the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message ?? 'Error al cancelar la cita'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
