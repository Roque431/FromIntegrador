import '../entities/consultation.dart';
import '../repository/consultation_repository.dart';

class GetChatHistoryUseCase {
  final ConsultationRepository repository;

  GetChatHistoryUseCase({required this.repository});

  Future<List<Consultation>> call() async {
    return await repository.getChatHistory();
  }
}
