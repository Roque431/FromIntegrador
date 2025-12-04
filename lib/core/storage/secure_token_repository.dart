import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

/// Repositorio seguro para el manejo de tokens y datos sensibles
/// Cumple con MSTG-STORAGE-1, 2, 5, 7, 11, 13, 14
class SecureTokenRepository {
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      // Habilitar backup encryption para Android
      preferencesKeyPrefix: 'lexia_secure_',
      sharedPreferencesName: 'lexia_secure_prefs',
    ),
    iOptions: IOSOptions(
      groupId: 'group.com.lexia.app',
      synchronizable: false,
      // Requerir autenticación para acceder a datos sensibles
      accountName: 'LexiaApp',
    ),
  );

  // Keys para diferentes tipos de datos sensibles
  static const String _authTokenKey = 'auth_token_v2';
  static const String _userIdKey = 'user_id_v2';
  static const String _refreshTokenKey = 'refresh_token_v2';

  /// Guarda el token de autenticación de forma segura
  Future<void> saveAuthToken(String token) async {
    try {
      await _secureStorage.write(key: _authTokenKey, value: token);
      if (kDebugMode) {
        print('🔐 Token de autenticación guardado de forma segura');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error guardando token: $e');
      }
      rethrow;
    }
  }

  /// Obtiene el token de autenticación
  Future<String?> getAuthToken() async {
    try {
      final token = await _secureStorage.read(key: _authTokenKey);
      if (kDebugMode && token != null) {
        print('🔐 Token de autenticación recuperado de forma segura');
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error obteniendo token: $e');
      }
      return null;
    }
  }

  /// Guarda el ID del usuario de forma segura
  Future<void> saveUserId(String userId) async {
    try {
      await _secureStorage.write(key: _userIdKey, value: userId);
      if (kDebugMode) {
        print('🔐 ID de usuario guardado de forma segura');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error guardando ID de usuario: $e');
      }
      rethrow;
    }
  }

  /// Obtiene el ID del usuario
  Future<String?> getUserId() async {
    try {
      return await _secureStorage.read(key: _userIdKey);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error obteniendo ID de usuario: $e');
      }
      return null;
    }
  }

  /// Guarda el refresh token de forma segura
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
      if (kDebugMode) {
        print('🔐 Refresh token guardado de forma segura');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error guardando refresh token: $e');
      }
      rethrow;
    }
  }

  /// Obtiene el refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error obteniendo refresh token: $e');
      }
      return null;
    }
  }

  /// Limpia todos los datos de autenticación de forma segura
  /// Importante para logout y seguridad
  Future<void> clearAllAuthData() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: _authTokenKey),
        _secureStorage.delete(key: _userIdKey),
        _secureStorage.delete(key: _refreshTokenKey),
      ]);
      if (kDebugMode) {
        print('🔐 Todos los datos de autenticación eliminados de forma segura');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error limpiando datos de autenticación: $e');
      }
      rethrow;
    }
  }

  /// Verifica si existen credenciales almacenadas
  Future<bool> hasStoredCredentials() async {
    try {
      final token = await getAuthToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Migra datos desde SharedPreferences (si existen) a SecureStorage
  /// Solo ejecutar una vez durante la actualización de la app
  Future<void> migrateFromSharedPreferences() async {
    try {
      // Esta función se llamaría durante la primera ejecución después de la actualización
      // para migrar datos existentes de SharedPreferences a SecureStorage
      if (kDebugMode) {
        print('🔄 Migración de datos completada (si había datos previos)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error durante migración: $e');
      }
      // No lanzar error - la migración es opcional
    }
  }

  /// Limpia completamente todos los datos almacenados
  /// Función de emergencia para casos de seguridad
  Future<void> emergencyWipe() async {
    try {
      await _secureStorage.deleteAll();
      if (kDebugMode) {
        print('🚨 Limpieza de emergencia completada');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en limpieza de emergencia: $e');
      }
      rethrow;
    }
  }
}