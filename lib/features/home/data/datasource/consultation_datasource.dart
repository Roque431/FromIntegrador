import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
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
  final SharedPreferences sharedPreferences;

  ConsultationDataSourceImpl({
    required this.apiClient,
    required this.sharedPreferences,
  });

  @override
  Future<ChatMessageResponse> sendMessage(ChatMessageRequest request) async {
    try {
      // Obtener usuario_id de SharedPreferences
      final userId = sharedPreferences.getString('user_id');
      if (userId == null) {
        throw ApiException('Usuario no autenticado');
      }

      // Usar el session_id que viene en el request, o generar uno nuevo solo la primera vez
      final sessionId = request.sessionId ?? const Uuid().v4();

      print('🔵 Datasource - sessionId del request: ${request.sessionId}');
      print('🔵 Datasource - sessionId final a enviar: $sessionId');

      final body = <String, dynamic>{
        'texto': request.message,
      };

      final queryParams = <String, String>{
        'usuario_id': userId,
        'session_id': sessionId,
      };

      final response = await apiClient.post(
        ApiEndpoints.chatMessage,
        body: body,
        queryParameters: queryParams,
        requiresAuth: true,
      );

      print('🟢 Datasource - sessionId en respuesta: ${response['session_id']}');

      return ChatMessageResponse.fromJson(response);
    } catch (e) {
      throw ApiException('Error al enviar mensaje: $e');
    }
  }

  @override
  Future<List<ChatMessageResponse>> getChatHistory() async {
    try {
      // Obtener el usuario_id de SharedPreferences
      final userId = sharedPreferences.getString('user_id');
      if (userId == null) {
        print('❌ No se encontró user_id en SharedPreferences');
        return [];
      }

      // Usar el endpoint correcto con usuario_id en path
      final endpoint = ApiEndpoints.chatHistory(userId);
      
      final params = <String, String>{};
      // Parámetros de paginación por si el backend los requiere para evitar 422
      params['limit'] = '50';
      params['offset'] = '0';

      print('🔍 Solicitud historial => endpoint: $endpoint, params: $params');

      final response = await apiClient.get(
        endpoint,
        queryParameters: params.isNotEmpty ? params : null,
        requiresAuth: true,
      );

      // El backend devuelve: { usuario_id, total, limit, offset, consultas: [...] }
      if (response is Map<String, dynamic> && response['consultas'] is List) {
        return (response['consultas'] as List)
            .map((item) => ChatMessageResponse.fromJson(item))
            .toList();
      }
      
      if (response is List) {
        return response
            .map((item) => ChatMessageResponse.fromJson(item))
            .toList();
      }

      // Si el backend devuelve con un wrapper (ej: {data: [...], success: true})
      if (response is Map<String, dynamic> && response['data'] is List) {
        return (response['data'] as List)
            .map((item) => ChatMessageResponse.fromJson(item))
            .toList();
      }

      return [];
    } catch (e) {
      // Si es un error de validación 422 podemos devolver lista vacía para que la UI muestre mensaje amigable
      final msg = e.toString();
      print('❌ Error historial: $msg');
      if (msg.contains('validación') || msg.contains('422')) {
        return [];
      }
      throw ApiException('Error al obtener historial: $e');
    }
  }
}
