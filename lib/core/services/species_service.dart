import 'dart:convert';
import 'package:flutter/services.dart';

class SpeciesService {
  static Map<String, List<String>>? _speciesData;
  
  // Cargar datos del JSON local
  static Future<Map<String, List<String>>> loadSpeciesData() async {
    if (_speciesData != null) {
      return _speciesData!;
    }
    
    try {
      final String jsonString = await rootBundle.loadString('assets/mascotas.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      _speciesData = Map<String, List<String>>.from(
        jsonData.map((key, value) => MapEntry(
          key,
          List<String>.from(value),
        )),
      );
      
      return _speciesData!;
    } catch (e) {
      print('Error cargando datos de especies: $e');
      // Retornar datos por defecto en caso de error
      return {
        'perro': ['Común o Mestizo', 'Otro'],
        'gato': ['Común o Mestizo', 'Otro'],
        'pez': ['Otro'],
        'ave': ['Otro'],
        'conejo': ['Común o Mestizo', 'Otro'],
        'hámster': ['Otro'],
        'cobaya': ['Otro'],
        'tortuga': ['Otro'],
      };
    }
  }
  
  // Obtener lista de especies
  static Future<List<String>> getSpecies() async {
    final data = await loadSpeciesData();
    return data.keys.toList();
  }
  
  // Obtener razas por especie
  static Future<List<String>> getBreedsBySpecies(String species) async {
    final data = await loadSpeciesData();
    return data[species] ?? ['Otro'];
  }
  
  // Obtener todas las especies y razas
  static Future<Map<String, List<String>>> getAllSpeciesAndBreeds() async {
    return await loadSpeciesData();
  }
}
