import 'package:easypet/core/services/pet_service.dart';

class PetsUserController {
  static Future<List<Map<String, dynamic>>> getUserPets() async {
    try {
      // Use mock token for development
      const mockToken = "dev_token_123";
      final pets = await PetService.getUserPets(mockToken);
      return pets;
    } catch (e) {
      return [];
    }
  }
}
