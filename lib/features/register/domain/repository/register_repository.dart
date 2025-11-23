import '../entities/user.dart';

abstract class RegisterRepository {
  Future<({User user, String token})> register({
    required String email,
    required String password,
    required String name,
    String? lastName,
    String? phone,
  });

  Future<void> saveToken(String token);
  Future<String?> getStoredToken();
  
  // Email verification methods
  Future<String> sendVerificationCode(String email);
  Future<String> verifyEmail(String email, String code);
}
