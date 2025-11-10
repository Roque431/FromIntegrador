import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/chat_message_request.dart';
import '../models/chat_message_response.dart';

abstract class ConsultationDataSource {
  Future<ChatMessageResponse> sendMessage(ChatMessageRequest request);
  Future<List<ChatMessageResponse>> getChatHistory();
}

class ConsultationDataSourceImpl implements ConsultationDataSource {
  final ApiClient apiClient;

  ConsultationDataSourceImpl({required this.apiClient});

  @override
  Future<ChatMessageResponse> sendMessage(ChatMessageRequest request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.chatMessage,
        body: request.toJson(),
        requiresAuth: true,
      );

      return ChatMessageResponse.fromJson(response);
    } catch (e) {
      throw ApiException('Error al enviar mensaje: $e');
    }
  }

  @override
  Future<List<ChatMessageResponse>> getChatHistory() async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.chatHistory,
        requiresAuth: true,
      );

      if (response is List) {
        return response
            .map((item) => ChatMessageResponse.fromJson(item))
            .toList();
      }

      // Si el response viene con un wrapper (ej: {data: [...], success: true})
      if (response is Map<String, dynamic> && response['data'] is List) {
        return (response['data'] as List)
            .map((item) => ChatMessageResponse.fromJson(item))
            .toList();
      }

      return [];
    } catch (e) {
      throw ApiException('Error al obtener historial: $e');
    }
  }
}
