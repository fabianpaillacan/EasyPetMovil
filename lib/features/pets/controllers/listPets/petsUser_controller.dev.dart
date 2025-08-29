import 'package:easypet/core/services/pet_service.dart';

class PetsUserController {
  static Future<List<Map<String, dynamic>>> getUserPets() async {
    try {
      final pets = await PetService.getUserPets();
      return pets;
    } catch (e) {
      return [];
    }
  }
}
