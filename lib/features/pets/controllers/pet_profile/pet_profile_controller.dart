import 'package:easypet/core/services/pet_service.dart';
import 'package:easypet/core/services/auth_service.dart';

class PetProfileController {
  static Future<Map<String, dynamic>> getPetProfile(String petId) async {
    try {
      final profile = await PetService.getPetProfile(petId);
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
      final result = await PetService.deletePet(petId);
      return result;
    } catch (e) {
      return false;
    }
  }
}
