import 'dart:convert';
import 'package:flutter/services.dart';

class SpeciesService {
  static Map<String, List<String>>? _speciesData;
  
  // Cargar datos del JSON local
  static Future<Map<String, List<String>>> loadSpeciesData() async {
    if (_speciesData != null) {
      print('Usando datos de especies en caché');
      return _speciesData!;
    }
    
    try {
      print('Cargando archivo mascotas.json...');
      final String jsonString = await rootBundle.loadString('assets/mascotas.json');
      print('Archivo JSON cargado, tamaño: ${jsonString.length} caracteres');
      
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      print('JSON decodificado, claves: ${jsonData.keys.toList()}');
      
      _speciesData = Map<String, List<String>>.from(
        jsonData.map((key, value) => MapEntry(
          key,
          List<String>.from(value),
        )),
      );
      
      print('Datos de especies procesados: ${_speciesData!.keys.toList()}');
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
    final breeds = data[species] ?? ['Otro'];
    print('Razas obtenidas para $species: $breeds');
    return breeds;
  }
  
  // Obtener todas las especies y razas
  static Future<Map<String, List<String>>> getAllSpeciesAndBreeds() async {
    return await loadSpeciesData();
  }
}
