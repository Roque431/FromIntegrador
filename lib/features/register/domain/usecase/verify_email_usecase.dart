import '../repository/register_repository.dart';

class VerifyEmailUseCase {
  final RegisterRepository repository;

  VerifyEmailUseCase(this.repository);

  Future<String> call(String email, String code) async {
    if (email.isEmpty) {
      throw Exception('El correo electrónico es requerido');
    }

    if (code.isEmpty) {
      throw Exception('El código de verificación es requerido');
    }

    if (code.length < 4) {
      throw Exception('El código debe tener al menos 4 caracteres');
    }

    return await repository.verifyEmail(email, code);
  }
}
