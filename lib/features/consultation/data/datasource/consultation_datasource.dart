import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/consultation_model.dart';

class ConsultationDatasource {
  final ApiClient _apiClient;

  ConsultationDatasource(this._apiClient);

  /// Enviar mensaje al chatbot y obtener respuesta
  Future<ConsultationResponseModel> sendMessage({
    required String message,
    String? sessionId,
  }) async {
    final body = <String, dynamic>{
      'texto_original': message,
    };
    
    if (sessionId != null) {
      body['session_id'] = sessionId;
    }

    final data = await _apiClient.post(
      ApiEndpoints.chatMessage,
      body: body,
      requiresAuth: true,
    );

    return ConsultationResponseModel.fromJson(data as Map<String, dynamic>);
  }

  /// Obtener historial de conversaciones del usuario
  Future<List<ConsultationModel>> getChatHistory({
    required String usuarioId,
    int? limit,
    int? offset,
  }) async {
    var endpoint = '${ApiEndpoints.chatHistory}?usuario_id=$usuarioId';
    
    if (limit != null) {
      endpoint += '&limit=$limit';
    }
    if (offset != null) {
      endpoint += '&offset=$offset';
    }

    final data = await _apiClient.get(
      endpoint,
      requiresAuth: true,
    );

    final List<dynamic> list = data as List<dynamic>;
    return list.map((json) => ConsultationModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Obtener sesiones de chat
  Future<List<Map<String, dynamic>>> getChatSessions({
    required String usuarioId,
  }) async {
    final endpoint = '${ApiEndpoints.chatSessions}?usuario_id=$usuarioId';

    final data = await _apiClient.get(
      endpoint,
      requiresAuth: true,
    );

    return (data as List<dynamic>).cast<Map<String, dynamic>>();
  }

  /// Obtener una sesión específica por ID
  Future<Map<String, dynamic>> getChatSessionById(String sessionId) async {
    final data = await _apiClient.get(
      ApiEndpoints.chatSessionById(sessionId),
      requiresAuth: true,
    );

    return data as Map<String, dynamic>;
  }
}
