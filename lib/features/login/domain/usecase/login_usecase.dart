import '../entities/user.dart';
import '../repository/login_repository.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase({required this.repository});

  Future<({User user, String token})> call({
    required String email,
    required String password,
  }) async {
    // Validaciones
    if (email.isEmpty) {
      throw Exception('El correo electrónico es requerido');
    }

    if (!_isValidEmail(email)) {
      throw Exception('El correo electrónico no es válido');
    }

    if (password.isEmpty) {
      throw Exception('La contraseña es requerida');
    }

    if (password.length < 6) {
      throw Exception('La contraseña debe tener al menos 6 caracteres');
    }

    // Ejecutar login
    return await repository.login(
      email: email,
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
