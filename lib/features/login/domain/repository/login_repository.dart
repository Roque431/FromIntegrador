import '../entities/user.dart';

abstract class LoginRepository {
  Future<({User user, String token})> login({
    required String email,
    required String password,
  });

  Future<({User user, String token})> loginWithGoogle(String idToken);

  Future<User> getCurrentUser();
  Future<User> updateProfile({
    required String name,
    required String email,
    String? phone,
  });
  Future<void> logout();
  Future<String?> getStoredToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();
}
