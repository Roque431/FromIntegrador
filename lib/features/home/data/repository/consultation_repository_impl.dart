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
      // Normaliza: si viene vacío, pásalo como null
      sessionId: (sessionId != null && sessionId.isNotEmpty) ? sessionId : null,
      
    );

    final response = await dataSource.sendMessage(request);

    print('🟢 Repository - sessionId en respuesta: ${response.sessionId}');
    print('🟢 Repository - profesionistas: ${response.profesionistas.length}');
    print('🟢 Repository - anunciantes: ${response.anunciantes.length}');
    print('🟢 Repository - sugerencias: ${response.sugerencias.length}');
    
    // Si el backend devuelve una consulta completa
    if (response.consultation != null) {
      // Retornamos la entidad que ya incluye los nuevos campos
      return (
        consultation: response.consultation!.toEntity(),
        response: response.response,
      );
    }

    // Si solo devuelve la respuesta, crear una consulta con todos los datos
    final consultation = Consultation(
      id: response.sessionId,
      userId: '', // Se debería obtener del token o contexto
      query: message,
      response: response.response,
      sessionId: response.sessionId,
      createdAt: response.timestamp,
      status: 'completed',
      // Nuevos campos para cards interactivas
      profesionistas: response.profesionistas,
      anunciantes: response.anunciantes,
      sugerencias: response.sugerencias,
      ofrecerMatch: response.ofrecerMatch,
      ofrecerForo: response.ofrecerForo,
      cluster: response.cluster,
      sentimiento: response.sentimiento,
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
