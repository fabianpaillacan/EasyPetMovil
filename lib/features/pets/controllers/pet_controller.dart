
import 'package:flutter/material.dart';

class PetController with ChangeNotifier {
  // Add your properties and methods here
  // Example: List of pets
  List<String> _pets = [];

  List<String> get pets => _pets;

  void addPet(String petName) {
    _pets.add(petName);
    notifyListeners();
  }

  void removePet(String petName) {
    _pets.remove(petName);
    notifyListeners();
  }
}