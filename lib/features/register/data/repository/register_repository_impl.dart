import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/register_repository.dart';
import '../datasource/register_datasource.dart';
import '../models/register_request.dart';
import '../models/send_verification_request.dart';
import '../models/verify_email_request.dart';
import '../../../login/data/datasource/login_datasource.dart';
import '../../../login/data/models/login_request.dart';
import '../../../../core/storage/secure_token_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterDataSource dataSource;
  final LoginDataSource loginDataSource; // para login automático
  final SharedPreferences sharedPreferences;
  final SecureTokenRepository _secureTokenRepository;

  // Deprecated - mantenido solo para migración
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  RegisterRepositoryImpl({
    required this.dataSource,
    required this.loginDataSource,
    required this.sharedPreferences,
    required SecureTokenRepository secureTokenRepository,
  }) : _secureTokenRepository = secureTokenRepository;

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

    // Guardar en almacenamiento seguro (MSTG-STORAGE-1 compliance)
    await _secureTokenRepository.saveAuthToken(loginResp.token);
    await _secureTokenRepository.saveUserId(loginResp.user.id);

    // Migrar y limpiar datos antiguos si existen
    await _migrateAndCleanOldData();

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
    await _secureTokenRepository.saveAuthToken(token);
  }

  @override
  Future<String?> getStoredToken() async {
    return await _secureTokenRepository.getAuthToken();
  }

  /// Migra datos de SharedPreferences a SecureStorage y limpia datos antiguos
  Future<void> _migrateAndCleanOldData() async {
    try {
      // Verificar si hay datos antiguos en SharedPreferences
      final oldToken = sharedPreferences.getString(_tokenKey);
      final oldUserId = sharedPreferences.getString(_userIdKey);
      
      if (oldToken != null || oldUserId != null) {
        // Limpiar datos antiguos de SharedPreferences
        await sharedPreferences.remove(_tokenKey);
        await sharedPreferences.remove(_userIdKey);
        
        print('🔄 Datos de registro migrados a almacenamiento seguro');
      }
    } catch (e) {
      print('⚠️ Error durante migración en registro: $e');
    }
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
