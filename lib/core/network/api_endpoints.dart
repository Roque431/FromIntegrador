class ApiEndpoints {
  // ========================================
  // Auth endpoints - Con prefijo /usuarios/ para nginx
  // ========================================
  static const String register = '/usuarios/users/register';  
  static const String login = '/usuarios/users/login';
  static const String googleLogin = '/usuarios/auth/google';
  static const String logout = '/usuarios/users/logout';
  static const String me = '/usuarios/users/me';
  static const String updateProfile = '/usuarios/users/profile';
  static const String users = '/usuarios/users';
  static String userById(String id) => '$users/$id';

  // ========================================
  // Email verification endpoints
  // ========================================
  static const String sendVerificationCode = '/usuarios/users/send-verification-code';
  static const String verifyEmail = '/usuarios/users/verify-email';

  // ========================================
  // Consultation endpoints (Microservicio Consultas NLP)
  // ========================================
  static const String consultas = '/consultas';
  static const String chatMessage = '$consultas/queries/chat/message';
  static String chatHistory(String usuarioId) => '$consultas/queries/historial/$usuarioId';
  static const String chatSessions = '$consultas/queries/sessions';
  static String chatSessionById(String id) => '$chatSessions/$id';
  
  // Legacy compatibility
  static const String consultations = chatSessions;
  static String consultationById(String id) => '$consultations/$id';
  static String createConsultation = chatMessage;
  static String userConsultations(String userId) => '$chatHistory?usuario_id=$userId';

  // ========================================
  // Legal Content endpoints (Microservicio Contenido Legal)
  // ========================================
  static const String contenido = '/contenido';
  static const String contentSearch = '$contenido/content/search';
  static const String contentIngest = '$contenido/content/ingest';
  static const String contentList = '$contenido/content';
  static String contentById(String id) => '$contenido/content/$id';

  // ========================================
  // Forum endpoints (Microservicio Foro)
  // ========================================
  static const String foro = '/foro';
  static const String topics = '$foro/community/topics';
  static String topicById(String id) => '$topics/$id';
  static const String messages = '$foro/community/messages';
  static String topicMessages(String topicId) => '$topics/$topicId/messages';
  static String createMessage(String topicId) => '$messages';
  
  // Legacy compatibility
  static const String forum = foro;
  static const String posts = topics;
  static String postById(String id) => '$posts/$id';
  static String postComments(String postId) => topicMessages(postId);
  static String createComment(String postId) => createMessage(postId);

  // ========================================
  // Legal map endpoints (Microservicio Orientación Local)
  // ========================================
  static const String ubicacion = '/ubicacion';
  static const String advisory = '$ubicacion/locations/asesoria';
  static const String nearbyLocations = '$ubicacion/locations/nearby';
  static const String locations = '$ubicacion/locations';
  static String locationById(String id) => '$locations/$id';
  static String locationsByCity(String city) => '$locations/ciudad/$city';
  static String locationsByType(String type) => '$locations/tipo/$type';
  
  // Legacy compatibility
  static const String legalMap = advisory;
  static const String asesoria = advisory;
  static const String nearby = nearbyLocations;
  static String legalMapByState(String state) => '$advisory?estado=$state';

  // ========================================
  // Subscription endpoints (Microservicio Transacciones)
  // ========================================
  static const String transactions = '/transactions';
  static const String createCheckout = '$transactions/create-checkout';
  static String userTransactions(String userId) => '$transactions/user/$userId';
  static String transactionById(String id) => '$transactions/$id';
  
  // Legacy compatibility
  static const String transacciones = transactions;
  static const String checkout = createCheckout;
  static const String subscriptions = createCheckout;
  static const String createSubscription = createCheckout;
}
