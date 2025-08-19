import 'package:easypet/core/services/pet_service.dart';

class PetController {
  static Future<Map<String, dynamic>> registerPet(Map<String, dynamic> petData) async {
    try {
      // Use mock token for development
      const mockToken = "dev_token_123";
      final result = await PetService.registerPet(petData, mockToken);
      return result;
    } catch (e) {
      return {
        'success': false,
        'message': 'Error registering pet: $e',
      };
    }
  }
}
