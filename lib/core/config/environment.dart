enum Environment { dev, prod }

class EnvironmentConfig {
  static const Environment _environment = Environment.dev;

  static String get apiBaseUrl {
    switch (_environment) {
      case Environment.dev:
        // In Android emulator, use 10.0.2.2 to access host localhost
        return 'http://10.0.2.2:8000';
      case Environment.prod:
        return 'https://api.easypet.com';
    }
  }

  static String get userServiceUrl {
    switch (_environment) {
      case Environment.dev:
        return '$apiBaseUrl/users';
      case Environment.prod:
        return 'https://user-service.easypet.com';
    }
  }

  static String get petServiceUrl {
    switch (_environment) {
      case Environment.dev:
        return '$apiBaseUrl/pets';
      case Environment.prod:
        return 'https://pet-service.easypet.com';
    }
  }

  static String get appointmentServiceUrl {
    switch (_environment) {
      case Environment.dev:
        return '$apiBaseUrl';
      case Environment.prod:
        return 'https://appointment-service.easypet.com';
    }
  }

  static String get veterinarianServiceUrl {
    switch (_environment) {
      case Environment.dev:
        return '$apiBaseUrl/veterinarians';
      case Environment.prod:
        return 'https://veterinarian-service.easypet.com';
    }
  }

  static String get medicalCenterServiceUrl {
    switch (_environment) {
      case Environment.dev:
        return '$apiBaseUrl/medical-centers';
      case Environment.prod:
        return 'https://medical-center-service.easypet.com';
    }
  }

  static String get ratingServiceUrl {
    switch (_environment) {
      case Environment.dev:
        return '$apiBaseUrl/ratings';
      case Environment.prod:
        return 'https://rating-service.easypet.com';
    }
  }

  static String get medicationServiceUrl {
    switch (_environment) {
      case Environment.dev:
        return '$apiBaseUrl/medications';
      case Environment.prod:
        return 'https://medication-service.easypet.com';
    }
  }

  static Duration get requestTimeout => const Duration(seconds: 30);
} 