class User {
  final String firstName;
  final String lastName;
  final String rut;
  final String birthDate;
  final String phone;
  final String email;
  final String gender;
  final String password;

  User({
    required this.firstName,
    required this.lastName,
    required this.rut,
    required this.birthDate,
    required this.phone,
    required this.email,
    required this.gender,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'rut': rut,
      'birthDate': birthDate,
      'phone': phone,
      'email': email,
      'gender': gender,
      'password': password,
    };
  }
}