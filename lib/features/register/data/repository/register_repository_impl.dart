import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/register_repository.dart';
import '../datasource/register_datasource.dart';
import '../models/register_request.dart';
import '../models/send_verification_request.dart';
import '../models/verify_email_request.dart';
import '../../../login/data/datasource/login_datasource.dart';
import '../../../login/data/models/login_request.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterDataSource dataSource;
  final LoginDataSource loginDataSource; // para login automático
  final SharedPreferences sharedPreferences;

  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  RegisterRepositoryImpl({
    required this.dataSource,
    required this.loginDataSource,
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

  // Registrar usuario (sin token)
  await dataSource.register(request);

    // Login automático para obtener token
    final loginResp = await loginDataSource.login(
      LoginRequest(email: email, password: password),
    );

    await saveToken(loginResp.token);
    await sharedPreferences.setString(_userIdKey, loginResp.user.id);

    // Convert UserModel to User entity
    final user = User(
      id: loginResp.user.id,
      email: loginResp.user.email,
      name: loginResp.user.name,
      lastName: loginResp.user.lastName,
      phone: loginResp.user.phone,
      isPro: loginResp.user.isPro,
      createdAt: loginResp.user.createdAt,
    );

    return (user: user, token: loginResp.token);
  }

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<String?> getStoredToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<String> sendVerificationCode(String email) async {
    final request = SendVerificationRequest(email: email);
    final response = await dataSource.sendVerificationCode(request);
    return response.message;
  }

  @override
  Future<String> verifyEmail(String email, String code) async {
    final request = VerifyEmailRequest(email: email, code: code);
    final response = await dataSource.verifyEmail(request);
    return response.message;
  }
}
