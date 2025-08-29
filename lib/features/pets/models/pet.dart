class Pet {
  final String petId;
  final String name;
  final String species;
  final String breed;
  final int age;
  final String? ownerId;
  final String? imageUrl;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final String? birthDate;
  final String? gender;
  final String? color;
  final double? weight;

  Pet({
    required this.petId,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    this.ownerId,
    this.imageUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.birthDate,
    this.gender,
    this.color,
    this.weight,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      petId: json['pet_id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      species: json['species'] ?? '',
      breed: json['breed'] ?? '',
      age: json['age'] ?? 0,
      ownerId: json['owner_id'],
      imageUrl: json['image_url'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      birthDate: json['birth_date']?.toString(),
      gender: json['gender'],
      color: json['color'],
      weight: json['weight']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pet_id': petId,
      'name': name,
      'species': species,
      'breed': breed,
      'age': age,
      'owner_id': ownerId,
      'image_url': imageUrl,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'birth_date': birthDate,
      'gender': gender,
      'color': color,
      'weight': weight,
    };
  }

  @override
  String toString() {
    return 'Pet(petId: $petId, name: $name, species: $species, breed: $breed, age: $age, ownerId: $ownerId, imageUrl: $imageUrl, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, birthDate: $birthDate, gender: $gender, color: $color, weight: $weight)';
  }
}
