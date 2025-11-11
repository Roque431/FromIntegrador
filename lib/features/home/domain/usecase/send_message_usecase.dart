import '../entities/consultation.dart';
import '../repository/consultation_repository.dart';

class SendMessageUseCase {
  final ConsultationRepository repository;

  SendMessageUseCase({required this.repository});

  Future<({Consultation consultation, String response})> call({
    required String message,
    String? sessionId,
  }) async {
    print('🔵 UseCase - sessionId recibido: $sessionId');
    
    // Validaciones
    if (message.trim().isEmpty) {
      throw Exception('El mensaje no puede estar vacío');
    }

    if (message.trim().length < 3) {
      throw Exception('El mensaje debe tener al menos 3 caracteres');
    }

    // Ejecutar la consulta
    final result = await repository.sendMessage(
      message: message.trim(),
      sessionId: sessionId,
    );
    
    print('🟢 UseCase - sessionId en respuesta: ${result.consultation.sessionId}');
    return result;
  }
}
