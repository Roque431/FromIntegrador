class ApiEndpoints {
  // ========================================
  // Auth endpoints - Microservicio Auth
  // ========================================
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String googleLogin = '/api/auth/google/verify';  // Para móvil
  static const String googleLoginWeb = '/api/auth/google';  // Para web redirect
  static const String logout = '/api/auth/logout';
  static const String me = '/api/auth/me';
  static const String updateProfile = '/api/auth/me';  // Assuming PATCH/PUT
  static const String refreshToken = '/api/auth/refresh';

  // Legacy - deprecated
  static const String users = '/api/auth';
  static String userById(String id) => '$users/$id';

  // ========================================
  // Email verification endpoints
  // ========================================
  static const String sendVerificationCode = '/api/auth/resend-verification';
  static const String verifyEmail = '/api/auth/verify-email';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';

  // ========================================
  // Chat/Consultation endpoints (Microservicio Chat con NLP+RAG)
  // ========================================
  static const String chat = '/api/chat';
  static const String chatMessage = '$chat/message';
  static const String chatSessionStart = '$chat/session/start';
  static const String chatSessions = '$chat/sessions';
  static String chatSessionById(String id) => '$chatSessions/$id';
  static String chatHistory(String usuarioId) => '$chat/history/$usuarioId';

  // Profesionista preference endpoints
  static const String profesionistasPreferencia = '$chat/profesionista/preferencia';

  // Legacy compatibility
  static const String consultas = chat;
  static const String consultations = chatSessions;
  static String consultationById(String id) => '$consultations/$id';
  static String createConsultation = chatMessage;
  static String userConsultations(String userId) => chatHistory(userId);

  // ========================================
  // Admin endpoints
  // ========================================
  static const String admin = '/api/admin';
  static const String adminStats = '$admin/stats';
  static const String adminUsers = '$admin/users';
  static const String adminPendingProfiles = '$admin/pending-profiles';
  static const String adminPendingReports = '$admin/pending-reports';
  static const String adminValidateProfile = '$admin/validate-profile';
  static const String adminModerateContent = '$admin/moderate-content';

  // ========================================
  // NLP Service endpoints (Procesamiento de lenguaje natural)
  // ========================================
  static const String nlp = '/api/nlp';
  static const String nlpAnalyze = '$nlp/analyze';
  static const String nlpClassify = '$nlp/classify';

  // Legacy compatibility
  static const String contenido = nlp;
  static const String contentSearch = '$nlp/search';
  static const String contentIngest = '$nlp/ingest';
  static const String contentList = nlp;
  static String contentById(String id) => '$nlp/$id';

  // ========================================
  // RAG Service endpoints (Retrieval-Augmented Generation)
  // ========================================
  static const String rag = '/api/rag';
  static const String ragQuery = '$rag/query';
  static const String ragIngest = '$rag/ingest';
  static const String ragDocuments = '$rag/documents';

  // ========================================
  // Foro de Comunidad endpoints (Chat Service)
  // ========================================
  static const String foro = '/api/chat/foro';
  static const String foroCategorias = '$foro/categorias';
  static const String foroPublicaciones = '$foro/publicaciones';
  static String foroPublicacion(String id) => '$foro/publicacion/$id';
  static String foroPublicacionComentario(String id) => '$foro/publicacion/$id/comentario';
  static String foroPublicacionLike(String id) => '$foro/publicacion/$id/like';
  static String foroPublicacionNoUtil(String id) => '$foro/publicacion/$id/no-util';
  static String foroCategoryMembers(String categoriaId) => '$foro/categoria/$categoriaId/miembros';
  static const String foroBuscar = '$foro/buscar';
  static String foroMisPublicaciones(String usuarioId) => '$foro/mis-publicaciones/$usuarioId';
  static String foroComentarioLike(String comentarioId) => '$foro/comentario/$comentarioId/like';
  
  // ========================================
  // Historial de Conversaciones endpoints (Chat Service)
  // ========================================
  static String userConversations(String usuarioId) => '/api/chat/user/$usuarioId/conversations';
  static String conversationDetail(String sessionId) => '/api/chat/conversation/$sessionId';
  
  // Legacy compatibility
  static const String forum = foro;
  static const String topics = foroPublicaciones;
  static String topicById(String id) => foroPublicacion(id);
  static const String messages = foroPublicaciones;
  static String topicMessages(String topicId) => foroPublicacionComentario(topicId);
  static String createMessage(String topicId) => foroPublicacionComentario(topicId);
  static const String posts = foroPublicaciones;
  static String postById(String id) => foroPublicacion(id);
  static String postComments(String postId) => foroPublicacionComentario(postId);
  static String createComment(String postId) => foroPublicacionComentario(postId);

  // ========================================
  // Geo-Assistance endpoints (Microservicio de Geolocalización)
  // ========================================
  static const String geo = '/api/geo';
  static const String geoAdvisory = '$geo/advisory';
  static const String geoNearby = '$geo/nearby';
  static const String geoLocations = '$geo/locations';
  static String geoLocationById(String id) => '$geoLocations/$id';
  static String geoLocationsByCity(String city) => '$geoLocations?city=$city';
  static String geoLocationsByType(String type) => '$geoLocations?type=$type';

  // Legacy compatibility
  static const String ubicacion = geo;
  static const String advisory = geoAdvisory;
  static const String nearbyLocations = geoNearby;
  static const String locations = geoLocations;
  static String locationById(String id) => geoLocationById(id);
  static String locationsByCity(String city) => geoLocationsByCity(city);
  static String locationsByType(String type) => geoLocationsByType(type);
  static const String legalMap = geoAdvisory;
  static const String asesoria = geoAdvisory;
  static const String nearby = geoNearby;
  static String legalMapByState(String state) => '$geoAdvisory?estado=$state';

  // ========================================
  // Transactions/Subscription endpoints (Microservicio Transacciones)
  // ========================================
  static const String transactions = '/api/transactions';
  static const String createCheckout = '$transactions/create-checkout';
  static const String stripeWebhook = '$transactions/webhook/stripe';
  static String userTransactions(String userId) => '$transactions/user/$userId';
  static String transactionById(String id) => '$transactions/$id';

  // Legacy compatibility
  static const String transacciones = transactions;
  static const String checkout = createCheckout;
  static const String subscriptions = createCheckout;
  static const String createSubscription = createCheckout;

  // ========================================
  // Analytics endpoints (OLAP Cube Service)
  // ========================================
  static const String olap = '/api/olap';
  static const String olapQuery = '$olap/query';
  static const String olapReport = '$olap/report';

  // ========================================
  // Clustering/ML endpoints (Clustering Service)
  // ========================================
  static const String clustering = '/api/clustering';
  static const String clusteringAnalyze = '$clustering/analyze';
  static const String clusteringGroups = '$clustering/groups';
}
