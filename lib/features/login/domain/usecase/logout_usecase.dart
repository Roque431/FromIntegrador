import '../repository/login_repository.dart';

class LogoutUseCase {
  final LoginRepository repository;

  LogoutUseCase({required this.repository});

  Future<void> call() async {
    await repository.logout();
  }
}
