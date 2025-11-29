import 'package:flutter/foundation.dart';
import '../../../../core/application/app_state.dart'; // Para AuthStatus
import '../../../../core/services/google_sign_in_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/login_repository.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/logout_usecase.dart';

enum LoginState { initial, loading, authenticated, unauthenticated, error }

class LoginNotifier extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final LoginRepository loginRepository;
  final GoogleSignInService googleSignInService;

  LoginNotifier({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.loginRepository,
    required this.googleSignInService,
  });

  LoginState _state = LoginState.initial;
  User? _currentUser;
  String? _errorMessage;

  LoginState get state => _state;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == LoginState.authenticated;
  bool get isLoading => _state == LoginState.loading;
  
  // Para compatibilidad con AppRouter
  AuthStatus get authStatus {
    switch (_state) {
      case LoginState.loading:
      case LoginState.initial:
        return AuthStatus.checking;
      case LoginState.authenticated:
        return AuthStatus.authenticated;
      case LoginState.unauthenticated:
      case LoginState.error:
        return AuthStatus.notAuthenticated;
    }
  }

  // ==========================================
  // Login con Email y Password
  // ==========================================
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _state = LoginState.loading;
      _errorMessage = null;
      notifyListeners();

      // Login con backend (eliminado modo demo por seguridad MSTG-STORAGE)
      final result = await loginUseCase(
        email: email,
        password: password,
      );

      _currentUser = result.user;
      _state = LoginState.authenticated;
      notifyListeners();

      return true;
    } catch (e) {
      _state = LoginState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ==========================================
  // Logout
  // ==========================================
  Future<void> logout() async {
    try {
      await logoutUseCase();
      _currentUser = null;
      _state = LoginState.unauthenticated;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // ==========================================
  // Setear usuario después de autenticación exitosa
  // ==========================================
  void setUserAfterSuccessfulAuth(String userId, String userEmail, String userName, String? lastName, String? phone, String token) {
    _currentUser = User(
      id: userId,
      email: userEmail,
      name: userName,
      lastName: lastName,
      phone: phone,
      isPro: false,
    );
    _state = LoginState.authenticated;
    _errorMessage = null;
    notifyListeners();
  }

  // ==========================================
  // Login con Google
  // ==========================================
  Future<bool> loginWithGoogle() async {
    try {
      _state = LoginState.loading;
      _errorMessage = null;
      notifyListeners();

      print('🔄 Iniciando proceso de login con Google...');

      // 1. Iniciar sesión con Google
      final account = await googleSignInService.signIn();
      if (account == null) {
        print('❌ Google Sign-In cancelado');
        _state = LoginState.unauthenticated;
        _errorMessage = 'Login con Google cancelado';
        notifyListeners();
        return false; // Usuario canceló
      }

      print('✅ Cuenta de Google obtenida: ${account.email}');

      // 2. Obtener el ID token de Google
      final idToken = await googleSignInService.getIdToken();
      if (idToken == null) {
        print('❌ No se pudo obtener el ID token de Google');
        _state = LoginState.error;
        _errorMessage = 'No se pudo obtener el token de autenticación de Google';
        notifyListeners();
        return false;
      }

      print('✅ ID Token obtenido, enviando al backend...');

      // 3. Enviar el token al backend para autenticar con OAuth
      final result = await loginRepository.loginWithGoogle(idToken);

      _currentUser = result.user;
      await loginRepository.saveToken(result.token);

      print('✅ Login con Google completado exitosamente');
      _state = LoginState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error completo en Google Sign-In: $e');
      print('   Stack trace: ${StackTrace.current}');
      
      _state = LoginState.error;
      
      // Mensajes de error más específicos
      if (e.toString().contains('network')) {
        _errorMessage = 'Error de conexión. Verifica tu internet.';
      } else if (e.toString().contains('google-services')) {
        _errorMessage = 'Error de configuración de Google. Contacta soporte.';
      } else if (e.toString().contains('token')) {
        _errorMessage = 'Error de autenticación con Google. Intenta nuevamente.';
      } else if (e.toString().contains('ApiException')) {
        _errorMessage = 'Error del servidor. Intenta más tarde.';
      } else {
        _errorMessage = 'No se pudo iniciar sesión con Google. Intenta más tarde.';
      }
      
      notifyListeners();
      return false;
    }
  }

  // ==========================================
  // Check Auth Status (al iniciar la app)
  // ==========================================
  Future<void> checkAuthStatus() async {
    try {
      final token = await loginRepository.getStoredToken();

      if (token == null || token.isEmpty) {
        _state = LoginState.unauthenticated;
        notifyListeners();
        return;
      }

      // Intentar obtener el usuario actual
      _currentUser = await loginRepository.getCurrentUser();
      _state = LoginState.authenticated;
      notifyListeners();
    } catch (e) {
      _state = LoginState.unauthenticated;
      await loginRepository.clearToken();
      notifyListeners();
    }
  }

  // ==========================================
  // Actualizar Perfil de Usuario
  // ==========================================
  Future<bool> updateProfile({
    required String name,
    required String email,
    String? phone,
  }) async {
    try {
      _state = LoginState.loading;
      notifyListeners();

      // Hacer la llamada real al backend
      final updatedUser = await loginRepository.updateProfile(
        name: name,
        email: email,
        phone: phone,
      );

      // Actualizar el usuario actual con los datos del backend
      _currentUser = updatedUser;

      _state = LoginState.authenticated;
      _errorMessage = null;
      notifyListeners();
      return true;

    } catch (e) {
      _state = LoginState.authenticated; // Mantener autenticado pero mostrar error
      _errorMessage = 'Error al actualizar el perfil: $e';
      notifyListeners();
      return false;
    }
  }

  // Limpiar errores
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ==========================================
  // Refrescar usuario desde backend (plan / isPro)
  // ==========================================
  Future<void> refreshCurrentUser() async {
    try {
      final user = await loginRepository.getCurrentUser();
      _currentUser = user;
      notifyListeners();
    } catch (_) {
      // Silencioso: si falla no cambiamos estado
    }
  }
}
