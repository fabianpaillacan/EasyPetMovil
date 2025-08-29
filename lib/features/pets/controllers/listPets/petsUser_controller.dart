import 'package:easypet/core/services/pet_service.dart';
import 'package:easypet/core/services/auth_service.dart';

class PetsUserController {
  static Future<List<Map<String, dynamic>>> getUserPets() async {
    try {
      print('DEBUG: Getting pets for user using JWT tokens');
      
      final pets = await PetService.getUserPets();
      print('DEBUG: Retrieved ${pets.length} pets');
      return pets;
    } catch (e) {
      print('Error getting user pets: $e');
      return [];
    }
  }
}

class PetController {
  static Future<List<Map<String, dynamic>>> getPets() async {
    try {
      print('DEBUG: Getting pets for user using JWT tokens');
      
      final pets = await PetService.getUserPets();
      print('DEBUG: Retrieved ${pets.length} pets');
      return pets;
    } catch (e) {
      print('Error getting pets: $e');
      return [];
    }
  }
}
