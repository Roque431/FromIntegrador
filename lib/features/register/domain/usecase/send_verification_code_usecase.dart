import '../repository/register_repository.dart';

class SendVerificationCodeUseCase {
  final RegisterRepository repository;

  SendVerificationCodeUseCase(this.repository);

  Future<String> call(String email) async {
    if (email.isEmpty) {
      throw Exception('El correo electrónico es requerido');
    }

    if (!_isValidEmail(email)) {
      throw Exception('El correo electrónico no es válido');
    }

    return await repository.sendVerificationCode(email);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}
