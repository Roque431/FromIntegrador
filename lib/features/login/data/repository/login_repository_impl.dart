import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/login_repository.dart';
import '../datasource/login_datasource.dart';
import '../models/login_request.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource dataSource;
  final SharedPreferences sharedPreferences;

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  LoginRepositoryImpl({
    required this.dataSource,
    required this.sharedPreferences,
  });

  @override
  Future<({User user, String token})> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequest(
      email: email,
      password: password,
    );

    final response = await dataSource.login(request);

    // Guardar token en local
    await saveToken(response.token);
    await sharedPreferences.setString(_userIdKey, response.user.id);

    return (user: response.user, token: response.token);
  }

  @override
  Future<({User user, String token})> loginWithGoogle(String idToken) async {
    final response = await dataSource.loginWithGoogle(idToken);

    // Guardar token en local
    await saveToken(response.token);
    await sharedPreferences.setString(_userIdKey, response.user.id);

    return (user: response.user, token: response.token);
  }

  @override
  Future<User> getCurrentUser() async {
    // Si hay token almacenado, inicializarlo en el datasource/apiClient
    final token = sharedPreferences.getString(_tokenKey);
    if (token != null && token.isNotEmpty) {
      try {
        dataSource.setAuthToken(token);
      } catch (_) {
        // En caso de que la implementación no exponga setAuthToken, ignorar
      }
    }

    return await dataSource.getCurrentUser();
  }

  @override
  Future<User> updateProfile({
    required String name,
    required String email,
    String? phone,
  }) async {
    return await dataSource.updateProfile(
      name: name,
      email: email,
      phone: phone,
    );
  }

  @override
  Future<void> logout() async {
    await dataSource.logout();
    await clearToken();
    await sharedPreferences.remove(_userIdKey);
  }

  @override
  Future<String?> getStoredToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<void> clearToken() async {
    await sharedPreferences.remove(_tokenKey);
  }
}
