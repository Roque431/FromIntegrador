import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/login_repository.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/logout_usecase.dart';

enum LoginState { initial, loading, authenticated, unauthenticated, error }

class LoginNotifier extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final LoginRepository loginRepository;

  LoginNotifier({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.loginRepository,
  });

  LoginState _state = LoginState.initial;
  User? _currentUser;
  String? _errorMessage;

  LoginState get state => _state;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == LoginState.authenticated;
  bool get isLoading => _state == LoginState.loading;

  // ==========================================
  // Login con Email y Password
  // ==========================================
  Future<bool> login(String email, String password) async {
    try {
      _state = LoginState.loading;
      _errorMessage = null;
      notifyListeners();

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
  // Login con Google
  // ==========================================
  Future<bool> loginWithGoogle() async {
    try {
      _state = LoginState.loading;
      _errorMessage = null;
      notifyListeners();

      final clientId = kIsWeb ? dotenv.env['GOOGLE_CLIENT_ID'] : null;
      final googleSignIn = GoogleSignIn(clientId: clientId);

      final account = await googleSignIn.signIn();
      if (account == null) {
        _state = LoginState.unauthenticated;
        notifyListeners();
        return false; // usuario canceló
      }

      // TODO: Enviar el token de Google al backend para autenticación
      // Por ahora, simulamos el login exitoso

      // Aquí deberías hacer la llamada al backend con el token de Google
      // final googleAuth = await account.authentication;
      // final idToken = googleAuth.idToken;
      // await apiClient.post('/auth/google', body: {'idToken': idToken});

      // Simulación temporal (eliminar cuando conectes con backend)
      _currentUser = User(
        id: account.id,
        email: account.email,
        name: account.displayName ?? 'Usuario',
        isPro: false,
      );

      _state = LoginState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      _state = LoginState.error;
      _errorMessage = 'Error al iniciar sesión con Google';
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

  // Limpiar errores
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
