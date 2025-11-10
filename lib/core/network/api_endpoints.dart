class ApiEndpoints {
  // Base - Sin /api porque nginx ya rutea directo
  static const String api = '';

  // ========================================
  // Auth endpoints (Microservicio Usuarios)
  // ========================================
  static const String usuarios = '/usuarios';
  static const String auth = '$usuarios/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String logout = '$auth/logout';
  static const String me = '$usuarios/users/me';  // Endpoint para perfil
  static const String users = '$usuarios/users';  // CRUD usuarios
  static String userById(String id) => '$users/$id';

  // ========================================
  // Consultas NLP (Chat Legal)
  // ========================================
  static const String consultas = '/consultas';
  static const String chatMessage = '$consultas/queries/chat/message';
  static const String chatHistory = '$consultas/queries/history';
  static const String chatSessions = '$consultas/queries/sessions';
  static String chatSessionById(String id) => '$chatSessions/$id';

  // ========================================
  // Ubicación/Orientación Local
  // ========================================
  static const String ubicacion = '/ubicacion';
  static const String asesoria = '$ubicacion/locations/asesoria';
  static const String nearby = '$ubicacion/locations/nearby';
  static const String locations = '$ubicacion/locations';
  static String locationById(String id) => '$locations/$id';

  // ========================================
  // Foro Comunidad
  // ========================================
  static const String foro = '/foro';
  static const String topics = '$foro/community/topics';
  static const String messages = '$foro/community/messages';
  static String topicById(String id) => '$topics/$id';
  static String messagesByTopic(String topicId) => '$topics/$topicId/messages';

  // ========================================
  // Contenido Legal
  // ========================================
  static const String contenido = '/contenido';
  static const String searchContent = '$contenido/content/search';
  static const String getContent = '$contenido/content';
  static String contentById(String id) => '$getContent/$id';

  // ========================================
  // Transacciones (Stripe)
  // ========================================
  static const String transacciones = '/transacciones';
  static const String checkout = '$transacciones/checkout/create';
  static const String verifyPayment = '$transacciones/checkout/verify';
  static String paymentStatus(String sessionId) => '$transacciones/checkout/status/$sessionId';
}
