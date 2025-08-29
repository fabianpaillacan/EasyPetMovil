import 'package:easypet/core/services/pet_service.dart';

class PetController {
  static Future<Map<String, dynamic>> registerPet(Map<String, dynamic> petData) async {
    try {
      final result = await PetService.registerPet(petData);
      return result;
    } catch (e) {
      return {
        'success': false,
        'message': 'Error registering pet: $e',
      };
    }
  }
}
