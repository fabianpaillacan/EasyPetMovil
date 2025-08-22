import 'package:easypet/core/services/pet_service.dart';
import 'package:easypet/core/services/firebase_auth_service.dart';

class PetController {
  static Future<Map<String, dynamic>> registerPet(Map<String, dynamic> petData) async {
    try {
      // Get current Firebase user
      final currentUser = FirebaseAuthServiceImpl().getCurrentUser();
      print('DEBUG: Current Firebase user: ${currentUser?.uid}');
      print('DEBUG: Current Firebase user email: ${currentUser?.email}');
      
      if (currentUser == null) {
        return {
          'success': false,
          'message': 'Usuario no autenticado. Por favor inicie sesión.',
        };
      }

      // Get Firebase ID token
      final idToken = await currentUser.getIdToken();
      print('DEBUG: Firebase ID token: ${idToken?.substring(0, 20)}...');
      
      if (idToken == null) {
        return {
          'success': false,
          'message': 'Error al obtener el token de autenticación.',
        };
      }

      final result = await PetService.registerPet(petData, idToken);
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
      // Get current Firebase user
      final currentUser = FirebaseAuthServiceImpl().getCurrentUser();
      print('DEBUG: Current Firebase user: ${currentUser?.uid}');
      print('DEBUG: Current Firebase user email: ${currentUser?.email}');
      
      if (currentUser == null) {
        return 'Usuario no autenticado. Por favor inicie sesión.';
      }

      // Get Firebase ID token
      final idToken = await currentUser.getIdToken();
      print('DEBUG: Firebase ID token: ${idToken?.substring(0, 20)}...');
      
      if (idToken == null) {
        return 'Error al obtener el token de autenticación.';
      }

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
      
      final result = await PetService.registerPet(petData, idToken);
      return 'Mascota registrada exitosamente';
    } catch (e) {
      print('DEBUG: Error in registerPets: $e');
      return 'Error registering pet: $e';
    }
  }
}
