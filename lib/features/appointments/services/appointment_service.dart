import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/appointment.dart';

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });
}

class AppointmentService {
  static const String baseUrl = 'http://10.0.2.2:8003'; // Para emulador Android
  // static const String baseUrl = 'http://localhost:8003'; // Para dispositivo físico

  static Future<ApiResponse<List<Appointment>>> getAppointmentsByPet({
    required String petId,
    required String token,
  }) async {
    try {
      print('🔍 [AppointmentService] Obteniendo citas para mascota: $petId');
      print('🔍 [AppointmentService] URL: $baseUrl/appointments?pet_id=$petId');
      print('🔍 [AppointmentService] Token: ${token.substring(0, 20)}...');

      final response = await http.get(
        Uri.parse('$baseUrl/appointments?pet_id=$petId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('🔍 [AppointmentService] Response status: ${response.statusCode}');
      print('🔍 [AppointmentService] Response headers: ${response.headers}');
      print('🔍 [AppointmentService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('🔍 [AppointmentService] JSON data: $jsonData');
        print('🔍 [AppointmentService] Número de citas: ${jsonData.length}');
        
        final appointments = jsonData
            .map((json) => Appointment.fromJson(json))
            .toList();
        
        print('🔍 [AppointmentService] Citas parseadas: ${appointments.length}');
        for (var apt in appointments) {
          print('🔍 [AppointmentService] Cita: ${apt.appointmentType} - ${apt.scheduledDate} - ${apt.status}');
        }
        
        return ApiResponse<List<Appointment>>(
          success: true,
          data: appointments,
        );
      } else {
        print('❌ [AppointmentService] Error HTTP: ${response.statusCode}');
        final errorData = json.decode(response.body);
        print('❌ [AppointmentService] Error data: $errorData');
        
        return ApiResponse<List<Appointment>>(
          success: false,
          message: errorData['detail'] ?? 'Error al obtener las citas',
          error: 'HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ [AppointmentService] Exception: $e');
      return ApiResponse<List<Appointment>>(
        success: false,
        message: 'Error de conexión: $e',
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<List<Appointment>>> getAllAppointments({
    required String token,
  }) async {
    try {
      print('🔍 [AppointmentService] Obteniendo todas las citas...');
      print('🔍 [AppointmentService] URL: $baseUrl/appointments');
      
      final response = await http.get(
        Uri.parse('$baseUrl/appointments'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('🔍 [AppointmentService] Response status: ${response.statusCode}');
      print('🔍 [AppointmentService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final appointments = jsonData
            .map((json) => Appointment.fromJson(json))
            .toList();
        
        print('🔍 [AppointmentService] Total de citas: ${appointments.length}');
        
        return ApiResponse<List<Appointment>>(
          success: true,
          data: appointments,
        );
      } else {
        final errorData = json.decode(response.body);
        return ApiResponse<List<Appointment>>(
          success: false,
          message: errorData['detail'] ?? 'Error al obtener las citas',
          error: 'HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ [AppointmentService] Exception: $e');
      return ApiResponse<List<Appointment>>(
        success: false,
        message: 'Error de conexión: $e',
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<Appointment>> getAppointmentById({
    required String appointmentId,
    required String token,
  }) async {
    try {
      print('🔍 [AppointmentService] Obteniendo cita por ID: $appointmentId');
      
      final response = await http.get(
        Uri.parse('$baseUrl/appointments/$appointmentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('🔍 [AppointmentService] Response status: ${response.statusCode}');
      print('🔍 [AppointmentService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final appointment = Appointment.fromJson(jsonData);
        
        print('🔍 [AppointmentService] Cita obtenida: ${appointment.appointmentType}');
        
        return ApiResponse<Appointment>(
          success: true,
          data: appointment,
        );
      } else {
        final errorData = json.decode(response.body);
        return ApiResponse<Appointment>(
          success: false,
          message: errorData['detail'] ?? 'Error al obtener la cita',
          error: 'HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ [AppointmentService] Exception: $e');
      return ApiResponse<Appointment>(
        success: false,
        message: 'Error de conexión: $e',
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<Appointment>> createAppointment({
    required Map<String, dynamic> appointmentData,
    required String token,
  }) async {
    try {
      print('🔍 [AppointmentService] Creando cita...');
      print('🔍 [AppointmentService] Data: $appointmentData');
      
      final response = await http.post(
        Uri.parse('$baseUrl/appointments'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(appointmentData),
      );

      print('🔍 [AppointmentService] Response status: ${response.statusCode}');
      print('🔍 [AppointmentService] Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        final appointment = Appointment.fromJson(jsonData);
        
        print('🔍 [AppointmentService] Cita creada: ${appointment.appointmentId}');
        
        return ApiResponse<Appointment>(
          success: true,
          data: appointment,
        );
      } else {
        final errorData = json.decode(response.body);
        return ApiResponse<Appointment>(
          success: false,
          message: errorData['detail'] ?? 'Error al crear la cita',
          error: 'HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ [AppointmentService] Exception: $e');
      return ApiResponse<Appointment>(
        success: false,
        message: 'Error de conexión: $e',
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<Appointment>> updateAppointment({
    required String appointmentId,
    required Map<String, dynamic> updateData,
    required String token,
  }) async {
    try {
      print('🔍 [AppointmentService] Actualizando cita: $appointmentId');
      print('🔍 [AppointmentService] Update data: $updateData');
      
      final response = await http.put(
        Uri.parse('$baseUrl/appointments/$appointmentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(updateData),
      );

      print('🔍 [AppointmentService] Response status: ${response.statusCode}');
      print('🔍 [AppointmentService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final appointment = Appointment.fromJson(jsonData);
        
        print('🔍 [AppointmentService] Cita actualizada: ${appointment.appointmentId}');
        
        return ApiResponse<Appointment>(
          success: true,
          data: appointment,
        );
      } else {
        final errorData = json.decode(response.body);
        return ApiResponse<Appointment>(
          success: false,
          message: errorData['detail'] ?? 'Error al actualizar la cita',
          error: 'HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ [AppointmentService] Exception: $e');
      return ApiResponse<Appointment>(
        success: false,
        message: 'Error de conexión: $e',
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<bool>> cancelAppointment({
    required String appointmentId,
    required String token,
  }) async {
    try {
      print('🔍 [AppointmentService] Cancelando cita: $appointmentId');
      
      final response = await http.delete(
        Uri.parse('$baseUrl/appointments/$appointmentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('🔍 [AppointmentService] Response status: ${response.statusCode}');
      print('🔍 [AppointmentService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('🔍 [AppointmentService] Cita cancelada exitosamente');
        return ApiResponse<bool>(
          success: true,
          data: true,
        );
      } else {
        final errorData = json.decode(response.body);
        return ApiResponse<bool>(
          success: false,
          message: errorData['detail'] ?? 'Error al cancelar la cita',
          error: 'HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ [AppointmentService] Exception: $e');
      return ApiResponse<bool>(
        success: false,
        message: 'Error de conexión: $e',
        error: e.toString(),
      );
    }
  }

  static Future<ApiResponse<List<Appointment>>> getUpcomingAppointments({
    required String token,
    int days = 30,
  }) async {
    try {
      print('🔍 [AppointmentService] Obteniendo citas próximas (${days} días)...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/appointments/upcoming/list?days=$days'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('🔍 [AppointmentService] Response status: ${response.statusCode}');
      print('🔍 [AppointmentService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final appointments = jsonData
            .map((json) => Appointment.fromJson(json))
            .toList();
        
        print('🔍 [AppointmentService] Citas próximas: ${appointments.length}');
        
        return ApiResponse<List<Appointment>>(
          success: true,
          data: appointments,
        );
      } else {
        final errorData = json.decode(response.body);
        return ApiResponse<List<Appointment>>(
          success: false,
          message: errorData['detail'] ?? 'Error al obtener las citas próximas',
          error: 'HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ [AppointmentService] Exception: $e');
      return ApiResponse<List<Appointment>>(
        success: false,
        message: 'Error de conexión: $e',
        error: e.toString(),
      );
    }
  }
}