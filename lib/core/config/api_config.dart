class ApiConfig {
  // URLs base
  static const String baseUrl = 'http://10.0.2.2:8000';
  
  // Endpoints de autenticación
  static const String authPingEndpoint = '/auth/user/ping';
  
  // URL completa para ping de autenticación
  static String get authPingUrl => '$baseUrl$authPingEndpoint';
} 