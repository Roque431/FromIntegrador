import '../entities/user.dart';

abstract class LoginRepository {
  Future<({User user, String token})> login({
    required String email,
    required String password,
  });

  Future<User> getCurrentUser();
  Future<void> logout();
  Future<String?> getStoredToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();
}
