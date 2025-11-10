import '../entities/consultation.dart';

abstract class ConsultationRepository {
  Future<({Consultation consultation, String response})> sendMessage({
    required String message,
    String? sessionId,
  });

  Future<List<Consultation>> getChatHistory();
}
