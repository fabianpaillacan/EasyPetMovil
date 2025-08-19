import 'package:easypet/core/services/pet_service.dart';
import 'package:easypet/core/services/firebase_auth_service.dart';

class PetsUserController {
  static Future<List<Map<String, dynamic>>> getUserPets() async {
    try {
      // Get current Firebase user
      final currentUser = FirebaseAuthServiceImpl().getCurrentUser();
      print('DEBUG: Getting pets for user: ${currentUser?.uid}');
      print('DEBUG: User email: ${currentUser?.email}');
      
      if (currentUser == null) {
        print('DEBUG: No current user found');
        return [];
      }

      // Get Firebase ID token
      final idToken = await currentUser.getIdToken();
      print('DEBUG: Using token: ${idToken?.substring(0, 20)}...');
      
      if (idToken == null) {
        print('DEBUG: No token available');
        return [];
      }

      final pets = await PetService.getUserPets(idToken);
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
      // Get current Firebase user
      final currentUser = FirebaseAuthServiceImpl().getCurrentUser();
      print('DEBUG: Getting pets for user: ${currentUser?.uid}');
      print('DEBUG: User email: ${currentUser?.email}');
      
      if (currentUser == null) {
        print('DEBUG: No current user found');
        return [];
      }

      // Get Firebase ID token
      final idToken = await currentUser.getIdToken();
      print('DEBUG: Using token: ${idToken?.substring(0, 20)}...');
      
      if (idToken == null) {
        print('DEBUG: No token available');
        return [];
      }

      final pets = await PetService.getUserPets(idToken);
      print('DEBUG: Retrieved ${pets.length} pets');
      return pets;
    } catch (e) {
      print('Error getting pets: $e');
      return [];
    }
  }
}
