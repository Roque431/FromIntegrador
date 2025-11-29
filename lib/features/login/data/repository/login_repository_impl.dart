import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/login_repository.dart';
import '../datasource/login_datasource.dart';
import '../models/login_request.dart';
import '../../../../core/storage/secure_token_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource dataSource;
  final SharedPreferences sharedPreferences;
  final SecureTokenRepository _secureTokenRepository;

  // Deprecated - mantenido solo para migración
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  LoginRepositoryImpl({
    required this.dataSource,
    required this.sharedPreferences,
    required SecureTokenRepository secureTokenRepository,
  }) : _secureTokenRepository = secureTokenRepository;

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

    // Guardar token en almacenamiento seguro (MSTG-STORAGE-1 compliance)
    await _secureTokenRepository.saveAuthToken(response.token);
    await _secureTokenRepository.saveUserId(response.user.id);

    // Migrar y limpiar datos antiguos de SharedPreferences si existen
    await _migrateAndCleanOldData();

    return (user: response.user, token: response.token);
  }

  @override
  Future<({User user, String token})> loginWithGoogle(String idToken) async {
    final response = await dataSource.loginWithGoogle(idToken);

    // Guardar token en almacenamiento seguro (MSTG-STORAGE-1 compliance)
    await _secureTokenRepository.saveAuthToken(response.token);
    await _secureTokenRepository.saveUserId(response.user.id);

    // Migrar y limpiar datos antiguos de SharedPreferences si existen
    await _migrateAndCleanOldData();

    return (user: response.user, token: response.token);
  }

  @override
  Future<User> getCurrentUser() async {
    // Obtener token desde almacenamiento seguro
    final token = await _secureTokenRepository.getAuthToken();
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
    
    // Limpiar tanto almacenamiento seguro como SharedPreferences (migración)
    await _secureTokenRepository.clearAllAuthData();
    await sharedPreferences.remove(_tokenKey);
    await sharedPreferences.remove(_userIdKey);
  }

  @override
  Future<String?> getStoredToken() async {
    return await _secureTokenRepository.getAuthToken();
  }

  @override
  Future<void> saveToken(String token) async {
    await _secureTokenRepository.saveAuthToken(token);
  }

  @override
  Future<void> clearToken() async {
    await _secureTokenRepository.clearAllAuthData();
  }

  /// Migra datos de SharedPreferences a SecureStorage y limpia datos antiguos
  /// Solo se ejecuta una vez durante el proceso de login
  Future<void> _migrateAndCleanOldData() async {
    try {
      // Verificar si hay datos antiguos en SharedPreferences
      final oldToken = sharedPreferences.getString(_tokenKey);
      final oldUserId = sharedPreferences.getString(_userIdKey);
      
      if (oldToken != null || oldUserId != null) {
        // Limpiar datos antiguos de SharedPreferences
        await sharedPreferences.remove(_tokenKey);
        await sharedPreferences.remove(_userIdKey);
        
        print('🔄 Datos migrados de SharedPreferences a almacenamiento seguro');
      }
    } catch (e) {
      print('⚠️ Error durante migración de datos: $e');
      // No lanzar error - la migración no debe interrumpir el flujo principal
    }
  }
}
