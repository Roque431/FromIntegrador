import '../entities/user.dart';
import '../repository/register_repository.dart';

class RegisterUseCase {
  final RegisterRepository repository;

  RegisterUseCase({required this.repository});

  Future<({User user, String token})> call({
    required String email,
    required String password,
    required String name,
    String? lastName,
    String? phone,
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

    if (name.isEmpty) {
      throw Exception('El nombre es requerido');
    }

    if (name.length < 2) {
      throw Exception('El nombre debe tener al menos 2 caracteres');
    }

    // Ejecutar registro
    return await repository.register(
      email: email,
      password: password,
      name: name,
      lastName: lastName,
      phone: phone,
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
