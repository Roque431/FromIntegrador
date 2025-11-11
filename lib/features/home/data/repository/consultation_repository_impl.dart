import '../../domain/entities/consultation.dart';
import '../../domain/repository/consultation_repository.dart';
import '../datasource/consultation_datasource.dart';
import '../models/chat_message_request.dart';

class ConsultationRepositoryImpl implements ConsultationRepository {
  final ConsultationDataSource dataSource;

  ConsultationRepositoryImpl({required this.dataSource});

  @override
  Future<({Consultation consultation, String response})> sendMessage({
    required String message,
    String? sessionId,
  }) async {
    print('🔵 Repository - sessionId recibido: $sessionId');
    
    final request = ChatMessageRequest(
      message: message,
      sessionId: sessionId,
    );

    final response = await dataSource.sendMessage(request);

    print('🟢 Repository - sessionId en respuesta: ${response.sessionId}');
    
    // Si el backend devuelve una consulta completa
    if (response.consultation != null) {
      return (
        consultation: response.consultation!.toEntity(),
        response: response.response,
      );
    }

    // Si solo devuelve la respuesta, crear una consulta temporal
    final consultation = Consultation(
      id: response.sessionId,
      userId: '', // Se debería obtener del token o contexto
      query: message,
      response: response.response,
      sessionId: response.sessionId,
      createdAt: response.timestamp,
      status: 'completed',
    );

    return (
      consultation: consultation,
      response: response.response,
    );
  }

  @override
  Future<List<Consultation>> getChatHistory() async {
    final responses = await dataSource.getChatHistory();

    return responses
        .where((r) => r.consultation != null)
        .map((r) => r.consultation!.toEntity())
        .toList();
  }
}
