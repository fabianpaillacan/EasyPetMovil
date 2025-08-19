import 'package:easypet/core/services/pet_service.dart';

class PetProfileController {
  static Future<Map<String, dynamic>> getPetProfile(String petId) async {
    try {
      // Use mock token for development
      const mockToken = "dev_token_123";
      final profile = await PetService.getPetProfile(petId, mockToken);
      return profile;
    } catch (e) {
      return {
        'success': false,
        'message': 'Error getting pet profile: $e',
      };
    }
  }

  static Future<bool> deletePet(String petId) async {
    try {
      // Use mock token for development
      const mockToken = "dev_token_123";
      final result = await PetService.deletePet(petId, mockToken);
      return result;
    } catch (e) {
      return false;
    }
  }
}
