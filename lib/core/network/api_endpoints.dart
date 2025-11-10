class ApiEndpoints {
  // Base
  static const String api = '/api';
  static const String v1 = '$api/v1';

  // Auth endpoints
  static const String auth = '$v1/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String logout = '$auth/logout';
  static const String refreshToken = '$auth/refresh';
  static const String me = '$auth/me';
  static const String forgotPassword = '$auth/forgot-password';
  static const String resetPassword = '$auth/reset-password';

  // User endpoints
  static const String users = '$v1/users';
  static String userById(String id) => '$users/$id';
  static String updateUser(String id) => '$users/$id';
  static String deleteUser(String id) => '$users/$id';

  // Consultation endpoints
  static const String consultations = '$v1/consultations';
  static String consultationById(String id) => '$consultations/$id';
  static String createConsultation = consultations;
  static String userConsultations(String userId) => '$users/$userId/consultations';

  // Forum endpoints
  static const String forum = '$v1/forum';
  static const String posts = '$forum/posts';
  static String postById(String id) => '$posts/$id';
  static String postComments(String postId) => '$posts/$postId/comments';
  static String createComment(String postId) => '$posts/$postId/comments';

  // Legal map endpoints
  static const String legalMap = '$v1/legal-map';
  static String legalMapByState(String state) => '$legalMap/$state';

  // Subscription endpoints
  static const String subscriptions = '$v1/subscriptions';
  static const String createSubscription = '$subscriptions/create';
  static const String cancelSubscription = '$subscriptions/cancel';
  static String subscriptionStatus(String userId) => '$subscriptions/$userId/status';
}
