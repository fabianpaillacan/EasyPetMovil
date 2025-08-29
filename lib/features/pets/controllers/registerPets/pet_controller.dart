import 'package:easypet/core/services/pet_service.dart';
import 'package:easypet/core/services/auth_service.dart';

class PetController {
  static Future<Map<String, dynamic>> registerPet(Map<String, dynamic> petData) async {
    try {
      print('DEBUG: Registering pet using JWT tokens');
      
      final result = await PetService.registerPet(petData);
      return {
        'success': true,
        'message': 'Mascota registrada exitosamente',
        'data': result,
      };
    } catch (e) {
      print('DEBUG: Error in registerPet: $e');
      return {
        'success': false,
        'message': 'Error registering pet: $e',
      };
    }
  }
}

class PetControllerRegister {
  static Future<String> registerPets({
    required String name,
    required String breed,
    //required String weight,
    required String age,
    required String color,
    required String gender,
    required String birthDate,
    required String species,
  }) async {
    try {
      print('DEBUG: Registering pet using JWT tokens');

      final petData = {
        'name': name,
        'breed': breed,
        //'weight': double.tryParse(weight) ?? 0.0,
        'age': int.tryParse(age) ?? 0,
        'color': color,
        'gender': gender,
        'species': species,
        'birth_date': birthDate,
        'is_active': true,
      };
      
      print('DEBUG: Attempting to register pet with data: $petData');
      final result = await PetService.registerPet(petData);
      print('DEBUG: Pet registration successful: $result');
      return 'Mascota registrada exitosamente';
    } catch (e) {
      print('DEBUG: Error in registerPets: $e');
      
      // Determinar si es un error de conexión real o un error de negocio
      if (e.toString().contains('Error de conexión')) {
        return 'Error de conexión. Verifica tu conexión a internet e intenta nuevamente.';
      } else if (e.toString().contains('Error al registrar mascota')) {
        return 'Error al registrar mascota. Verifica los datos e intenta nuevamente.';
      } else {
        return 'Error inesperado: $e';
      }
    }
  }
}
