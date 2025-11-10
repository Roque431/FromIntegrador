import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/register_repository.dart';
import '../datasource/register_datasource.dart';
import '../models/register_request.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterDataSource dataSource;
  final SharedPreferences sharedPreferences;

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  RegisterRepositoryImpl({
    required this.dataSource,
    required this.sharedPreferences,
  });

  @override
  Future<({User user, String token})> register({
    required String email,
    required String password,
    required String name,
    String? lastName,
    String? phone,
  }) async {
    final request = RegisterRequest(
      email: email,
      password: password,
      name: name,
      lastName: lastName,
      phone: phone,
    );

    final response = await dataSource.register(request);

    // Guardar token en local
    await saveToken(response.token);
    await sharedPreferences.setString(_userIdKey, response.user.id);

    return (user: response.user, token: response.token);
  }

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<String?> getStoredToken() async {
    return sharedPreferences.getString(_tokenKey);
  }
}
